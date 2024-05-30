import 'package:flutter/material.dart';
import 'package:frontend/models/forecast_weather.dart';

class DayForecastItem extends StatelessWidget {
  const DayForecastItem({Key? key, required this.forecastWeather})
      : super(key: key);
  final ForecastWeather forecastWeather;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: const Color(0xff6C757E),
            borderRadius: BorderRadius.circular(5)),
        child: widthScreen >= 1400 || widthScreen < 1150
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('(${forecastWeather.date ?? ''})',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 4,
                      ),
                      Image.network(
                        'https:${forecastWeather.conditionIcon ?? ''}',
                        scale: 0.9,
                        errorBuilder: (context, error, stackTrace) {
                          return Container();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text('Temp: ${forecastWeather.temperature ?? 0}°C',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                      const SizedBox(height: 12),
                      Text(
                          'Wind: ${double.parse((((forecastWeather.wind ?? 0) / 60).toStringAsFixed(2)))} M/S',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                      const SizedBox(height: 12),
                      Text('Humidity: ${forecastWeather.humidity ?? 0}%',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('(${forecastWeather.date ?? ''})',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 4,
                      ),
                      Image.network(
                        'https:${forecastWeather.conditionIcon ?? ''}',
                        scale: 0.9,
                        errorBuilder: (context, error, stackTrace) {
                          return Container();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text('Temp: ${forecastWeather.temperature ?? 0}°C',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                      const SizedBox(height: 12),
                      Text(
                          'Wind: ${double.parse((((forecastWeather.wind ?? 0) / 60).toStringAsFixed(2)))} M/S',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                      const SizedBox(height: 12),
                      Text('Humidity: ${forecastWeather.humidity ?? 0}%',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
