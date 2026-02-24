import 'package:flutter_test/flutter_test.dart';
import 'package:time_widgets/models/weather_model.dart';

void main() {
  group('WeatherData', () {
    group('fromJson (legacy format)', () {
      test('parses valid legacy JSON', () {
        final json = {
          'city_name': 'Beijing',
          'description': 'Sunny',
          'temperature': 25,
          'temperature_range': '18℃~28℃',
          'aqilevel': 50,
          'humidity': 40,
          'wind': '3m/s',
          'pressure': 1013.25,
          'sunrise': '1709334000000',
          'sunset': '1709376000000',
          'weather_type': 0,
          'feels_like': 26,
          'visibility': '10km',
          'uv_index': '3',
          'pub_time': '2026-03-01 12:00',
        };

        final weather = WeatherData.fromJson(json);

        expect(weather.cityName, 'Beijing');
        expect(weather.description, 'Sunny');
        expect(weather.temperature, 25);
        expect(weather.temperatureRange, '18℃~28℃');
        expect(weather.aqiLevel, 50);
        expect(weather.humidity, 40);
        expect(weather.wind, '3m/s');
        expect(weather.pressure, 1013.25);
        expect(weather.feelsLike, 26);
        expect(weather.visibility, '10km');
        expect(weather.uvIndex, '3');
      });

      test('handles missing fields in legacy format', () {
        final json = <String, dynamic>{};

        final weather = WeatherData.fromJson(json);

        expect(weather.cityName, 'Unknown');
        expect(weather.description, 'Unknown');
        expect(weather.temperature, 0);
        expect(weather.humidity, 0);
        expect(weather.pressure, 0.0);
      });

      test('handles string values for numeric fields', () {
        final json = {
          'city_name': 'Shanghai',
          'description': 'Cloudy',
          'temperature': '22',
          'aqilevel': '80',
          'humidity': '65',
          'pressure': '1010.5',
          'feels_like': '21',
        };

        final weather = WeatherData.fromJson(json);

        expect(weather.temperature, 22);
        expect(weather.aqiLevel, 80);
        expect(weather.humidity, 65);
        expect(weather.pressure, 1010.5);
        expect(weather.feelsLike, 21);
      });

      test('handles int values for double fields', () {
        final json = {
          'city_name': 'Test',
          'description': 'Test',
          'pressure': 1013,
        };

        final weather = WeatherData.fromJson(json);

        expect(weather.pressure, 1013.0);
      });
    });

    group('fromXiaomiJson', () {
      test('parses Xiaomi weather API format', () {
        final json = {
          'current': {
            'temperature': {'value': '25'},
            'feelsLike': {'value': '27'},
            'humidity': {'value': '55'},
            'pressure': {'value': '1015.0'},
            'wind': {
              'speed': {'value': '12'},
            },
            'weather': '0',
            'visibility': {'value': '10'},
            'uvIndex': '3',
            'pubTime': '2026-03-01T12:00:00+08:00',
          },
          'aqi': {
            'aqi': '42',
          },
          'forecastDaily': {
            'sunRiseSet': {
              'value': [
                {
                  'from': '2026-03-01T06:30:00+08:00',
                  'to': '2026-03-01T18:15:00+08:00',
                },
              ],
            },
            'temperature': {
              'value': [
                {'from': '28', 'to': '15'},
              ],
            },
          },
        };

        final weather = WeatherData.fromXiaomiJson(json);

        expect(weather.temperature, 25);
        expect(weather.feelsLike, 27);
        expect(weather.humidity, 55);
        expect(weather.aqiLevel, 42);
        expect(weather.temperatureRange, '15℃~28℃');
      });

      test('handles empty Xiaomi JSON', () {
        final json = <String, dynamic>{};

        final weather = WeatherData.fromXiaomiJson(json);

        expect(weather.temperature, 0);
        expect(weather.humidity, 0);
        expect(weather.aqiLevel, 0);
      });
    });

    group('fromJson delegates to Xiaomi parser when current key exists', () {
      test('detects Xiaomi format', () {
        final json = {
          'current': {
            'temperature': {'value': '20'},
            'feelsLike': {'value': '19'},
            'humidity': {'value': '45'},
            'pressure': {'value': '1010'},
            'wind': {
              'speed': {'value': '8'},
            },
            'weather': '1',
            'pubTime': '',
          },
          'aqi': {},
          'forecastDaily': {},
        };

        final weather = WeatherData.fromJson(json);

        expect(weather.temperature, 20);
      });
    });

    group('construction', () {
      test('creates instance with all parameters', () {
        const weather = WeatherData(
          cityName: 'TestCity',
          description: 'Clear',
          temperature: 20,
          temperatureRange: '15℃~25℃',
          aqiLevel: 30,
          humidity: 50,
          wind: '5km/h',
          pressure: 1013.0,
          sunrise: '06:00',
          sunset: '18:00',
          weatherType: 0,
          weatherIcon: '☀',
          feelsLike: 21,
          visibility: '10km',
          uvIndex: '2',
          pubTime: '12:00',
        );

        expect(weather.cityName, 'TestCity');
        expect(weather.description, 'Clear');
        expect(weather.temperature, 20);
        expect(weather.temperatureRange, '15℃~25℃');
        expect(weather.aqiLevel, 30);
        expect(weather.humidity, 50);
        expect(weather.wind, '5km/h');
        expect(weather.pressure, 1013.0);
        expect(weather.sunrise, '06:00');
        expect(weather.sunset, '18:00');
        expect(weather.weatherType, 0);
        expect(weather.weatherIcon, '☀');
        expect(weather.feelsLike, 21);
        expect(weather.visibility, '10km');
        expect(weather.uvIndex, '2');
        expect(weather.pubTime, '12:00');
      });
    });
  });
}
