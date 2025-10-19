import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/services/ipc_service.dart';

class ApiService {
  static const bool _useIpc = true; // 设置为true使用IPC，false使用HTTP
  static const String _baseUrl = 'http://localhost:3000/api';
  static final IpcService _ipcService = IpcService();
  
  // 获取课程表数据
  Future<Timetable> getTimetable(DateTime date) async {
    if (_useIpc) {
      return _ipcService.getTimetable(date);
    }
    
    // HTTP实现
    final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final url = '$_baseUrl/timetable?date=$dateString';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Course> courses = [];
        
        if (data['data'] != null) {
          for (var courseData in data['data']) {
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
        throw Exception('Failed to load timetable: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // 获取当前课程
  Future<Course?> getCurrentCourse() async {
    if (_useIpc) {
      return _ipcService.getCurrentCourse();
    }
    
    // HTTP实现
    final url = '$_baseUrl/current-course';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['data'] == null) {
          return null;
        }
        
        return Course(
          subject: data['data']['subject'],
          teacher: data['data']['teacher'],
          time: data['data']['time'],
          classroom: data['data']['classroom'],
          isCurrent: data['data']['isCurrent'] ?? true,
        );
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load current course: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // 获取天气信息
  Future<WeatherData> getWeather() async {
    if (_useIpc) {
      return _ipcService.getWeather();
    }
    
    // HTTP实现
    try {
      final proxyUrl = '$_baseUrl/weather';
      final response = await http.get(Uri.parse(proxyUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data['data']);
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // 获取倒计时信息
  Future<CountdownData> getCountdown() async {
    if (_useIpc) {
      return _ipcService.getCountdown();
    }
    
    // HTTP实现
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/countdown'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CountdownData.fromJson(data['data']);
      } else {
        throw Exception('Failed to load countdown: ${response.statusCode}');
      }
    } catch (e) {
      // 如果网络请求失败，返回模拟数据
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