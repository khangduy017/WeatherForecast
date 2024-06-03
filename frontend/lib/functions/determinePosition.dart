import 'dart:html';
import 'package:frontend/utils/logger.dart';
import 'package:geolocator/geolocator.dart';

Future<String> determinePosition() async {
  try {
    //check PERMISSION
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Geolocator.requestPermission();
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        logger.d('Location permission denied');
        return 'Ho Chi Minh';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      logger.d('Location permissions are permanently denied');
      return 'Ho Chi Minh';
    }

    Position position = await Geolocator.getCurrentPosition();

    return '${position.latitude},${position.longitude}';
  } catch (e) {
    return 'Ho Chi Minh';
    // return Future.error('Location permission denied');
  }
  return 'Ho Chi Minh';
}
