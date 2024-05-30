import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/models/current_weather.dart';

class HistoryWeatherWidget extends StatelessWidget {
  const HistoryWeatherWidget({Key? key, required this.currentWeather})
      : super(key: key);
  final CurrentWeather currentWeather;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${currentWeather.cityName ?? ''} (${currentWeather.time ?? ''})',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 14,
                ),
                Text('Temperature: ${currentWeather.temperature ?? 0}°C',
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(
                  height: 8,
                ),
                Text(
                    'Wind: ${double.parse((((currentWeather.wind ?? 0) / 60).toStringAsFixed(2)))} M/S',
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(
                  height: 8,
                ),
                Text('Humidity: ${currentWeather.humidity ?? 0}%',
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Image.network(
                  'https:${currentWeather.conditionIcon ?? ''}',
                  scale: 0.7,
                  errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
                Text(currentWeather.conditionText ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
