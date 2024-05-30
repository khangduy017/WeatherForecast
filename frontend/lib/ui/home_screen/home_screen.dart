import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/options_data.dart';
import 'package:frontend/functions/determinePosition.dart';
import 'package:frontend/functions/showToast.dart';
import 'package:frontend/models/current_weather.dart';
import 'package:frontend/models/forecast_weather.dart';
import 'package:frontend/services/reponse.dart';
import 'package:frontend/services/weather/weather.dart';
import 'package:frontend/ui/home_screen/widgets/current_weather_widget/current_weather_widget.dart';
import 'package:frontend/ui/home_screen/widgets/day_forecast_widget/day_forecast_widget.dart';
import 'package:frontend/ui/home_screen/widgets/search_form_widget/search_form_widget.dart';
import 'package:frontend/utils/logger.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  WeatherService weatherService = WeatherService();
  CurrentWeather currentWeather = CurrentWeather();
  List<ForecastWeather> forecastWeather = [];
  String location = 'Ho Chi Minh';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentWeather();
  }

  void getCurrentWeather() async {
    location = await determinePosition();
    getWeatherData();
  }

  void getWeatherData() async {
    ResponseAPI result = await weatherService.getCurrentWeather(location);
    if (result.statusCode == 200) {
      setState(() {
        currentWeather = CurrentWeather.fromMap(result.data['current']);
        forecastWeather = result.data['forecast']
            .map<ForecastWeather>((x) => ForecastWeather.fromMap(x))
            .toList();

        logger.d(currentWeather.cityName);
        loading = false;
      });
    } else {
      if (result.data == 'notfound') {
        ToastService.show(
            context: context,
            message: 'City not found! Please try again.',
            status: StatusToast.error);
      } else {
        ToastService.show(
            context: context,
            message: 'Unstable network, please try again!',
            status: StatusToast.warning);
      }
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
    double widthScreen = MediaQuery.of(context).size.width;
    double menuMargin = 200;
    if (widthScreen <= 600) {
      menuMargin = 250;
    } else if (widthScreen <= 900) {
      menuMargin = 240;
    } else if (widthScreen <= 1100) {
      menuMargin = 220;
    }
    logger.d(widthScreen);

    return Scaffold(
      backgroundColor: backgroudColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        toolbarHeight: 100,
        title: Text(
          'Weather Dashboard',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              fontSize: widthScreen < 500 ? 26 : 36),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: widthScreen * 0.025),
            child: MenuAnchor(
              alignmentOffset: const Offset(0, 5),
              style: MenuStyle(
                fixedSize: MaterialStateProperty.all(
                    Size.fromWidth(menuMargin + widthScreen * (0.07))),
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const FaIcon(FontAwesomeIcons.bars),
                  iconSize: 28,
                  color: Colors.white,
                );
              },
              menuChildren: List<MenuItemButton>.generate(
                options.length,
                (int index) => MenuItemButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    context.push('/${options[index]['route']}');
                  },
                  child: Row(
                    children: [
                      FaIcon(options[index]['icon'], size: 18),
                      const SizedBox(width: 12),
                      Text(options[index]['text'],
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widthScreen * 0.025,
              vertical: widthScreen < 475 ? 20 : 50),
          child: widthScreen < 950
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchFormWidget(
                      onSearch: (value) {
                        location = value;
                        getWeatherData();
                        setState(() {
                          loading = true;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CurrentWeatherWidget(
                          currentWeather: currentWeather,
                        ),
                        const SizedBox(height: 30),
                        DayForecastWidget(
                          forecastWeather: forecastWeather,
                          location: location,
                        ),
                      ],
                    )
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SearchFormWidget(
                        onSearch: (value) {
                          location = value;
                          getWeatherData();
                          setState(() {
                            loading = true;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: widthScreen * 0.035),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CurrentWeatherWidget(
                            currentWeather: currentWeather,
                          ),
                          const SizedBox(height: 30),
                          DayForecastWidget(
                            forecastWeather: forecastWeather,
                            location: location,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
