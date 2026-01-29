import 'package:flutter/material.dart';
import 'package:time_widgets/services/interconnection_service.dart';
import 'package:time_widgets/utils/md3_typography_styles.dart';

class InterconnectionScreen extends StatefulWidget {
  const InterconnectionScreen({super.key});

  @override
  State<InterconnectionScreen> createState() => _InterconnectionScreenState();
}

class _InterconnectionScreenState extends State<InterconnectionScreen> {
  final _service = InterconnectionService();
  bool _isMaster = false;
  bool _isSlave = false;
  bool _initialized = false;

  bool _isSyncing = false;

  Future<void> _handleGlobalSync() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    
    try {
      await _service.reconnectPairedDevices();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('同步完成')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('同步过程中出现错误: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    await _service.initialize();
    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  @override
  void dispose() {
    _service.stopDiscovery();
    _service.stopBroadcasting();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设备互联'),
      ),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isMaster && !_isSlave) {
      return _buildModeSelection();
    } else if (_isMaster) {
      return _buildMasterView();
    } else {
      return _buildSlaveView();
    }
  }

  Widget _buildModeSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '请选择设备角色',
            style: MD3TypographyStyles.headlineMedium(context),
          ),
          const SizedBox(height: 32),
          _buildRoleCard(
            title: '主设备',
            subtitle: '扫描并连接其他设备，同步课表',
            icon: Icons.upload,
            onTap: () {
              setState(() {
                _isMaster = true;
              });
              _service.startDiscovery();
            },
          ),
          const SizedBox(height: 16),
          _buildRoleCard(
            title: '从设备',
            subtitle: '等待连接，接收课表',
            icon: Icons.download,
            onTap: () {
              setState(() {
                _isSlave = true;
              });
              _service.startBroadcasting();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: MD3TypographyStyles.titleLarge(context)),
                    const SizedBox(height: 8),
                    Text(subtitle, style: MD3TypographyStyles.bodyMedium(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMasterView() {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '已配对设备',
                      style: MD3TypographyStyles.titleMedium(context),
                    ),
                    _isSyncing 
                        ? const SizedBox(
                            width: 24, 
                            height: 24, 
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: const Icon(Icons.sync),
                            tooltip: '立即同步所有',
                            onPressed: _handleGlobalSync,
                          ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<DiscoveredDevice>>(
                  stream: _service.pairedDevicesStream,
                  initialData: const [],
                  builder: (context, snapshot) {
                    final devices = snapshot.data ?? [];
                    if (devices.isEmpty) {
                      return Center(
                        child: Text(
                          '暂无配对设备',
                          style: MD3TypographyStyles.bodyMedium(context)
                              .copyWith(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return ListTile(
                          leading: const Icon(Icons.phonelink_ring,
                              color: Colors.green,),
                          title: Text(device.name),
                          subtitle: Text(device.ip),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.sync),
                                onPressed: () => _connectToDevice(device, isPairing: false),
                                tooltip: '同步',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _service.unpairDevice(device),
                                tooltip: '解绑',
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '发现新设备...',
                  style: MD3TypographyStyles.titleMedium(context),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<DiscoveredDevice>>(
                  stream: _service.devicesStream,
                  initialData: const [],
                  builder: (context, snapshot) {
                    final devices = snapshot.data ?? [];
                    if (devices.isEmpty) {
                      return Center(
                        child: Text(
                          '正在扫描...',
                          style: MD3TypographyStyles.bodyLarge(context),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return ListTile(
                          leading: const Icon(Icons.devices),
                          title: Text(device.name),
                          subtitle: Text(device.ip),
                          trailing: ElevatedButton(
                            onPressed: () => _connectToDevice(device, isPairing: true),
                            child: const Text('连接并配对'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _connectToDevice(DiscoveredDevice device, {required bool isPairing}) async {
    try {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      if (isPairing) {
        await _service.pairDevice(device);
      } else {
        await _service.connectAndSync(device);
      }

      if (mounted) {
        Navigator.pop(context); // Pop loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已成功同步到 ${device.name}')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Pop loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('同步失败: $e')),
        );
      }
    }
  }

  Widget _buildSlaveView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_tethering, size: 64, color: Colors.blue),
          const SizedBox(height: 24),
          Text(
            '本机名称',
            style: MD3TypographyStyles.titleMedium(context),
          ),
          const SizedBox(height: 8),
          Text(
            _service.deviceName,
            style: MD3TypographyStyles.headlineMedium(context).copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            '等待主设备连接...',
            style: MD3TypographyStyles.bodyLarge(context),
          ),
          const SizedBox(height: 8),
          Text(
            '请在主设备上选择连接此设备',
            style: MD3TypographyStyles.bodySmall(context),
          ),
        ],
      ),
    );
  }
}
