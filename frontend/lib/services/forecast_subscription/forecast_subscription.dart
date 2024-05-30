import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend/functions/showToast.dart';
import 'package:frontend/models/weather.dart';
import 'package:frontend/services/dio_client.dart';
import 'package:frontend/services/endpoint.dart';
import 'package:frontend/services/reponse.dart';
import 'package:frontend/utils/logger.dart';

class ForecastSubscriptionService {
  var dio = Dio();

  Future<ResponseAPI<dynamic>> subsribeForecastWeather(String email) async {
    try {
      final res = await dio.post(
        '$baseURL/subscribe-forecast/subscribe-forecast',
        data: {'email': email},
      );

      logger.d(res.data['data']);
      logger.i('subscribe EMAIL');
      return ResponseAPI<dynamic>(
        statusCode: res.statusCode,
        data: res.data['data'],
      );
    } on DioException catch (e) {
      logger.e(
        "DioException :${e.response!.data['message']}",
      );

      return ResponseAPI<dynamic>(
        statusCode: 400,
        data: e.response!.data['message'],
      );
    } catch (e) {
      logger.e("Unexpected Error: $e");
      rethrow;
    }
  }

  Future<ResponseAPI<dynamic>> verifyCode(
      String email, String code, String location) async {
    try {
      final res = await dio.post(
        '$baseURL/subscribe-forecast/verify-code',
        data: {'email': email, 'code': code, 'location': location},
      );

      logger.d(res.data['data']);
      logger.i('verify EMAIL');
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

    Future<ResponseAPI<dynamic>> unsubsribeForecastWeather(String email) async {
    try {
      final res = await dio.post(
        '$baseURL/subscribe-forecast/unsubscribe-forecast',
        data: {'email': email},
      );

      logger.d(res.data['data']);
      logger.i('UNsubscribe EMAIL');
      return ResponseAPI<dynamic>(
        statusCode: res.statusCode,
        data: {},
      );
    } on DioException catch (e) {
      logger.e(
        "DioException :${e.response!.data['message']}",
      );

      return ResponseAPI<dynamic>(
        statusCode: 400,
        data: e.response!.data['message'],
      );
    } catch (e) {
      logger.e("Unexpected Error: $e");
      rethrow;
    }
  }
}
