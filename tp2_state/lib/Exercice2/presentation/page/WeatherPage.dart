import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../Exercice1/Question1/presentation/widgets/ThemeSwitcher.dart';
import '../../business_logic/blocs/WeatherBloc.dart';
import '../../data/models/WeatherModel.dart';
import '../../data/repositories/WeatherRepository.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo'),
        backgroundColor: Colors.blue,
        actions: [
          ThemeSwitcher(),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => WeatherBloc(WeatherRepository()),
        child: WeatherView(),
      ),
    );
  }
}

class WeatherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Entrez une ville',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final city = context.read<WeatherBloc>().cityController.text;
                    context.read<WeatherBloc>().fetchWeather(city);
                  },
                ),
              ),
              controller: context.read<WeatherBloc>().cityController,
              onSubmitted: (city) => context.read<WeatherBloc>().fetchWeather(city),
            ),
            const SizedBox(height: 20),
            Consumer<WeatherBloc>(
              builder: (context, bloc, child) {
                if (bloc.isLoading) {
                  return const CircularProgressIndicator();
                }
                if (bloc.errorMessage != null) {
                  return Text(
                    bloc.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                if (bloc.weather == null) {
                  return const Text('Entrez une ville pour voir la météo');
                } else {
                  final dailyForecasts =
                      filterDailyForecasts(bloc.weather!.forecast);
                  return Column(
                    children: [
                      Text(
                        bloc.weather!.cityName,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        bloc.weather!.description,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      getWeatherIcon(bloc.weather!.icon),
                      const SizedBox(height: 10),
                      Text(
                        '${bloc.weather!.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.water_drop,
                              size: 16, color: Colors.blue),
                          // Icône pour humidité
                          const SizedBox(width: 5),
                          Text('${bloc.weather!.humidity}%',
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.air, size: 16, color: Colors.grey),
                          // Icône pour vent
                          const SizedBox(width: 5),
                          Text(
                              '${bloc.weather!.windSpeed.toStringAsFixed(1)} m/s',
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Prévisions météo',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dailyForecasts.length,
                            itemBuilder: (context, index) {
                              final day = dailyForecasts[index];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: 130, // Taille uniforme
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          formatDate(day.date),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        getWeatherIcon(day.icon, size: 40),
                                        // Taille de l'icône ajustée
                                        Text(
                                          '${day.temp.toStringAsFixed(1)}°C',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.water_drop,
                                                size: 16, color: Colors.blue),
                                            // Icône pour humidité
                                            const SizedBox(width: 5),
                                            Text(
                                                '${day.humidity.toStringAsFixed(0)}%',
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.air,
                                                size: 16, color: Colors.grey),
                                            // Icône pour vent
                                            const SizedBox(width: 5),
                                            Text(
                                                '${day.windSpeed.toStringAsFixed(1)} m/s',
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Forecast> filterDailyForecasts(List<Forecast> forecast) {
    final Map<String, Forecast> dailyForecasts = {};
    for (var item in forecast) {
      final date = item.date.split(' ')[0]; // Extraire la date sans l'heure
      if (!dailyForecasts.containsKey(date)) {
        dailyForecasts[date] = item; // Garder seulement la première occurrence
      }
    }
    return dailyForecasts.values.toList();
  }

  Widget getWeatherIcon(String iconCode, {double size = 50}) {
    // Remplacer tous les codes "xxn" par "xxd" pour afficher uniquement les icônes de jour
    final normalizedIconCode = iconCode.replaceAll('n', 'd');

    switch (normalizedIconCode) {
      case '01d': // Ciel clair
        return FaIcon(FontAwesomeIcons.sun, size: size, color: Colors.orange);
      case '02d': // Peu nuageux
        return FaIcon(FontAwesomeIcons.cloudSun,
            size: size, color: Colors.yellow);
      case '03d': // Nuages épars
        return FaIcon(FontAwesomeIcons.cloud, size: size, color: Colors.grey);
      case '04d': // Nuages fragmentés
        return FaIcon(FontAwesomeIcons.cloud, size: size, color: Colors.grey);
      case '09d': // Pluie fine
        return FaIcon(FontAwesomeIcons.cloudRain,
            size: size, color: Colors.blue);
      case '10d': // Pluie
        return FaIcon(FontAwesomeIcons.cloudShowersHeavy,
            size: size, color: Colors.blue);
      case '11d': // Orages
        return FaIcon(FontAwesomeIcons.bolt, size: size, color: Colors.yellow);
      case '13d': // Neige
        return FaIcon(FontAwesomeIcons.snowflake,
            size: size, color: Colors.lightBlue);
      case '50d': // Brouillard
        return FaIcon(FontAwesomeIcons.smog, size: size, color: Colors.grey);
      default: // Icône par défaut si le code ne correspond pas
        return FaIcon(FontAwesomeIcons.circleQuestion,
            size: size, color: Colors.grey);
    }
  }

  String formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('EEEE d', 'fr_FR').format(dateTime);
  }
}
