// Package imports:
import 'package:gisogs_greenspacesapp/presentation/state/actions/address_hint_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/address_hints_view_model.dart';
import 'package:redux/redux.dart';

final addressHintsReducer = combineReducers<AddressHintsViewModel>([
  TypedReducer<AddressHintsViewModel, FetchingSuggestionsAction>(_fetch),
  TypedReducer<AddressHintsViewModel, GetSuggestionsSuccess>(_success),
  TypedReducer<AddressHintsViewModel, ClearSuggestionsAction>(_reset),
  TypedReducer<AddressHintsViewModel, GetSuggestionsError>(_error),
]);

AddressHintsViewModel _fetch(AddressHintsViewModel state, FetchingSuggestionsAction action) {
  return state.copyWith(
    query: action.query,
    toggled: true,
    suggestions: [],
    isLoading: true,
    isError: false,
    errorMessage: '',
  );
}

AddressHintsViewModel _reset(AddressHintsViewModel state, _) {
  return state.copyWith(
    query: '',
    suggestions: [],
    toggled: false,
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}

AddressHintsViewModel _success(AddressHintsViewModel state, GetSuggestionsSuccess action) {
  return state.copyWith(
    suggestions: action.suggestions,
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}

AddressHintsViewModel _error(AddressHintsViewModel state, GetSuggestionsError action) {
  return state.copyWith(
    isLoading: false,
    isError: true,
    errorMessage: action.errorMessage,
  );
}
