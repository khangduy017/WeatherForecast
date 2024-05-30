import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend/constants/colors.dart';
import 'package:lottie/lottie.dart';

void configEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.custom
    ..radius = 15.0
    ..contentPadding = const EdgeInsets.symmetric(horizontal: 0, vertical: 15)
    ..backgroundColor = primaryColor
    ..indicatorColor = Colors.transparent
    ..textColor = Colors.white
    ..textStyle = const TextStyle(fontSize: 21, color: Colors.white)
    ..animationDuration = const Duration(microseconds: 2000)
    ..maskColor = Colors.black.withOpacity(0.4)
    ..userInteractions = true
    ..indicatorWidget = Lottie.asset('lib/assets/json/loading.json', height: 80)
    ..boxShadow = [];
}
