// Dart imports:
// import 'dart:io';

// Package imports:
// import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/exceptions.dart';
// Project imports:

// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioSettings {
  // Portfolio excerpt: the original backend URL is intentionally omitted.
  // Configure a real endpoint locally when adapting this code.
  static const String baseUrl = 'https://api.example.invalid';

  final BaseOptions _dioBaseOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 30000,
    receiveTimeout: 30000,
    followRedirects: true,
    maxRedirects: 10,
    validateStatus: (status) {
      return status != null && status <= 500;
    },
  );

  static Dio createDio({int connectTimeout = 30000}) {
    Dio dio = Dio(
      DioSettings()._getDioBaseOptions(connectTimeout: connectTimeout),
    );

    if (kDebugMode) {
      // dio.interceptors.add(
      //   PrettyDioLogger(requestHeader: true, requestBody: true, maxWidth: 100),
      // );
    }

    return dio;
  }

  BaseOptions _getDioBaseOptions({int connectTimeout = 5000}) {
    var options = _dioBaseOptions;
    options.connectTimeout = connectTimeout;
    options.receiveTimeout = connectTimeout;
    return options;
  }
}

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = 'Запрос к серверу был отменён';
        break;
      case DioErrorType.connectTimeout:
        message = 'Превышено время ожидания подключения к серверу';
        break;
      case DioErrorType.other:
        message = 'Произошла ошибка при выполнении запроса';
        break;
      case DioErrorType.receiveTimeout:
        message = 'Превышено время ожидания ответа от сервера';
        break;
      case DioErrorType.response:
        message = _handleError(dioError.response!.statusCode!, dioError.response!.data);
        break;
      case DioErrorType.sendTimeout:
        message = 'Send timeout';
        break;

      default:
        message = 'Что-то пошло не так';
        break;
    }
  }

  String message = 'Что-то пошло не так';

  String _handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return error['message'] ?? 'Ошибка в параметрах запроса';
      case 401:
        return error['message'] ?? 'Необходимо авторизоваться';
      case 404:
        return error['message'];
      case 500:
        return error['message'] ?? 'Ошибка сервера';
      default:
        return error['message'] ?? 'Что-то пошло не так';
    }
  }

  @override
  String toString() => message;
}

class DioHandler {
  static bool checkResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        // Дополнительная проверка. Сервер иногда присылает страницу авторизации
        // в ответе, если сохраненный токен умер
        additionalResponseCheck(response);
        return true;
      case 401:
        throw AuthorizationException(GeneralErrors.unAuthorized);
      case 404:
        throw NotFoundException(GeneralErrors.emptyData);
      case 400:
        // Расширим проверку ответа от сервера
        additionalResponseCheck(response);
        throw DioError(
            requestOptions: response.requestOptions,
            response: response,
            type: DioErrorType.other,
            error: response.data);

      default:
        throw ConnectionException();
    }
  }

  static void additionalResponseCheck(Response response) {
    if (response.data != null && response.data is! String) {
      if (response.data is Map && response.data['non_fields_errors'] != null) {
        switch (response.data['non_fields_errors']) {
          case 'The remote server returned an error: (401) Unauthorized.':
            throw AuthorizationException(GeneralErrors.unAuthorized);
          default:
            throw DioError(
                requestOptions: response.requestOptions,
                response: response,
                type: DioErrorType.other,
                error: response.data);
        }
      }
    } else if (response.data is String) {
      throw AuthorizationException(GeneralErrors.unAuthorized);
    }
  }
}
