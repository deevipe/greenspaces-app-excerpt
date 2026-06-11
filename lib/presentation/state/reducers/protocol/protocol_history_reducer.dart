import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_history_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_history_view_model.dart';
import 'package:redux/redux.dart';

final protocolHistoryReducer = combineReducers<ProtocolHistoryViewModel>([
  TypedReducer<ProtocolHistoryViewModel, FetchingProtocolHistory>(_process),
  TypedReducer<ProtocolHistoryViewModel, FetchingProtocolHistorySuccess>(_success),
  TypedReducer<ProtocolHistoryViewModel, ResetProtocolHistory>(_reset),
  TypedReducer<ProtocolHistoryViewModel, ProtocolHistoryError>(_errorHandler),
]);

ProtocolHistoryViewModel _process(ProtocolHistoryViewModel state, FetchingProtocolHistory action) {
  return state.copyWith(
    isLoading: true,
    isError: false,
    errorMessage: '',
  );
}

ProtocolHistoryViewModel _success(ProtocolHistoryViewModel state, FetchingProtocolHistorySuccess action) {
  return state.copyWith(
    isLoading: false,
    history: action.list,
    isError: false,
    errorMessage: '',
  );
}

ProtocolHistoryViewModel _reset(ProtocolHistoryViewModel state, ResetProtocolHistory action) {
  return state.copyWith(
    isLoading: false,
    history: [],
    isError: false,
    errorMessage: '',
  );
}

ProtocolHistoryViewModel _errorHandler(ProtocolHistoryViewModel state, ProtocolHistoryError action) {
  return state.copyWith(
    history: state.history,
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}
