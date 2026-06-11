import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_green_space_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_green_space_view_model.dart';
import 'package:redux/redux.dart';

final protocolGreenSpaceReducer = combineReducers<ProtocolGreenSpaceViewModel>([
  TypedReducer<ProtocolGreenSpaceViewModel, FetchingAvailableGSList>(_process),
  TypedReducer<ProtocolGreenSpaceViewModel, FetchingAvailableGSListSuccess>(_success),
  TypedReducer<ProtocolGreenSpaceViewModel, UpdateGSAction>(_update),
  TypedReducer<ProtocolGreenSpaceViewModel, ResetGreenSpace>(_reset),
  TypedReducer<ProtocolGreenSpaceViewModel, ProtocolGSError>(_errorHandler),
]);

ProtocolGreenSpaceViewModel _process(ProtocolGreenSpaceViewModel state, FetchingAvailableGSList action) {
  return state.copyWith(
    selectedGreenSpace: null,
    isLoading: true,
    isError: false,
    errorMessage: '',
  );
}

ProtocolGreenSpaceViewModel _success(ProtocolGreenSpaceViewModel state, FetchingAvailableGSListSuccess action) {
  return state.copyWith(
    isLoading: false,
    availableList: action.list,
    isError: false,
    errorMessage: '',
  );
}

ProtocolGreenSpaceViewModel _update(ProtocolGreenSpaceViewModel state, UpdateGSAction action) {
  return state.copyWith(
    isLoading: false,
    availableList: state.availableList,
    selectedGreenSpace: action.selected,
    isError: false,
    errorMessage: '',
  );
}

ProtocolGreenSpaceViewModel _reset(ProtocolGreenSpaceViewModel state, ResetGreenSpace action) {
  return state.copyWith(
    isLoading: false,
    availableList: state.availableList,
    selectedGreenSpace: null,
    isError: false,
    errorMessage: '',
  );
}

ProtocolGreenSpaceViewModel _errorHandler(ProtocolGreenSpaceViewModel state, ProtocolGSError action) {
  return state.copyWith(
    availableList: state.availableList,
    selectedGreenSpace: state.selectedGreenSpace,
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}
