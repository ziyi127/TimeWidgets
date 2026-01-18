import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_widgets/models/settings_model.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/settings_service.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';
import 'package:time_widgets/utils/device_name_generator.dart';
import 'package:time_widgets/utils/logger.dart';

class DiscoveredDevice {

  final String name;
  final String ip;
  final int port;
  final DateTime lastSeen;
  final String? authToken;

  DiscoveredDevice({
    required this.name,
    required this.ip,
    required this.port,
    required this.lastSeen,
    this.authToken,
  });

  factory DiscoveredDevice.fromJson(Map<String, dynamic> json) {
    return DiscoveredDevice(
      name: json['name'] as String,
      ip: json['ip'] as String,
      port: json['port'] as int,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      authToken: json['authToken'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoveredDevice &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          ip == other.ip &&
          port == other.port;

  @override
  int get hashCode => name.hashCode ^ ip.hashCode ^ port.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ip': ip,
      'port': port,
      'lastSeen': lastSeen.toIso8601String(),
      'authToken': authToken,
    };
  }

  DiscoveredDevice copyWith({
    String? name,
    String? ip,
    int? port,
    DateTime? lastSeen,
    String? authToken,
  }) {
    return DiscoveredDevice(
      name: name ?? this.name,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      lastSeen: lastSeen ?? this.lastSeen,
      authToken: authToken ?? this.authToken,
    );
  }
}

class InterconnectionService {

  factory InterconnectionService() => _instance;

  InterconnectionService._internal();
  static final InterconnectionService _instance = InterconnectionService._internal();

  static const int _broadcastPort = 8899;
  static const int _syncPort = 8900;
  static const int _authRecoveryPort = 8901; // New port for auth recovery
  static const String _deviceNameKey = 'device_name';
  static const String _authTokenKey = 'auth_token';
  static const String _pairedDevicesKey = 'paired_devices';

  String? _deviceName;
  String? _authToken;
  RawDatagramSocket? _broadcastSocket;
  RawDatagramSocket? _authRecoverySocket;
  ServerSocket? _syncServer;
  Timer? _broadcastTimer;
  Timer? _cleanupTimer;

  // Master mode state
  final List<DiscoveredDevice> _discoveredDevices = [];
  final List<DiscoveredDevice> _pairedDevices = [];
  final StreamController<List<DiscoveredDevice>> _devicesController =
      StreamController<List<DiscoveredDevice>>.broadcast();
  final StreamController<List<DiscoveredDevice>> _pairedDevicesController =
      StreamController<List<DiscoveredDevice>>.broadcast();

  Stream<List<DiscoveredDevice>> get devicesStream => _devicesController.stream;
  Stream<List<DiscoveredDevice>> get pairedDevicesStream => _pairedDevicesController.stream;

  // Slave mode state
  bool _isBroadcasting = false;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceName = prefs.getString(_deviceNameKey);
    if (_deviceName == null) {
      _deviceName = DeviceNameGenerator.generate();
      await prefs.setString(_deviceNameKey, _deviceName!);
    }
    
    // Initialize Auth Token
    _authToken = prefs.getString(_authTokenKey);
    if (_authToken == null) {
      _authToken = _generateAuthToken();
      await prefs.setString(_authTokenKey, _authToken!);
    }

    await _loadPairedDevices();
    await reconnectPairedDevices();
  }

  String _generateAuthToken() {
    // Simple random token generation
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    return base64Encode(utf8.encode('AUTH-$random'));
  }

  String get deviceName => _deviceName ?? 'Unknown';

  // --- Paired Devices Management ---

  Future<void> _loadPairedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_pairedDevicesKey);
    if (jsonList != null) {
      _pairedDevices.clear();
      _pairedDevices.addAll(
        jsonList.map((e) => DiscoveredDevice.fromJson(jsonDecode(e) as Map<String, dynamic>)),
      );
      _pairedDevicesController.add(List.from(_pairedDevices));
    }
  }

  Future<void> _savePairedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _pairedDevices.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_pairedDevicesKey, jsonList);
    _pairedDevicesController.add(List.from(_pairedDevices));
  }

  Future<void> pairDevice(DiscoveredDevice device) async {
    // Check if already paired
    final index = _pairedDevices.indexWhere((d) => d.ip == device.ip);
    if (index != -1) {
      // Update info
      _pairedDevices[index] = device;
    } else {
      _pairedDevices.add(device);
    }
    await _savePairedDevices();
    
    // Perform initial sync
    await connectAndSync(device);
  }

  Future<void> unpairDevice(DiscoveredDevice device) async {
    _pairedDevices.removeWhere((d) => d.ip == device.ip);
    await _savePairedDevices();
  }

  Future<void> reconnectPairedDevices() async {
    if (_pairedDevices.isEmpty) return;
    
    Logger.i('Attempting to reconnect to ${_pairedDevices.length} paired devices...');
    for (int i = 0; i < _pairedDevices.length; i++) {
      final device = _pairedDevices[i];
      try {
        await connectAndSync(device);
      } catch (e) {
        Logger.w('Failed to auto-sync with paired device ${device.name} (${device.ip}): $e');
        // Try to recover IP via Auth Token Broadcast
        if (device.authToken != null) {
          Logger.i('Attempting IP recovery for ${device.name} via Auth Token...');
          await _broadcastAuthRecovery(device);
        }
      }
    }
  }

  Future<void> _broadcastAuthRecovery(DiscoveredDevice device) async {
    try {
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      socket.broadcastEnabled = true;
      
      final message = jsonEncode({
        'type': 'auth_recovery',
        'authToken': device.authToken,
        'targetName': device.name,
      });

      // Send multiple times to ensure delivery
      for (int i = 0; i < 3; i++) {
        socket.send(
          utf8.encode(message),
          InternetAddress('255.255.255.255'),
          _authRecoveryPort,
        );
        await Future.delayed(const Duration(milliseconds: 500));
      }
      socket.close();
    } catch (e) {
      Logger.e('Failed to broadcast auth recovery: $e');
    }
  }

  // --- Master Mode ---

  Future<void> startDiscovery() async {
    stopDiscovery(); // Ensure clean state
    _discoveredDevices.clear();
    _devicesController.add([]);

    try {
      _broadcastSocket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        _broadcastPort,
      );
      _broadcastSocket!.broadcastEnabled = true;
      _broadcastSocket!.listen(_handleBroadcastPacket);
      
      // Start Auth Recovery Listener (Master listens for replies from Slave? No, Slave listens for Master's call)
      // Actually, Master broadcasts "Where are you (AuthToken)?", Slave replies "I am here (New IP)".
      // So Master needs to listen for recovery replies.
      // Wait, let's keep it simple:
      // Master broadcasts on _authRecoveryPort.
      // Slave listens on _authRecoveryPort.
      // Slave replies to Master (direct UDP or Broadcast).
      // Master needs a listener for the reply.
      // Let's use the same _broadcastSocket for receiving discovery info, or a new one.
      // Ideally, the Slave should reply by broadcasting its presence again on _broadcastPort?
      // Yes, if Slave sees the auth recovery request, it can just trigger a standard broadcast immediately.
      // Then Master's existing discovery logic will pick it up (with new IP).
      // But we need to update the paired device IP automatically.
      
      // Let's refine:
      // 1. Master sends Auth Recovery Request (UDP Broadcast to 8901).
      // 2. Slave receives request on 8901.
      // 3. Slave checks token. If match, Slave sends standard Presence Broadcast (UDP to 8899).
      // 4. Master receives Presence Broadcast on 8899.
      // 5. Master checks if this "new" device matches a paired device (by name/auth token).
      // 6. If match but IP different, update paired device IP and sync.

      // So Master logic here is fine. Just need to ensure _handleBroadcastPacket handles updates.
      
      _cleanupTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        final now = DateTime.now();
        _discoveredDevices.removeWhere(
            (device) => now.difference(device.lastSeen).inSeconds > 10,);
        _devicesController.add(List.from(_discoveredDevices));
      });
      
      Logger.i('Started discovery on port $_broadcastPort');
    } catch (e) {
      Logger.e('Failed to start discovery: $e');
    }
  }

  void stopDiscovery() {
    _broadcastSocket?.close();
    _broadcastSocket = null;
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    Logger.i('Stopped discovery');
  }

  void _handleBroadcastPacket(RawSocketEvent event) async {
    if (event == RawSocketEvent.read) {
      final datagram = _broadcastSocket?.receive();
      if (datagram == null) return;

      try {
        final message = utf8.decode(datagram.data);
        final data = jsonDecode(message) as Map<String, dynamic>;
        
        // Filter out self if running on same network/machine logic could be added here
        // but since we don't know our own IP easily without checking interfaces, 
        // we'll rely on the user not to pick themselves if they see it (or filter by name).
        if (data['name'] == _deviceName) return; 

        final device = DiscoveredDevice(
          name: data['name'],
          ip: datagram.address.address, // Use the sender's IP
          port: data['port'],
          lastSeen: DateTime.now(),
          authToken: data['authToken'], // Capture auth token from broadcast if present
        );

        // Check if this matches a paired device but with different IP
        final pairedIndex = _pairedDevices.indexWhere((d) => 
            d.name == device.name && d.authToken == device.authToken);
            
        if (pairedIndex != -1) {
          final pairedDevice = _pairedDevices[pairedIndex];
          if (pairedDevice.ip != device.ip) {
            Logger.i('IP changed for paired device ${device.name}. Updating from ${pairedDevice.ip} to ${device.ip}');
            // Update paired device info
            _pairedDevices[pairedIndex] = device;
            await _savePairedDevices();
            _pairedDevicesController.add(List.from(_pairedDevices));
            
            // Auto-sync since we recovered it
            connectAndSync(device); 
          }
        }

        final index = _discoveredDevices.indexWhere((d) => d.ip == device.ip);
        if (index != -1) {
          _discoveredDevices[index] = device;
        } else {
          _discoveredDevices.add(device);
        }
        _devicesController.add(List.from(_discoveredDevices));
      } catch (e) {
        // Ignore malformed packets
      }
    }
  }

  Future<void> connectAndSync(DiscoveredDevice device) async {
    Socket? socket;
    try {
      socket = await Socket.connect(device.ip, device.port, timeout: const Duration(seconds: 5));
      
      // Prepare data
      final settings = SettingsService().currentSettings;
      final timetableData = await TimetableStorageService().loadTimetableData();
      
      final payload = {
        'type': 'sync',
        'settings': settings.toJson(),
        'timetable': timetableData.toJson(),
      };
      
      socket.write(jsonEncode(payload));
      await socket.flush();
      Logger.i('Synced data to ${device.name}');
    } catch (e) {
      Logger.e('Failed to sync with ${device.name}: $e');
      rethrow;
    } finally {
      socket?.destroy();
    }
  }

  // --- Slave Mode ---

  Future<void> startBroadcasting() async {
    stopBroadcasting(); // Ensure clean state
    _isBroadcasting = true;

    try {
      // Start Sync Server
      _syncServer = await ServerSocket.bind(InternetAddress.anyIPv4, _syncPort);
      _syncServer!.listen(_handleSyncConnection);
      Logger.i('Sync server started on $_syncPort');

      // Start UDP Broadcast
      // We don't need to bind to a specific port to send, but binding helps receive if we wanted to.
      // Here we just need a socket to send.
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      socket.broadcastEnabled = true;

      // Start Auth Recovery Listener (Slave listens for Master's call)
      _authRecoverySocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, _authRecoveryPort);
      _authRecoverySocket!.listen((event) {
        if (event == RawSocketEvent.read) {
          final datagram = _authRecoverySocket?.receive();
          if (datagram == null) return;
          try {
             final message = utf8.decode(datagram.data);
             final data = jsonDecode(message) as Map<String, dynamic>;
             if (data['type'] == 'auth_recovery' && data['authToken'] == _authToken) {
               Logger.i('Received auth recovery request from Master. Broadcasting presence...');
               // Trigger immediate broadcast
               _sendPresenceBroadcast(socket);
             }
          } catch (e) {
            // Ignore
          }
        }
      });
      Logger.i('Auth recovery listener started on $_authRecoveryPort');

      _broadcastTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (!_isBroadcasting) {
          timer.cancel();
          socket.close();
          return;
        }
        _sendPresenceBroadcast(socket);
      });
       Logger.i('Started broadcasting as $_deviceName');
    } catch (e) {
       Logger.e('Failed to start broadcasting: $e');
       _isBroadcasting = false;
    }
  }

  void _sendPresenceBroadcast(RawDatagramSocket socket) {
     final message = jsonEncode({
          'name': _deviceName,
          'port': _syncPort,
          'type': 'slave',
          'authToken': _authToken,
        });
        
        try {
          socket.send(
            utf8.encode(message),
            InternetAddress('255.255.255.255'),
            _broadcastPort,
          );
        } catch (e) {
          Logger.e('Error sending broadcast: $e');
        }
  }

  void stopBroadcasting() {
    _isBroadcasting = false;
    _broadcastTimer?.cancel();
    _broadcastTimer = null;
    _syncServer?.close();
    _syncServer = null;
    _authRecoverySocket?.close();
    _authRecoverySocket = null;
     Logger.i('Stopped broadcasting');
  }

  void _handleSyncConnection(Socket socket) {
    socket.listen(
      (data) async {
        try {
          final message = utf8.decode(data);
          final payload = jsonDecode(message) as Map<String, dynamic>;

          if (payload['type'] == 'sync') {
             Logger.i('Received sync data from master');
            if (payload['settings'] != null) {
              final settings = AppSettings.fromJson(payload['settings'] as Map<String, dynamic>);
              await SettingsService().saveSettings(settings);
            }

            if (payload['timetable'] != null) {
              final timetableData = TimetableData.fromJson(payload['timetable'] as Map<String, dynamic>);
              await TimetableStorageService().saveTimetableData(timetableData);
            }
          }
        } catch (e) {
          Logger.e('Error handling sync data: $e');
        } finally {
          socket.destroy();
        }
      },
      onError: (e) => Logger.e('Sync socket error: $e'),
      onDone: () => socket.destroy(),
    );
  }
  
  void dispose() {
    stopDiscovery();
    stopBroadcasting();
    _devicesController.close();
    _pairedDevicesController.close();
  }
}
