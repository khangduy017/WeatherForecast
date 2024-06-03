import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend/functions/showToast.dart';
import 'package:frontend/models/weather.dart';
import 'package:frontend/services/dio_client.dart';
import 'package:frontend/services/endpoint.dart';
import 'package:frontend/services/reponse.dart';
import 'package:frontend/utils/logger.dart';

class WeatherService {
  var dio = Dio();

  Future<ResponseAPI<dynamic>> getCurrentWeather(String location) async {
    logger.d(location);
    try {
      final res = await dio.post(
        '$baseURL/weather/get-current-weather',
        data: {'location': location},
      );

      logger.d(res.data['data']);
      logger.i('successfully!');
      return ResponseAPI<dynamic>(
        statusCode: res.statusCode,
        data: res.data['data'],
      );
    } on DioException catch (e) {
      logger.e(
        "DioException :${e.response}",
      );

      if (e.response!.data['status'] == 'notfound') {
        return ResponseAPI<dynamic>(
          statusCode: 400,
          data: 'notfound',
        );
      } else {
        return ResponseAPI<dynamic>(
          statusCode: 400,
          data: 'internet',
        );
      }

      // return ResponseAPI<dynamic>(
      //   statusCode: 500,
      //   data: [],
      // );
    } catch (e) {
      logger.e("Unexpected Error: $e");
      rethrow;
    }
  }

  Future<ResponseAPI<dynamic>> getForecastWeather(String location) async {
    try {
      final res = await dio.post(
        '$baseURL/weather/get-forecast-weather',
        data: {'location': location},
      );

      logger.d(res.data['data']);
      logger.i('successfully!');

      return ResponseAPI<dynamic>(
        statusCode: res.statusCode,
        data: res.data['data'],
      );
    } on DioException catch (e) {
      logger.e(
        "DioException :${e.response}",
      );

      return ResponseAPI<dynamic>(
        statusCode: 400,
        data: [],
      );
    } catch (e) {
      logger.e("Unexpected Error: $e");
      rethrow;
    }
  }
}
