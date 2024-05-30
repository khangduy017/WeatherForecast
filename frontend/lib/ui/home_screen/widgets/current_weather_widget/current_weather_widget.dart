import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/functions/showToast.dart';
import 'package:frontend/models/current_weather.dart';
import 'package:frontend/utils/logger.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentWeatherWidget extends StatefulWidget {
  const CurrentWeatherWidget({Key? key, required this.currentWeather})
      : super(key: key);
  final CurrentWeather currentWeather;

  @override
  State<CurrentWeatherWidget> createState() => _CurrentWeatherWidgetState();
}

class _CurrentWeatherWidgetState extends State<CurrentWeatherWidget> {

  Future<void> saveWeatherData(CurrentWeather currentWeather) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool containsKey = prefs.containsKey('weatherData');

    if (containsKey) {
      List<String>? existingData = prefs.getStringList('weatherData');
      List<String> updatedData = existingData ?? [];

      updatedData.add(jsonEncode(currentWeather.toJson()));

      await prefs.setStringList('weatherData', updatedData);
    } else {
      List<String> newData = [jsonEncode(currentWeather.toJson())];
      await prefs.setStringList('weatherData', newData);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double paddingRight = 70;
    if (widthScreen <= 900) {
      paddingRight = widthScreen * 0.04;
    }
    logger.d('Rebuild');

    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Stack(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(30, 20, paddingRight, 26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.currentWeather.cityName ?? ''} (${widget.currentWeather.time ?? ''})',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                        'Temperature: ${widget.currentWeather.temperature ?? 0}°C',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22)),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                        'Wind: ${double.parse((((widget.currentWeather.wind ?? 0) / 60).toStringAsFixed(2)))} M/S',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22)),
                    const SizedBox(
                      height: 12,
                    ),
                    Text('Humidity: ${widget.currentWeather.humidity ?? 0}%',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22)),
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 1,
                // width: widthScreen * 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      'https:${widget.currentWeather.conditionIcon ?? ''}',
                      scale: 0.7,
                      errorBuilder: (context, error, stackTrace) {
                        return Container();
                      },
                    ),
                    Text(widget.currentWeather.conditionText ?? '',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 21)),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: 15,
          top: 15,
          child: InkWell(
            onTap: () {
              saveWeatherData(widget.currentWeather);
              ToastService.show(
                  context: context,
                  message: 'Save weather informatin successfully!',
                  status: StatusToast.success);
            },
            child: const FaIcon(
              FontAwesomeIcons.solidBookmark,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}
