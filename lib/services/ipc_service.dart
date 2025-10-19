import 'dart:convert';
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/models/countdown_model.dart';

class IpcService {
  static const String _wsUrl = 'ws://localhost:8081'; // WebSocket服务器地址
  static final IpcService _instance = IpcService._internal();
  dynamic _socket;
  
  factory IpcService() {
    return _instance;
  }
  
  IpcService._internal();
  
  // 连接到WebSocket服务器
  Future<void> connect() async {
    try {
      // 在Web环境中使用WebSocket
      _socket = await _connectWebSocket();
      print('已连接到WebSocket服务器');
    } catch (e) {
      print('连接WebSocket失败: $e');
      throw Exception('Failed to connect to WebSocket server: $e');
    }
  }
  
  // 连接WebSocket的通用方法
  Future<dynamic> _connectWebSocket() async {
    // 这里需要根据平台选择不同的WebSocket实现
    // 由于我们在Web环境中，使用HTML WebSocket
    return _createHtmlWebSocket();
  }
  
  // 创建HTML WebSocket
  dynamic _createHtmlWebSocket() {
    // 在Web环境中，我们可以使用dart:html的WebSocket
    // 但由于Flutter Web的限制，我们需要使用package:web_socket_channel
    // 这里使用一个简化的实现
    throw UnimplementedError('WebSocket implementation needed for Flutter Web');
  }
  
  // 断开连接
  void disconnect() {
    if (_socket != null) {
      // 关闭WebSocket连接
      print('已断开WebSocket连接');
      _socket = null;
    }
  }
  
  // 发送请求并获取响应
  Future<Map<String, dynamic>> _sendRequest(String type, [Map<String, dynamic>? params]) async {
    if (_socket == null) {
      await connect();
    }
    
    try {
      // 构建请求
      final request = {
        'type': type,
        if (params != null) 'params': params,
      };
      
      // 发送请求并获取响应
      // 这里需要根据具体的WebSocket实现来编写
      throw UnimplementedError('WebSocket send/receive implementation needed');
    } catch (e) {
      print('IPC请求失败: $e');
      throw Exception('IPC request failed: $e');
    }
  }
  
  // 获取课程表数据
  Future<Timetable> getTimetable(DateTime date) async {
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
  
  // 获取倒计时信息
  Future<CountdownData> getCountdown() async {
    try {
      final response = await _sendRequest('countdown');
      
      if (response['success'] == true) {
        return CountdownData.fromJson(response['data']);
      } else {
        throw Exception('Failed to load countdown: ${response['error']}');
      }
    } catch (e) {
      // 如果IPC请求失败，返回模拟数据
      return CountdownData(
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