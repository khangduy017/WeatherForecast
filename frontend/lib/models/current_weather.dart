// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class CurrentWeather {
  String? cityName;
  String? time;
  String? conditionText;
  String? conditionIcon;
  double? temperature;
  double? wind;
  double? humidity;
  CurrentWeather({
    this.cityName,
    this.time,
    this.conditionText,
    this.conditionIcon,
    this.temperature,
    this.wind,
    this.humidity,
  });

  CurrentWeather copyWith({
    String? cityName,
    String? time,
    String? conditionText,
    String? conditionIcon,
    double? temperature,
    double? wind,
    double? humidity,
  }) {
    return CurrentWeather(
      cityName: cityName ?? this.cityName,
      time: time ?? this.time,
      conditionText: conditionText ?? this.conditionText,
      conditionIcon: conditionIcon ?? this.conditionIcon,
      temperature: temperature ?? this.temperature,
      wind: wind ?? this.wind,
      humidity: humidity ?? this.humidity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cityName': cityName,
      'time': time,
      'conditionText': conditionText,
      'conditionIcon': conditionIcon,
      'temperature': temperature,
      'wind': wind,
      'humidity': humidity,
    };
  }

  factory CurrentWeather.fromMap(Map<String, dynamic> map) {
    return CurrentWeather(
      cityName: map['cityName'] ?? '',
      time: map['time'] ?? '',
      conditionText: map['conditionText'] ?? '',
      conditionIcon: map['conditionIcon'] ?? '',
      temperature: map['temperature'] ?? 0,
      wind: map['wind'] ?? 0,
      humidity: map['humidity'] ?? 0,
    );
  }

  // String toJson() => json.encode(toMap());

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'time': time,
      'conditionText': conditionText,
      'conditionIcon': conditionIcon,
      'temperature': temperature,
      'wind': wind,
      'humidity': humidity,
    };
  }

  factory CurrentWeather.fromJson(String source) =>
      CurrentWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  //     factory WeatherData.fromJson(Map<String, dynamic> json) {
  //   return WeatherData(
  //     date: json['date'],
  //     temperature: json['temperature'],
  //     wind: json['wind'],
  //     humidity: json['humidity'],
  //     conditionText: json['conditionText'],
  //     conditionIcon: json['conditionIcon'],
  //   );
  // }

  @override
  String toString() {
    return 'CurrentWeather(cityName: $cityName, time: $time, conditionText: $conditionText, conditionIcon: $conditionIcon, temperature: $temperature, wind: $wind, humidity: $humidity)';
  }

  @override
  bool operator ==(covariant CurrentWeather other) {
    if (identical(this, other)) return true;

    return other.cityName == cityName &&
        other.time == time &&
        other.conditionText == conditionText &&
        other.conditionIcon == conditionIcon &&
        other.temperature == temperature &&
        other.wind == wind &&
        other.humidity == humidity;
  }

  @override
  int get hashCode {
    return cityName.hashCode ^
        time.hashCode ^
        conditionText.hashCode ^
        conditionIcon.hashCode ^
        temperature.hashCode ^
        wind.hashCode ^
        humidity.hashCode;
  }
}
