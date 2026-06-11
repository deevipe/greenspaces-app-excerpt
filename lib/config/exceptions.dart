import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';

class ConnectionException implements Exception {}

class ParseException implements Exception {
  final String? message;
  ParseException([this.message]);

  @override
  String toString() {
    String? message = this.message;
    if (message == null) return GeneralErrors.parseError;
    return message;
  }
}

class NotFoundException implements Exception {
  final String? message;
  NotFoundException([this.message]);

  @override
  String toString() {
    String? message = this.message;
    if (message == null) return GeneralErrors.userNotFound;
    return message;
  }
}

class AuthorizationException implements Exception {
  final String? message;

  AuthorizationException([this.message]);

  @override
  String toString() {
    String? message = this.message;
    if (message == null) return GeneralErrors.generalError;
    return message;
  }
}

class CustomException implements Exception {
  final String? message;

  CustomException([this.message]);

  @override
  String toString() {
    String? message = this.message;
    if (message == null) return GeneralErrors.generalError;
    return message;
  }
}
