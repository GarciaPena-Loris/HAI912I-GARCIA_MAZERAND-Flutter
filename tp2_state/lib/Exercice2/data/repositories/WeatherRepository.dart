import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/WeatherModel.dart';

class WeatherRepository {
  final String apiKey = '529ce0ae81dfac626dc8031d4486a694';

  Future<WeatherModel> fetchWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=fr';
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric&lang=fr';

    final response = await http.get(Uri.parse(url));
    final forecastResponse = await http.get(Uri.parse(forecastUrl));

    if (response.statusCode == 200 && forecastResponse.statusCode == 200) {
      final data = jsonDecode(response.body);
      final forecastData = jsonDecode(forecastResponse.body);
      data['forecast'] = forecastData['list']
          .where((item) => DateTime.parse(item['dt_txt']).isAfter(DateTime.now()))
          .toList();
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}