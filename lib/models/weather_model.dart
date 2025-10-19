class WeatherData {
  final String cityName;
  final String description;
  final int temperature;
  final String temperatureRange;
  final int aqiLevel;
  final int humidity;
  final String wind;
  final int pressure;
  final String sunrise;
  final String sunset;
  final int weatherType;
  final String weatherIcon;

  WeatherData({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.temperatureRange,
    required this.aqiLevel,
    required this.humidity,
    required this.wind,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.weatherType,
    required this.weatherIcon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['city_name'] ?? 'Unknown',
      description: json['description'] ?? 'Unknown',
      temperature: int.tryParse(json['temperature'].toString().replaceAll('℃', '')) ?? 0,
      temperatureRange: json['temperature_range'] ?? '0℃~0℃',
      aqiLevel: json['aqilevel'] ?? 0,
      humidity: json['humidity'] ?? 0,
      wind: json['wind'] ?? 'Unknown',
      pressure: json['pressure'] ?? 0,
      sunrise: _formatTime(json['sunrise']),
      sunset: _formatTime(json['sunset']),
      weatherType: json['weather_type'] ?? 0,
      weatherIcon: _getWeatherIcon(json['weather_type'] ?? 0),
    );
  }

  static String _formatTime(int milliseconds) {
    if (milliseconds == 0) return '00:00';
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String _getWeatherIcon(int weatherType) {
    // 根据天气类型返回对应的图标路径
    switch (weatherType) {
      case 0: // 晴
        return 'assets/icons/weather_0.png';
      case 1: // 多云
        return 'assets/icons/weather_1.png';
      case 2: // 阴
        return 'assets/icons/weather_2.png';
      case 3: // 小雨
        return 'assets/icons/weather_3.png';
      case 4: // 中雨
        return 'assets/icons/weather_4.png';
      case 12: // 雪
        return 'assets/icons/weather_12.png';
      case 13: // 雾
        return 'assets/icons/weather_13.png';
      case 18: // 沙尘
        return 'assets/icons/weather_18.png';
      case 22: // 雷阵雨
        return 'assets/icons/weather_22.png';
      case 24: // 冰雹
        return 'assets/icons/weather_24.png';
      default:
        return 'assets/icons/weather_0.png'; // 默认晴天
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'city_name': cityName,
      'description': description,
      'temperature': temperature,
      'temperature_range': temperatureRange,
      'aqilevel': aqiLevel,
      'humidity': humidity,
      'wind': wind,
      'pressure': pressure,
      'sunrise': sunrise,
      'sunset': sunset,
      'weather_type': weatherType,
      'weather_icon': weatherIcon,
    };
  }
}