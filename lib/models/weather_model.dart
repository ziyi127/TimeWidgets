class WeatherData {

  const WeatherData({
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
    required this.feelsLike,
    required this.visibility,
    required this.uvIndex,
    required this.pubTime,
  });

  /// 从小米天气API数据创建WeatherData对象
  factory WeatherData.fromXiaomiJson(Map<String, dynamic> json) {
    final current = json['current'] ?? {};
    final aqi = json['aqi'] ?? {};
    final forecastDaily = json['forecastDaily'] ?? {};
    
    // 解析当前温度
    final temperature = int.tryParse(current['temperature']?['value']?.toString() ?? '0') ?? 0;
    
    // 解析体感温度
    final feelsLike = int.tryParse(current['feelsLike']?['value']?.toString() ?? '0') ?? 0;
    
    // 解析湿度
    final humidity = int.tryParse(current['humidity']?['value']?.toString() ?? '0') ?? 0;
    
    // 解析气压
    final pressure = double.tryParse(current['pressure']?['value']?.toString() ?? '0') ?? 0.0;
    
    // 解析风向
    final windSpeed = current['wind']?['speed']?['value']?.toString() ?? '0';
    final wind = '${windSpeed}km/h';
    
    // 解析天气类型
    final weatherType = int.tryParse(current['weather']?.toString() ?? '0') ?? 0;
    
    // 解析AQI
    final aqiLevel = int.tryParse(aqi['aqi']?.toString() ?? '0') ?? 0;
    
    // 解析日出日落时间
    final sunRiseSet = forecastDaily['sunRiseSet']?['value']?[0] ?? {};
    final sunrise = _formatTimeFromISO(sunRiseSet['from']?.toString() ?? '');
    final sunset = _formatTimeFromISO(sunRiseSet['to']?.toString() ?? '');
    
    // 解析温度范围（从今日预报获取）
    final todayTemp = forecastDaily['temperature']?['value']?[0] ?? {};
    final tempMax = todayTemp['from']?.toString() ?? '0';
    final tempMin = todayTemp['to']?.toString() ?? '0';
    final temperatureRange = '$tempMin℃~$tempMax℃';
    
    // 其他信息
    final visibility = current['visibility']?['value']?.toString() ?? '';
    final uvIndex = current['uvIndex']?.toString() ?? '0';
    final pubTime = current['pubTime']?.toString() ?? '';
    
    return WeatherData(
      cityName: '北京', // 可以根据locationKey解析城市名
      description: _getWeatherDescription(weatherType),
      temperature: temperature,
      temperatureRange: temperatureRange,
      aqiLevel: aqiLevel,
      humidity: humidity,
      wind: wind,
      pressure: pressure,
      sunrise: sunrise,
      sunset: sunset,
      weatherType: weatherType,
      weatherIcon: _getWeatherIcon(weatherType),
      feelsLike: feelsLike,
      visibility: visibility,
      uvIndex: uvIndex,
      pubTime: pubTime,
    );
  }

  /// 兼容旧版本的fromJson方法
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    // 检查是否是小米天气API格式
    if (json.containsKey('current')) {
      return WeatherData.fromXiaomiJson(json);
    }
    
    // 安全地转换为int
    int safeParseInt(dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return int.tryParse(value.toString()) ?? defaultValue;
    }
    
    // 安全地转换为double
    double safeParseDouble(dynamic value, double defaultValue) {
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return double.tryParse(value.toString()) ?? defaultValue;
    }
    
    // 安全地转换为String
    String safeParseString(dynamic value, String defaultValue) {
      if (value == null) return defaultValue;
      return value.toString();
    }
    
    // 兼容旧格式
    return WeatherData(
      cityName: safeParseString(json['city_name'], 'Unknown'),
      description: safeParseString(json['description'], 'Unknown'),
      temperature: safeParseInt(json['temperature'], 0),
      temperatureRange: safeParseString(json['temperature_range'], '0℃~0℃'),
      aqiLevel: safeParseInt(json['aqilevel'], 0),
      humidity: safeParseInt(json['humidity'], 0),
      wind: safeParseString(json['wind'], 'Unknown'),
      pressure: safeParseDouble(json['pressure'], 0),
      sunrise: _formatTime(json['sunrise']),
      sunset: _formatTime(json['sunset']),
      weatherType: safeParseInt(json['weather_type'], 0),
      weatherIcon: _getWeatherIcon(safeParseInt(json['weather_type'], 0)),
      feelsLike: safeParseInt(json['feels_like'], 0),
      visibility: safeParseString(json['visibility'], ''),
      uvIndex: safeParseString(json['uv_index'], '0'),
      pubTime: safeParseString(json['pub_time'], ''),
    );
  }
  final String cityName;
  final String description;
  final int temperature;
  final String temperatureRange;
  final int aqiLevel;
  final int humidity;
  final String wind;
  final double pressure;
  final String sunrise;
  final String sunset;
  final int weatherType;
  final String weatherIcon;
  final int feelsLike;
  final String visibility;
  final String uvIndex;
  final String pubTime;

  static String _formatTime(dynamic value) {
    if (value == null) return '00:00';
    
    int milliseconds;
    if (value is String) {
      // 如果是字符串，尝试解析为毫秒数
      milliseconds = int.tryParse(value) ?? 0;
    } else if (value is int) {
      // 如果是整数，直接使用
      milliseconds = value;
    } else {
      // 其他类型，转换为字符串再解析
      milliseconds = int.tryParse(value.toString()) ?? 0;
    }
    
    if (milliseconds == 0) return '00:00';
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      // 如果解析失败，返回默认时间
      return '00:00';
    }
  }

  /// 从ISO时间字符串格式化时间
  static String _formatTimeFromISO(String isoTime) {
    if (isoTime.isEmpty) return '00:00';
    try {
      final date = DateTime.parse(isoTime);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '00:00';
    }
  }

  /// 根据天气代码获取天气描述
  static String _getWeatherDescription(int weatherType) {
    switch (weatherType) {
      case 0: return '晴';
      case 1: return '多云';
      case 2: return '阴';
      case 3: return '小雨';
      case 4: return '中雨';
      case 5: return '大雨';
      case 6: return '暴雨';
      case 7: return '小雪';
      case 8: return '中雪';
      case 9: return '大雪';
      case 10: return '暴雪';
      case 11: return '沙尘暴';
      case 12: return '雾';
      case 13: return '霾';
      case 14: return '霜冻';
      case 15: return '雨夹雪';
      case 16: return '雷阵雨';
      case 17: return '雷阵雨伴冰雹';
      case 18: return '沙尘';
      case 19: return '浮尘';
      case 20: return '扬沙';
      case 21: return '强沙尘暴';
      case 22: return '雷阵雨';
      case 23: return '雾';
      case 24: return '冰雹';
      default: return '晴';
    }
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
      case 12: // 雾
        return 'assets/icons/weather_12.png';
      case 13: // 霾
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
      'feels_like': feelsLike,
      'visibility': visibility,
      'uv_index': uvIndex,
      'pub_time': pubTime,
    };
  }
}
