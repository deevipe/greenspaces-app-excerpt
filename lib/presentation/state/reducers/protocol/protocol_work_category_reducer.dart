import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_work_category_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_work_category_view_model.dart';
import 'package:redux/redux.dart';

final protocolWorkCategoryReducer = combineReducers<ProtocolWorkCategoryViewModel>([
  TypedReducer<ProtocolWorkCategoryViewModel, UpdateProtocolWorkCategory>(_update),
  TypedReducer<ProtocolWorkCategoryViewModel, FetchWorkCategories>(_fetch),
  TypedReducer<ProtocolWorkCategoryViewModel, FetchWorkCategoriesSuccess>(_success),
  TypedReducer<ProtocolWorkCategoryViewModel, ResetProtocolWorkCategory>(_reset),
  TypedReducer<ProtocolWorkCategoryViewModel, WorkCategoryError>(_error),
]);

ProtocolWorkCategoryViewModel _update(ProtocolWorkCategoryViewModel state, UpdateProtocolWorkCategory action) {
  return state.copyWith(
    selectedCategory: action.categoryId,
    isError: false,
    errorMessage: '',
  );
}

ProtocolWorkCategoryViewModel _success(ProtocolWorkCategoryViewModel state, FetchWorkCategoriesSuccess action) {
  return state.copyWith(
    selectedCategory: state.selectedCategory,
    categories: action.categories,
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}

ProtocolWorkCategoryViewModel _fetch(ProtocolWorkCategoryViewModel state, FetchWorkCategories action) {
  return state.copyWith(
    selectedCategory: state.selectedCategory,
    isLoading: true,
    isError: false,
    errorMessage: '',
  );
}

ProtocolWorkCategoryViewModel _reset(ProtocolWorkCategoryViewModel state, ResetProtocolWorkCategory action) {
  return state.copyWith(
    isLoading: false,
    isError: false,
    selectedCategory: null,
    errorMessage: '',
  );
}

ProtocolWorkCategoryViewModel _error(ProtocolWorkCategoryViewModel state, WorkCategoryError action) {
  return state.copyWith(
    selectedCategory: state.selectedCategory,
    isLoading: false,
    isError: true,
    errorMessage: action.errorMessage,
  );
}
