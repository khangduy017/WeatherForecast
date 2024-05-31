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
  bool isSaved = false;
  CurrentWeather preCurrentWeather = CurrentWeather();

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
    if (widthScreen <= 1050) {
      paddingRight = widthScreen * 0.03;
    }
    logger.d('Rebuild');
    if (preCurrentWeather != widget.currentWeather) {
      isSaved = false;
      preCurrentWeather = widget.currentWeather;
    }

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
                flex: widthScreen > 500 ? 5 : 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.currentWeather.cityName ?? ''} (${widget.currentWeather.time ?? ''})',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: widthScreen < 600
                              ? widthScreen > 500
                                  ? 24
                                  : 20
                              : 28,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: widthScreen > 500 ? 16 : 10,
                    ),
                    Text(
                        'Temperature: ${widget.currentWeather.temperature ?? 0}°C',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widthScreen > 500 ? 22 : 16)),
                    SizedBox(
                      height: widthScreen > 500 ? 12 : 5,
                    ),
                    Text(
                        'Wind: ${double.parse((((widget.currentWeather.wind ?? 0) / 60).toStringAsFixed(2)))} M/S',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widthScreen > 500 ? 22 : 16)),
                    SizedBox(
                      height: widthScreen > 500 ? 12 : 5,
                    ),
                    Text('Humidity: ${widget.currentWeather.humidity ?? 0}%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widthScreen > 500 ? 22 : 16)),
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                flex: widthScreen <= 1000 ? 3 : 2,
                // width: widthScreen * 0.1,
                child: Column(
                  crossAxisAlignment: widthScreen > 500
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https:${widget.currentWeather.conditionIcon ?? ''}',
                      scale: widthScreen > 500 ? 0.7 : 1,
                      errorBuilder: (context, error, stackTrace) {
                        return Container();
                      },
                    ),
                    Text(widget.currentWeather.conditionText ?? '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widthScreen > 500 ? 21 : 16)),
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
              setState(() {
                isSaved = true;
              });
            },
            child: FaIcon(
              isSaved
                  ? FontAwesomeIcons.solidBookmark
                  : FontAwesomeIcons.bookmark,
              color: Colors.white,
              size: widthScreen > 500 ? 36 : 24,
            ),
          ),
        ),
      ]),
    );
  }
}
