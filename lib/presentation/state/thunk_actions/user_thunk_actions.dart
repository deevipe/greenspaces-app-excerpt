import 'package:dio/dio.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/dio_settings.dart';
import 'package:gisogs_greenspacesapp/config/exceptions.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';
import 'package:gisogs_greenspacesapp/data/api/service/hive_service.dart';
import 'package:gisogs_greenspacesapp/domain/utils/shared_preferences.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/use_case_module.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/auth_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/user_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/user/auth_view_model.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void doLogin(Store<AppState> store) async {
  store.dispatch(CheckAuthCredentials());
  final AuthViewModel state = store.state.authScreenState;

  try {
    final User? user = await UseCaseModule.user().logIn(login: state.login, password: state.password);
    if (user != null) {
      // Отправим событие для обновления состояния верхнего меню.
      store.dispatch(GetUserSuccessAction(user: user));
      store.dispatch(AuthSuccess());
    } else {
      store.dispatch(AuthErrorAction(
        login: state.login,
        password: state.password,
        errorMessage: GeneralErrors.userNotFound,
        errorCode: AuthErrorCode.other,
      ));
    }
  } on ParseException {
    store.dispatch(AuthErrorAction(
      login: state.login,
      password: state.password,
      errorMessage: GeneralErrors.parseError,
      errorCode: AuthErrorCode.other,
    ));
  } on AuthorizationException catch (e) {
    store.dispatch(AuthErrorAction(
      login: state.login,
      password: state.password,
      errorMessage: e.toString(),
      errorCode: AuthErrorCode.wrongCredentials,
    ));
  } on NotFoundException catch (e) {
    store.dispatch(AuthErrorAction(
      login: state.login,
      password: state.password,
      errorMessage: e.toString(),
      errorCode: AuthErrorCode.notFound,
    ));
  } catch (e) {
    String errorMessage = GeneralErrors.generalError;
    if (e is DioError) {
      errorMessage = DioExceptions.fromDioError(e).toString();
    } else if (e is CustomException) {
      errorMessage = e.toString();
    }
    store.dispatch(AuthErrorAction(
      login: state.login,
      password: state.password,
      errorMessage: errorMessage,
      errorCode: AuthErrorCode.other,
    ));
  }
}

void getUserData(Store<AppState> store) async {
  store.dispatch(ProcessUserAction());

  try {
    int? userId = SharedStorageService.getInt(PreferenceKey.userId);
    if (userId != null) {
      User? userData = await HiveService.getUserById(userId: userId);

      if (userData != null) {
        store.dispatch(GetUserSuccessAction(user: userData));
      } else {
        store.dispatch(UserErrorAction(user: store.state.userAppBarState.user, errorMessage: GeneralErrors.userNotFound));
      }
    } else {
      store.dispatch(UserErrorAction(user: store.state.userAppBarState.user, errorMessage: GeneralErrors.userNotFound));
    }
  } on ConnectionException {
    store.dispatch(UserErrorAction(user: store.state.userAppBarState.user, errorMessage: GeneralErrors.serverError));
  } on ParseException {
    store.dispatch(UserErrorAction(user: store.state.userAppBarState.user, errorMessage: GeneralErrors.parseError));
  } catch (e) {
    String errorMessage = GeneralErrors.generalError;
    if (e is DioError) {
      errorMessage = DioExceptions.fromDioError(e).toString();
    } else if (e is CustomException) {
      errorMessage = e.toString();
    }
    store.dispatch(UserErrorAction(user: store.state.userAppBarState.user, errorMessage: errorMessage));
  }
}

ThunkAction<AppState> toggleRememberMe({required bool value}) => (Store<AppState> store) async {
      await UseCaseModule.user().toggleRememberMe(value: value);

      store.dispatch(ToggleRememberMe(
        value: value,
      ));
    };
