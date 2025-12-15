import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/services/ipc_service.dart';
import 'package:time_widgets/services/cache_service.dart';
import 'package:time_widgets/utils/error_handler.dart';
import 'package:time_widgets/services/localization_service.dart';
import 'package:time_widgets/utils/logger.dart';

class ApiService {
  static const bool _useIpc = true; // 设置为true使用IPC，false使用HTTP
  static const String _baseUrl = 'http://localhost:3000/api';
  static final IpcService _ipcService = IpcService();
  
  // 小米天气API配置
  static const String _xiaomiWeatherBaseUrl = 'https://weatherapi.market.xiaomi.com/wtr-v3/weather/all';
  static const String _xiaomiAppKey = 'weather20151024';
  static const String _xiaomiSign = 'zUFJoAR2ZVrDy1vF3D07';
  
  // 城市代码映射（部分常用城市）
  static const Map<String, String> _cityLocationKeys = {
    '北京': 'weathercn:101010100',
    '上海': 'weathercn:101020100',
    '广州': 'weathercn:101280101',
    '深圳': 'weathercn:101280601',
    '杭州': 'weathercn:101210101',
    '南京': 'weathercn:101190101',
    '武汉': 'weathercn:101200101',
    '成都': 'weathercn:101270101',
    '西安': 'weathercn:101110101',
    '重庆': 'weathercn:101040100',
  };
  
  // 获取课程表数�?  Future<Timetable> getTimetable(DateTime date) async {
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
  
  // 获取天气信息（带缓存回退�?  Future<WeatherData> getWeather({String city = '北京'}) async {
    try {
      // 优先尝试小米天气API
      final weather = await _getXiaomiWeather(city);
      if (weather != null) {
        // 成功获取后缓存数�?        await CacheService.cacheWeatherData(weather);
        return weather;
      }
      
      // 回退到IPC或HTTP
      if (_useIpc) {
        final weather = await _ipcService.getWeather();
        await CacheService.cacheWeatherData(weather);
        return weather;
      }
      
      // HTTP实现
      final proxyUrl = '$_baseUrl/weather';
      final response = await http.get(Uri.parse(proxyUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weather = WeatherData.fromJson(data['data']);
        await CacheService.cacheWeatherData(weather);
        return weather;
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      // 网络请求失败，尝试使用缓存数�?      final appError = ErrorHandler.handleNetworkError(e);
      ErrorHandler.logError(appError);
      
      final cachedWeather = await CacheService.getCachedWeatherData();
      if (cachedWeather != null) {
        return cachedWeather;
      }
      
      throw Exception(appError.userMessage ?? LocalizationService.getString('network_error'));
    }
  }

  /// 从小米天气API获取天气数据
  Future<WeatherData?> _getXiaomiWeather(String city) async {
    try {
      final locationKey = _cityLocationKeys[city] ?? _cityLocationKeys['北京']!;
      
      // 构建请求URL
      final uri = Uri.parse(_xiaomiWeatherBaseUrl).replace(queryParameters: {
        'latitude': '0',
        'longitude': '0',
        'locationKey': locationKey,
        'days': '5',
        'appKey': _xiaomiAppKey,
        'sign': _xiaomiSign,
        'isGlobal': 'false',
        'locale': 'zh_cn',
      });
      
      Logger.d('Requesting Xiaomi Weather API: $uri');
      
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Logger.d('Xiaomi Weather API Response: ${response.body.substring(0, 500)}...');
        
        if (data != null) {
          return WeatherData.fromXiaomiJson(data);
        }
      } else {
        Logger.e('Xiaomi Weather API failed with status: ${response.statusCode}');
        Logger.e('Response body: ${response.body}');
      }
    } catch (e) {
      Logger.e('Error fetching Xiaomi weather: $e');
    }
    
    return null;
  }
  
  // 获取倒计时信息（带缓存回退�?  Future<CountdownData> getCountdown() async {
    try {
      if (_useIpc) {
        final countdown = await _ipcService.getCountdown();
        // 成功获取后缓存数�?        await CacheService.cacheCountdownData(countdown);
        return countdown;
      }
      
      // HTTP实现
      final response = await http.get(
        Uri.parse('$_baseUrl/countdown'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final countdown = CountdownData.fromJson(data['data']);
        // 成功获取后缓存数�?        await CacheService.cacheCountdownData(countdown);
        return countdown;
      } else {
        throw Exception('Failed to load countdown: ${response.statusCode}');
      }
    } catch (e) {
      // 网络请求失败，尝试使用缓存数�?      final appError = ErrorHandler.handleNetworkError(e);
      ErrorHandler.logError(appError);
      
      final cachedCountdown = await CacheService.getCachedCountdownData();
      if (cachedCountdown != null) {
        return cachedCountdown;
      }
      
      // 如果没有缓存，返回默认数�?      return CountdownData(
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
