// Project imports:
import 'package:gisogs_greenspacesapp/presentation/state/view_models/user/auth_view_model.dart';

class CheckAuthCredentials {}

class UpdateAuthCredentials {
  final String login;
  final String password;

  UpdateAuthCredentials({required this.login, required this.password});
}

class AuthSuccess {
  AuthSuccess();
}

class AuthErrorAction {
  final String login;
  final String password;
  final String errorMessage;
  final AuthErrorCode errorCode;

  AuthErrorAction({
    required this.login,
    required this.password,
    required this.errorMessage,
    required this.errorCode,
  });
}

class ToggleRememberMe {
  final bool value;
  ToggleRememberMe({required this.value});
}
