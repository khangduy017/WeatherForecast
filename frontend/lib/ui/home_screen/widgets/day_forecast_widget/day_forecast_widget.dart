import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/models/forecast_weather.dart';
import 'package:frontend/ui/home_screen/widgets/day_forecast_widget/widgets/day_forecast_dialog.dart';
import 'package:frontend/ui/home_screen/widgets/day_forecast_widget/widgets/day_forecast_item.dart';
import 'package:frontend/utils/logger.dart';

class DayForecastWidget extends StatelessWidget {
  const DayForecastWidget(
      {super.key, required this.forecastWeather, required this.location});
  final List<ForecastWeather> forecastWeather;
  final String location;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    logger.d(widthScreen);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('4-Day Forecast',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => DayForecastDialog(
                            location: location,
                          ));
                },
                child: const Text('More',
                    style: TextStyle(fontSize: 18, color: Colors.black))),
          ],
        ),
        const SizedBox(height: 30),
        if (forecastWeather.isNotEmpty && widthScreen > 1000)
          Row(
            children: [
              DayForecastItem(
                forecastWeather: forecastWeather[0],
              ),
              SizedBox(width: widthScreen * 0.015),
              DayForecastItem(forecastWeather: forecastWeather[1]),
              SizedBox(width: widthScreen * 0.015),
              DayForecastItem(forecastWeather: forecastWeather[2]),
              SizedBox(width: widthScreen * 0.015),
              DayForecastItem(forecastWeather: forecastWeather[3]),
            ],
          ),
        if (forecastWeather.isNotEmpty && widthScreen <= 1000)
          Column(
            children: [
              Row(
                children: [
                  DayForecastItem(forecastWeather: forecastWeather[0]),
                  SizedBox(width: widthScreen * 0.015),
                  DayForecastItem(forecastWeather: forecastWeather[1]),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  DayForecastItem(forecastWeather: forecastWeather[2]),
                  SizedBox(width: widthScreen * 0.015),
                  DayForecastItem(forecastWeather: forecastWeather[3]),
                ],
              )
            ],
          ),
      ],
    );
  }
}
