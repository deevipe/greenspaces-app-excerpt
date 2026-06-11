// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/presentation/state/actions/auth_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/user/auth_view_model.dart';

final authReducer = combineReducers<AuthViewModel>([
  TypedReducer<AuthViewModel, UpdateAuthCredentials>(_update),
  TypedReducer<AuthViewModel, CheckAuthCredentials>(_process),
  TypedReducer<AuthViewModel, AuthSuccess>(_success),
  TypedReducer<AuthViewModel, AuthErrorAction>(_errorHandler),
  TypedReducer<AuthViewModel, ToggleRememberMe>(_toggleRememberMe),
]);

AuthViewModel _update(AuthViewModel state, UpdateAuthCredentials action) {
  return state.copyWith(
    login: action.login,
    password: action.password,
    isProcessing: false,
    authSuccess: false,
    errorCode: null,
    errorMessage: null,
  );
}

AuthViewModel _process(AuthViewModel state, CheckAuthCredentials action) {
  return state.copyWith(
    login: state.login,
    password: state.password,
    isProcessing: true,
    authSuccess: false,
    errorCode: null,
    errorMessage: null,
  );
}

AuthViewModel _success(AuthViewModel state, AuthSuccess action) {
  return state.copyWith(
    login: state.login,
    password: state.password,
    authSuccess: true,
    isProcessing: false,
    errorCode: null,
    errorMessage: null,
  );
}

AuthViewModel _errorHandler(AuthViewModel state, AuthErrorAction action) {
  return state.copyWith(
      login: action.login, password: action.password, isProcessing: false, authSuccess: false, errorCode: action.errorCode, errorMessage: action.errorMessage);
}

AuthViewModel _toggleRememberMe(AuthViewModel state, ToggleRememberMe action) {
  return state.copyWith(
    login: state.login,
    password: state.password,
    isProcessing: false,
    rememberMe: action.value,
    errorCode: null,
    errorMessage: '',
  );
}
