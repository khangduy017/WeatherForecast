// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_null_aware_operators, prefer_if_null_operators

import 'dart:convert';

import 'package:flutter/foundation.dart';

// Generic Dart
class ResponseAPI<T> {
  T? data;
  int? statusCode;
  ResponseAPI({
    this.data,
    this.statusCode,
  });

  @override
  String toString() => 'ResponseAPI(data: $data, statusCode: $statusCode)';
}

class DataResponse {
  String? success;
  String? requestId;
  dynamic
      errorDetails; // Because API return errorDetails return String or Array
  String? stack;
  ResultMap? resultMap;

  DataResponse({
    this.success,
    this.requestId,
    this.errorDetails,
    this.stack,
    this.resultMap,
  });

  DataResponse copyWith({
    String? success,
    String? requestId,
    dynamic errorDetails,
    String? stack,
    ResultMap? resultMap,
  }) {
    return DataResponse(
      success: success ?? this.success,
      requestId: requestId ?? this.requestId,
      errorDetails: errorDetails ?? this.errorDetails,
      stack: stack ?? this.stack,
      resultMap: resultMap ?? this.resultMap,
    );
  }

  Map<String, dynamic> toMap() {
    final resultData = <String, dynamic>{};

    if (success != null) {
      resultData.addAll({'success': success});
    }
    if (requestId != null) {
      resultData.addAll({'requestId': requestId});
    }
    if (errorDetails != null) {
      resultData.addAll({'errorDetails': errorDetails});
    }
    if (stack != null) {
      resultData.addAll({'stack': stack});
    }
    if (resultMap != null) {
      resultData.addAll({'resultMap': resultMap});
    }

    return resultData;
  }

  factory DataResponse.fromMap(Map<String, dynamic> map) {
    return DataResponse(
      success: map['success'],
      requestId: map['requestId'],
      errorDetails: map['errorDetails'],
      stack: map['stack'],
      resultMap: map['result'] != null
          ? ResultMap.fromMap(map['result'])
          : null, //[Core] Do not edit here
      // Add more when custom
    );
  }

  String toJson() => json.encode(toMap());

  factory DataResponse.fromJson(String source) {
    return DataResponse.fromMap(json.decode(source));
  }

  @override
  String toString() {
    return 'DataResponse(error: $errorDetails, requestId: $requestId, stack: $stack, resultMap: $resultMap)';
  }
}


class ResultMap {
  int? id;
  List<int>? roles;

  String? token;
  String? fullname;

  ResultMap(
      {this.id,
      this.roles,
      this.fullname,
      this.token});

  ResultMap copyWith({
    int? id,
    List<int>? roles,
    String? token,
    String? fullname,
  }) {
    return ResultMap(
      id: id ?? this.id,
      roles: roles ?? this.roles,
      token: token ?? this.token,
      fullname: fullname ?? this.fullname,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (roles != null) {
      result.addAll({'roles': roles});
    }
    if (token != null) {
      result.addAll({'token': token});
    }
    if (fullname != null) {
      result.addAll({'fullname': fullname});
    }

    return result;
  }

  factory ResultMap.fromMap(Map<String, dynamic> map) {
    return ResultMap(
      id: map['id'] != null ? map['id'].toInt() : null,
      roles: map['roles'] != null ? List<int>.from(map['roles']) : null,
      token: map['token'] != null ? map['token'] : null,
      fullname: map['fullname'] != null ? map['fullname'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultMap.fromJson(String source) =>
      ResultMap.fromMap(json.decode(source));


}
