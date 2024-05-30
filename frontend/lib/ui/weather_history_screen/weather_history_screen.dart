import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/models/current_weather.dart';
import 'package:frontend/ui/weather_history_screen/widgets/current_weather_widget.dart';
import 'package:frontend/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherHistoryScreen extends StatefulWidget {
  const WeatherHistoryScreen({Key? key}) : super(key: key);

  @override
  State<WeatherHistoryScreen> createState() => _WeatherHistoryScreenState();
}

class _WeatherHistoryScreenState extends State<WeatherHistoryScreen> {
  List<CurrentWeather> weatherDataListRead = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadWeatherData();
  }

  Future<void> loadWeatherData() async {
    logger.d('Load weather data');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedData = prefs.getStringList('weatherData');

    if (encodedData != null) {
      logger.d('vao day');
      for (String data in encodedData) {
        weatherDataListRead.add(CurrentWeather.fromJson(data));
      }
    }
    weatherDataListRead = filterByCurrentDate(weatherDataListRead);
    setState(() {});
  }

  List<CurrentWeather> filterByCurrentDate(List<CurrentWeather> weatherData) {
    final today = DateTime.now();

    return weatherData.where((weather) {
      try {
        DateTime.parse(weather.time!);
        String datePart1 = weather.time!.split(' ')[0];
        String datePart2 = today.toString().split(' ')[0];

        logger.d('datePart1: $datePart1');
        logger.d('datePart2: $datePart2');

        return datePart1 == datePart2;
      } catch (e) {
        return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double itemSize = widthScreen * 0.45;

    if (widthScreen <= 1200) {
      itemSize = widthScreen * 0.8;
    }

    return Scaffold(
      backgroundColor: backgroudColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: primaryColor,
        centerTitle: false,
        leadingWidth: widthScreen * 0.06,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Forecast History',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              const Text(
                'Today\'s stored weather list',
                style: TextStyle(
                  height: 1,
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: weatherDataListRead.isNotEmpty
                    ? Wrap(
                        spacing:
                            12, // Khoảng cách giữa các item trên cùng một hàng
                        runSpacing: 8, // Khoảng cách giữa các hàng
                        children: [
                          ...List.generate(
                            weatherDataListRead.length,
                            (index) => Container(
                              constraints: BoxConstraints(
                                maxWidth: itemSize,
                              ),
                              child: HistoryWeatherWidget(
                                  currentWeather: weatherDataListRead[index]),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Text(
                          'No data available!',
                          style: TextStyle(
                              fontSize: 21,
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 160, 160, 160)),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
