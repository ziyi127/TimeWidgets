import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_widgets/models/weather_model.dart';
import 'package:time_widgets/utils/logger.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1';
  static const String _geocodingUrl = 'https://geocoding-api.open-meteo.com/v1';

  // Get weather by coordinates
  Future<WeatherData?> getWeather(double lat, double lon, {String? cityName}) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,pressure_msl&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max&timezone=auto');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseWeatherData(data, cityName ?? 'Unknown');
      } else {
        Logger.e('Failed to fetch weather: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      Logger.e('Error fetching weather: $e');
      return null;
    }
  }

  // Search city
  Future<List<Map<String, dynamic>>> searchCity(String query) async {
    try {
      final url = Uri.parse('$_geocodingUrl/search?name=$query&count=5&language=zh&format=json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null) {
          return List<Map<String, dynamic>>.from(data['results']);
        }
      }
      return [];
    } catch (e) {
      Logger.e('Error searching city: $e');
      return [];
    }
  }

  WeatherData _parseWeatherData(Map<String, dynamic> data, String cityName) {
    final current = data['current'];
    final daily = data['daily'];

    // Parse WMO code
    final weatherCode = current['weather_code'];
    final weatherInfo = _getWeatherInfo(weatherCode);

    return WeatherData(
      cityName: cityName,
      description: weatherInfo['description'],
      temperature: (current['temperature_2m'] as num).toInt(),
      temperatureRange: '${(daily['temperature_2m_min'][0] as num).toInt()}°C~${(daily['temperature_2m_max'][0] as num).toInt()}°C',
      aqiLevel: 0, // OpenMeteo free tier doesn't support AQI easily
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      wind: '${current['wind_speed_10m']} km/h',
      pressure: (current['pressure_msl'] as num).toDouble(),
      sunrise: daily['sunrise'][0].toString().split('T').last,
      sunset: daily['sunset'][0].toString().split('T').last,
      weatherType: weatherCode,
      weatherIcon: weatherInfo['icon'],
      feelsLike: (current['temperature_2m'] as num).toInt(), // Approximation
      visibility: 'N/A',
      uvIndex: daily['uv_index_max'][0].toString(),
      pubTime: DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> _getWeatherInfo(int code) {
    // WMO Weather interpretation codes (WW)
    // 0: Clear sky
    // 1, 2, 3: Mainly clear, partly cloudy, and overcast
    // 45, 48: Fog and depositing rime fog
    // 51, 53, 55: Drizzle: Light, moderate, and dense intensity
    // 56, 57: Freezing Drizzle: Light and dense intensity
    // 61, 63, 65: Rain: Light, moderate and heavy intensity
    // 66, 67: Freezing Rain: Light and heavy intensity
    // 71, 73, 75: Snow fall: Slight, moderate, and heavy intensity
    // 77: Snow grains
    // 80, 81, 82: Rain showers: Slight, moderate, and violent
    // 85, 86: Snow showers slight and heavy
    // 95 *: Thunderstorm: Slight or moderate
    // 96, 99 *: Thunderstorm with slight and heavy hail

    switch (code) {
      case 0: return {'description': '晴', 'icon': 'weather_0.png'};
      case 1: 
      case 2: 
      case 3: return {'description': '多云', 'icon': 'weather_1.png'};
      case 45: 
      case 48: return {'description': '雾', 'icon': 'weather_18.png'};
      case 51: 
      case 53: 
      case 55: return {'description': '小雨', 'icon': 'weather_7.png'};
      case 56:
      case 57: return {'description': '冻雨', 'icon': 'weather_10.png'};
      case 61: 
      case 63: 
      case 65: return {'description': '雨', 'icon': 'weather_8.png'};
      case 66:
      case 67: return {'description': '雨夹雪', 'icon': 'weather_6.png'};
      case 71: 
      case 73: 
      case 75: return {'description': '雪', 'icon': 'weather_14.png'};
      case 77: return {'description': '小雪', 'icon': 'weather_14.png'};
      case 80: 
      case 81: 
      case 82: return {'description': '阵雨', 'icon': 'weather_3.png'};
      case 85: 
      case 86: return {'description': '阵雪', 'icon': 'weather_13.png'};
      case 95: 
      case 96: 
      case 99: return {'description': '雷雨', 'icon': 'weather_4.png'};
      default: return {'description': '未知', 'icon': 'weather_0.png'};
    }
  }
}
