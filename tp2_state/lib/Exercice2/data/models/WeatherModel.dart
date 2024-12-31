class WeatherModel {
  final String cityName;
  final String description;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final String icon;
  final List<Forecast> forecast;

  WeatherModel({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.forecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
      forecast: (json['forecast'] as List)
          .map((item) => Forecast.fromJson(item))
          .toList(),
    );
  }
}

class Forecast {
  final String date;
  final double temp;
  final String icon;
  final double humidity; // Nouvelle propriété
  final double windSpeed; // Nouvelle propriété

  Forecast({
    required this.date,
    required this.temp,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: json['dt_txt'],
      temp: (json['main']['temp'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
      humidity: (json['main']['humidity'] as num).toDouble(), // Récupération
      windSpeed: (json['wind']['speed'] as num).toDouble(),  // Récupération
    );
  }
}
