import 'package:time_widgets/models/course_model.dart';
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/models/countdown_model.dart';
import 'package:time_widgets/services/api_service.dart';
import 'package:time_widgets/utils/logger.dart';

class TimetableService {
  final ApiService _apiService = ApiService();
  
  // 获取课程表数�?  Future<Timetable> getTimetable(DateTime date) async {
    try {
      // 尝试从真实API获取数据
      return await _apiService.getTimetable(date);
    } catch (e) {
      // 如果API调用失败，回退到模拟数�?      Logger.e('Failed to fetch timetable from API, using mock data: $e');
      await Future.delayed(const Duration(milliseconds: 500));
      
      return Timetable(
        date: date,
        courses: [
          Course(
            subject: '语文',
            teacher: 'A老师',
            time: '8:30~9:10',
            classroom: '101教室',
            isCurrent: true,
          ),
          Course(
            subject: '数学',
            teacher: 'B老师',
            time: '9:20~10:00',
            classroom: '102教室',
          ),
          Course(
            subject: '英语',
            teacher: 'C老师',
            time: '10:10~11:50',
            classroom: '103教室',
          ),
          Course(
            subject: '物理',
            teacher: 'D老师',
            time: '14:00~14:40',
            classroom: '104教室',
          ),
          Course(
            subject: '化学',
            teacher: 'E老师',
            time: '14:50~15:30',
            classroom: '105教室',
          ),
        ],
      );
    }
  }

  // 获取当前课程
  Future<Course?> getCurrentCourse() async {
    try {
      // 尝试从真实API获取数据
      return await _apiService.getCurrentCourse();
    } catch (e) {
      // 如果API调用失败，回退到模拟数�?      Logger.e('Failed to fetch current course from API, using mock data: $e');
      // 模拟当前课程
      return Course(
        subject: '语文',
        teacher: 'A老师',
        time: '8:30~9:10',
        classroom: '101教室',
        isCurrent: true,
      );
    }
  }

  // 获取天气信息
  Future<WeatherData> getWeather() async {
    try {
      // 尝试从真实API获取数据
      return await _apiService.getWeather();
    } catch (e) {
      // 如果API调用失败，回退到模拟数�?      Logger.e('Failed to fetch weather from API, using mock data: $e');
      // 模拟天气数据
      return WeatherData(
        cityName: '北京',
        description: '�?,
        temperature: 25,
        temperatureRange: '20℃~30�?,
        aqiLevel: 50,
        humidity: 40,
        wind: '3-4�?,
        pressure: 1013,
        sunrise: '06:00',
        sunset: '18:30',
        weatherType: 0,
        weatherIcon: 'weather_0.png',
        feelsLike: 26,
        visibility: '10km',
        uvIndex: '5',
        pubTime: DateTime.now().toIso8601String(),
      );
    }
  }

  // 获取倒计时信�?  Future<CountdownData> getCountdown() async {
    try {
      // 尝试从真实API获取数据
      return await _apiService.getCountdown();
    } catch (e) {
      // 如果API调用失败，回退到模拟数�?      Logger.e('Failed to fetch countdown from API, using mock data: $e');
      // 模拟倒计时数�?      return CountdownData(
        id: '1',
        title: '中�?,
        description: '中考倒计�?,
        targetDate: DateTime.now().add(const Duration(days: 10)),
        type: 'exam',
        progress: 0.5,
        category: 'Academic',
      );
    }
  }
}
