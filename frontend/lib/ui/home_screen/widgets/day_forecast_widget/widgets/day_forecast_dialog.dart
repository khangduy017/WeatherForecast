import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/functions/showToast.dart';
import 'package:frontend/models/forecast_weather.dart';
import 'package:frontend/services/reponse.dart';

import '../../../../../services/weather/weather.dart';

class DayForecastDialog extends StatefulWidget {
  const DayForecastDialog({Key? key, required this.location}) : super(key: key);
  final String location;

  @override
  State<DayForecastDialog> createState() => _DayForecastDialogState();
}

class _DayForecastDialogState extends State<DayForecastDialog> {
  bool loading = true;
  WeatherService weatherService = WeatherService();
  List<ForecastWeather> forecastWeather = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeatherData(widget.location);
  }

  void getWeatherData(String location) async {
    ResponseAPI result = await weatherService.getForecastWeather(location);
    if (result.statusCode == 200) {
      setState(() {
        loading = false;
        if (result.data['forecast'] != null) {
          forecastWeather = result.data['forecast']
              .map<ForecastWeather>((x) => ForecastWeather.fromMap(x))
              .toList();
        }
      });
    } else {
      ToastService.show(
          context: context,
          message: 'City not found! Please try again.',
          status: StatusToast.error);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      EasyLoading.show(status: 'Loading...');
    } else {
      EasyLoading.dismiss();
    }
    final screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: screenSize.width * 0.4,
        height: screenSize.height * 0.8,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Multiday forecast',
                    style: TextStyle(
                      height: 1,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: forecastWeather.length,
                      itemBuilder: (context, index) {
                        return ForecastItem(
                            forecastWeather: forecastWeather[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -5,
              top: -5,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: greyColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForecastItem extends StatelessWidget {
  const ForecastItem({Key? key, required this.forecastWeather})
      : super(key: key);
  final ForecastWeather forecastWeather;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xff6C757E),
      ),
      child: Row(
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
                height: 14,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Temp: ${forecastWeather.temperature ?? 0}°C',
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 12),
              Text(
                  'Wind: ${double.parse((((forecastWeather.wind ?? 0) / 60).toStringAsFixed(2)))} M/S',
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 12),
              Text('Humidity: ${forecastWeather.humidity ?? 0}%',
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
