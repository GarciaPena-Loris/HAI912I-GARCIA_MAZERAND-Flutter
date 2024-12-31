import 'package:flutter/material.dart';

import '../../data/models/WeatherModel.dart';
import '../../data/repositories/WeatherRepository.dart';

class WeatherBloc extends ChangeNotifier {
  final WeatherRepository weatherRepository;
  final TextEditingController cityController = TextEditingController();

  WeatherModel? weather;
  bool isLoading = false;
  String? errorMessage;

  WeatherBloc(this.weatherRepository);

  Future<void> fetchWeather(String city) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      weather = await weatherRepository.fetchWeather(city);
    } catch (e) {
      errorMessage = 'Erreur : Impossible de charger la météo.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
