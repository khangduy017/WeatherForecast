// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ForecastWeather {
  String? date;
  String? conditionText;
  String? conditionIcon;
  double? temperature;
  double? wind;
  double? humidity;

  ForecastWeather({
    this.date,
    this.conditionText,
    this.conditionIcon,
    this.temperature,
    this.wind,
    this.humidity,
  });

  ForecastWeather copyWith({
    String? date,
    String? conditionText,
    String? conditionIcon,
    double? temperature,
    double? wind,
    double? humidity,
  }) {
    return ForecastWeather(
      date: date ?? this.date,
      conditionText: conditionText ?? this.conditionText,
      conditionIcon: conditionIcon ?? this.conditionIcon,
      temperature: temperature ?? this.temperature,
      wind: wind ?? this.wind,
      humidity: humidity ?? this.humidity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'conditionText': conditionText,
      'conditionIcon': conditionIcon,
      'temperature': temperature,
      'wind': wind,
      'humidity': humidity,
    };
  }

  factory ForecastWeather.fromMap(Map<String, dynamic> map) {
    return ForecastWeather(
      date: map['date'] ?? '',
      conditionText: map['conditionText'] ?? '',
      conditionIcon: map['conditionIcon'] ?? '',
      temperature: map['temperature'] ?? 0,
      wind: map['wind'] ?? 0,
      humidity: map['humidity'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ForecastWeather.fromJson(String source) =>
      ForecastWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ForecastWeather(date: $date, conditionText: $conditionText, conditionIcon: $conditionIcon, temperature: $temperature, wind: $wind, humidity: $humidity)';
  }

  @override
  bool operator ==(covariant ForecastWeather other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.conditionText == conditionText &&
        other.conditionIcon == conditionIcon &&
        other.temperature == temperature &&
        other.wind == wind &&
        other.humidity == humidity;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        conditionText.hashCode ^
        conditionIcon.hashCode ^
        temperature.hashCode ^
        wind.hashCode ^
        humidity.hashCode;
  }
}
