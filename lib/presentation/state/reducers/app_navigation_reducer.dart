import 'package:gisogs_greenspacesapp/presentation/state/actions/app_navigation_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/app_navigation_view_model.dart';
import 'package:redux/redux.dart';

final appNavReducer = combineReducers<AppNavigationViewModel>([
  TypedReducer<AppNavigationViewModel, UpdateAppNavigation>(_update),
]);

AppNavigationViewModel _update(AppNavigationViewModel state, UpdateAppNavigation action) {
  return state.copyWith(
    formIsOpen: action.formIsOpen,
  );
}
