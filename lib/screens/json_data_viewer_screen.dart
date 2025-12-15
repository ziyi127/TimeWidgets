import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_widgets/models/timetable_edit_model.dart';
import 'package:time_widgets/services/timetable_storage_service.dart';

class JsonDataViewerScreen extends StatefulWidget {
  const JsonDataViewerScreen({super.key});

  @override
  State<JsonDataViewerScreen> createState() => _JsonDataViewerScreenState();
}

class _JsonDataViewerScreenState extends State<JsonDataViewerScreen> {
  final TimetableStorageService _storageService = TimetableStorageService();
  TimetableData? _timetableData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTimetableData();
  }

  Future<void> _loadTimetableData() async {
    try {
      final data = await _storageService.loadTimetableData();
      setState(() {
        _timetableData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '加载数据失败: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _exportToJson() async {
    if (_timetableData == null) return;

    try {
      final jsonData = _timetableData!.toJson();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);
      
      await Clipboard.setData(ClipboardData(text: jsonString));
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('JSON数据已复制到剪贴板')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导出失败: $e')),
      );
    }
  }

  Future<void> _importFromJson() async {
    try {
      final clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData?.text == null || clipboardData!.text!.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('剪贴板中没有JSON数据')),
        );
        return;
      }

      final jsonString = clipboardData.text!;
      final jsonData = jsonDecode(jsonString);
      final timetableData = TimetableData.fromJson(jsonData);

      await _storageService.saveTimetableData(timetableData);
      await _loadTimetableData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('JSON数据导入成功')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导入失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON数据查看器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportToJson,
            tooltip: '导出JSON',
          ),
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: _importFromJson,
            tooltip: '导入JSON',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _buildJsonViewer(),
    );
  }

  Widget _buildJsonViewer() {
    if (_timetableData == null) return const SizedBox.shrink();

    final jsonData = _timetableData!.toJson();
    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '课表数据概览',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildDataOverview(),
          const SizedBox(height: 24),
          Text(
            '完整JSON数据',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: SelectableText(
              jsonString,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('课程数量: ${_timetableData!.courses.length}'),
            const SizedBox(height: 8),
            Text('时间段数量: ${_timetableData!.timeSlots.length}'),
            const SizedBox(height: 8),
            Text('日课表数量: ${_timetableData!.dailyCourses.length}'),
          ],
        ),
      ),
    );
  }
}