// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/presentation/state/view_models/user/user_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/user_actions.dart';


final userReducer = combineReducers<UserViewModel>([
  TypedReducer<UserViewModel, ProcessUserAction>(_process),
  TypedReducer<UserViewModel, GetUserSuccessAction>(_success),
  TypedReducer<UserViewModel, UserErrorAction>(_errorHandler),
]);

UserViewModel _process(UserViewModel state, ProcessUserAction action) {
  return state.copyWith(
    user: state.user,
    isLoading: true,
    isError: false,
    errorMessage: '',
  );
}

UserViewModel _success(UserViewModel state, GetUserSuccessAction action) {
  return state.copyWith(
    user: action.user,
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}

UserViewModel _errorHandler(UserViewModel state, UserErrorAction action) {
  return state.copyWith(
    user: action.user,
    isLoading: false,
    isError: true,
    errorMessage: action.errorMessage,
  );
}
