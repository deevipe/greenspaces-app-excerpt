// Flutter imports:
import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/domain/utils/shared_preferences.dart';

@immutable
class AuthViewModel {
  final String login;
  final String password;
  final bool isProcessing;
  final bool? authSuccess;
  final bool rememberMe;
  final String? errorMessage;
  final AuthErrorCode? errorCode;

  const AuthViewModel({
    required this.login,
    required this.password,
    required this.isProcessing,
    required this.rememberMe,
    this.authSuccess,
    this.errorMessage,
    this.errorCode,
  });

  factory AuthViewModel.initial() {
    return AuthViewModel(
      login: '',
      password: '',
      isProcessing: false,
      rememberMe: SharedStorageService.getBool(PreferenceKey.remeberMe) ?? true,
    );
  }

  AuthViewModel copyWith({
    required String login,
    required String password,
    required bool isProcessing,
    bool? rememberMe,
    bool? authSuccess,
    String? errorMessage,
    AuthErrorCode? errorCode,
  }) {
    return AuthViewModel(
      login: login,
      password: password,
      isProcessing: isProcessing,
      authSuccess: authSuccess ?? this.authSuccess,
      errorMessage: errorMessage,
      errorCode: errorCode,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewModel &&
          runtimeType == other.runtimeType &&
          login == other.login &&
          password == other.password &&
          isProcessing == other.isProcessing &&
          rememberMe == other.rememberMe &&
          authSuccess == other.authSuccess &&
          errorCode == other.errorCode &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      login.hashCode ^ password.hashCode ^ isProcessing.hashCode ^ authSuccess.hashCode ^ errorCode.hashCode ^ errorMessage.hashCode ^ rememberMe.hashCode;
}

enum AuthErrorCode { wrongLogin, wrongCredentials, notFound, other }
