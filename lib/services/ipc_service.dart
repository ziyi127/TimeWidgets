import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/utils/logger.dart';

class IpcService {
  static const String _wsUrl = 'ws://localhost:8081'; // WebSocket服务器地址
  static final IpcService _instance = IpcService._internal();
  WebSocketChannel? _channel;
  
  factory IpcService() {
    return _instance;
  }
  
  IpcService._internal();
  
  // 连接到WebSocket服务�?  Future<void> connect() async {
    try {
      // 创建WebSocket连接
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      Logger.d('已连接到WebSocket服务�?);
    } catch (e) {
      Logger.e('连接WebSocket失败: $e');
      throw Exception('Failed to connect to WebSocket server: $e');
    }
  }
  
  // 断开连接
  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      Logger.d('已断开WebSocket连接');
      _channel = null;
    }
  }
  
  // 发送请求并获取响应
  Future<Map<String, dynamic>> _sendRequest(String type, [Map<String, dynamic>? params]) async {
    if (_channel == null) {
      await connect();
    }
    
    try {
      // 构建请求
      final request = {
        'type': type,
        if (params != null) 'params': params,
      };
      
      // 发送请�?      _channel!.sink.add(json.encode(request));
      
      // 等待响应
      final response = await _channel!.stream.first;
      final responseData = json.decode(response);
      
      return responseData;
    } catch (e) {
      Logger.e('IPC请求失败: $e');
      throw Exception('IPC request failed: $e');
    }
  }
  
  // 获取课程表数�?  Future<Timetable> getTimetable(DateTime date) async {
    try {
      final response = await _sendRequest('timetable');
      
      if (response['success'] == true) {
        final List<Course> courses = [];
        
        if (response['data'] != null) {
          for (var courseData in response['data']) {
            courses.add(Course(
              subject: courseData['subject'],
              teacher: courseData['teacher'],
              time: courseData['time'],
              classroom: courseData['classroom'],
              isCurrent: courseData['isCurrent'] ?? false,
            ));
          }
        }
        
        return Timetable(
          date: date,
          courses: courses,
        );
      } else {
        throw Exception('Failed to load timetable: ${response['error']}');
      }
    } catch (e) {
      throw Exception('IPC error: $e');
    }
  }
  
  // 获取当前课程
  Future<Course?> getCurrentCourse() async {
    try {
      final response = await _sendRequest('current-course');
      
      if (response['success'] == true) {
        if (response['data'] == null) {
          return null;
        }
        
        final data = response['data'];
        return Course(
          subject: data['subject'],
          teacher: data['teacher'],
          time: data['time'],
          classroom: data['classroom'],
          isCurrent: data['isCurrent'] ?? true,
        );
      } else {
        throw Exception('Failed to load current course: ${response['error']}');
      }
    } catch (e) {
      throw Exception('IPC error: $e');
    }
  }
  
  // 获取天气信息
  Future<WeatherData> getWeather() async {
    try {
      final response = await _sendRequest('weather');
      
      if (response['success'] == true) {
        return WeatherData.fromJson(response['data']);
      } else {
        throw Exception('Failed to load weather: ${response['error']}');
      }
    } catch (e) {
      throw Exception('IPC error: $e');
    }
  }
  
  // 获取倒计时信�?  Future<CountdownData> getCountdown() async {
    try {
      final response = await _sendRequest('countdown');
      
      if (response['success'] == true) {
        return CountdownData.fromJson(response['data']);
      } else {
        throw Exception('Failed to load countdown: ${response['error']}');
      }
    } catch (e) {
      // 如果IPC请求失败，返回模拟数�?      return CountdownData(
        id: '1',
        title: 'Final Exam',
        description: 'Computer Science Final Examination',
        targetDate: DateTime.now().add(const Duration(days: 45)),
        type: 'exam',
        progress: 0.65,
        category: 'Academic',
      );
    }
  }
}
