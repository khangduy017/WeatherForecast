// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:frontend/models/current_weather.dart';
import 'package:frontend/models/forecast_weather.dart';

class Weather {
  CurrentWeather? currentWeather;
  List<ForecastWeather>? forecastWeather;
  Weather({
    this.currentWeather,
    this.forecastWeather,
  });

  Weather copyWith({
    CurrentWeather? currentWeather,
    List<ForecastWeather>? forecastWeather,
  }) {
    return Weather(
      currentWeather: currentWeather ?? this.currentWeather,
      forecastWeather: forecastWeather ?? this.forecastWeather,
    );
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      currentWeather: map['current'] != null
          ? CurrentWeather.fromMap(map['forecast'] as Map<String, dynamic>)
          : null,
      forecastWeather: map['forecast'] != null
          ? List<ForecastWeather>.from(
              (map['forecast'] as List<int>).map<ForecastWeather?>(
                (x) => ForecastWeather.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Weather(currentWeather: $currentWeather, forecastWeather: $forecastWeather)';

  @override
  bool operator ==(covariant Weather other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.currentWeather == currentWeather &&
        listEquals(other.forecastWeather, forecastWeather);
  }

  @override
  int get hashCode => currentWeather.hashCode ^ forecastWeather.hashCode;
}
