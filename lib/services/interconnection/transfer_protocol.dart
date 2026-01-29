import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:time_widgets/utils/logger.dart';

enum PacketType {
  handshake(0x01),
  syncData(0x02),
  heartbeat(0x03),
  ack(0x04),
  disconnect(0x05);

  final int value;
  const PacketType(this.value);

  static PacketType? fromValue(int value) {
    return PacketType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PacketType.heartbeat,
    );
  }
}

class TransferProtocol {
  static const int magicByte1 = 0x54; // T
  static const int magicByte2 = 0x57; // W
  static const int currentVersion = 1;
  static const int headerLength = 8;

  // Header: [Magic:2][Version:1][Type:1][Length:4]

  static List<int> createPacket(PacketType type, Map<String, dynamic> payload) {
    final jsonBytes = utf8.encode(jsonEncode(payload));
    
    // Compress using dart:io GZipCodec
    final compressed = GZipCodec().encode(jsonBytes);
    
    // Encrypt (Placeholder for now)
    final encrypted = compressed; 

    final length = encrypted.length;
    final header = Uint8List(headerLength);
    final data = ByteData.view(header.buffer);

    data.setUint8(0, magicByte1);
    data.setUint8(1, magicByte2);
    data.setUint8(2, currentVersion);
    data.setUint8(3, type.value);
    data.setUint32(4, length);

    return [...header, ...encrypted];
  }

  static Future<Map<String, dynamic>?> parsePacket(List<int> packetData) async {
    if (packetData.length < headerLength) return null;

    final headerView = ByteData.view(Uint8List.fromList(packetData.sublist(0, headerLength)).buffer);
    
    if (headerView.getUint8(0) != magicByte1 || headerView.getUint8(1) != magicByte2) {
      Logger.e('Invalid Magic Bytes');
      return null;
    }

    // final version = headerView.getUint8(2); // Check version if needed
    final typeVal = headerView.getUint8(3);
    final length = headerView.getUint32(4);

    if (packetData.length < headerLength + length) {
      // Incomplete packet
      return null; 
    }

    final payload = packetData.sublist(headerLength, headerLength + length);

    // Decrypt (Placeholder)
    final decrypted = payload;

    // Decompress
    try {
      final decompressed = GZipCodec().decode(decrypted);
      final jsonStr = utf8.decode(decompressed);
      return {
        'type': PacketType.fromValue(typeVal)?.name ?? 'unknown',
        'data': jsonDecode(jsonStr),
      };
    } catch (e) {
      Logger.e('Failed to parse packet: $e');
      return null;
    }
  }
}
