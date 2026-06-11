import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_territory_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_territory_view_model.dart';
import 'package:redux/redux.dart';

final protocolTerritoryReducer = combineReducers<ProtocolTerritoryViewModel>([
  TypedReducer<ProtocolTerritoryViewModel, FetchingTerritoryData>(_fetching),
  TypedReducer<ProtocolTerritoryViewModel, FetchingTerritoryDataSuccess>(_success),
  TypedReducer<ProtocolTerritoryViewModel, UpdateTerritoryStepAction>(_update),
  TypedReducer<ProtocolTerritoryViewModel, DropSelectedTerritory>(_dropTerritory),
  TypedReducer<ProtocolTerritoryViewModel, ProtocolTerritoryError>(_error),
]);

ProtocolTerritoryViewModel _fetching(ProtocolTerritoryViewModel state, FetchingTerritoryData action) {
  return state.copyWith(
    ogs: state.ogs,
    isLoading: true,
    isError: false,
    errorMessage: '',
  );
}

ProtocolTerritoryViewModel _success(ProtocolTerritoryViewModel state, FetchingTerritoryDataSuccess action) {
  return state.copyWith(
    ogs: state.ogs,
    selectedType: state.selectedType,
    list: action.list,
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}

ProtocolTerritoryViewModel _update(ProtocolTerritoryViewModel state, UpdateTerritoryStepAction action) {
  return state.copyWith(
    ogs: action.ogs,
    selectedType: action.selectedType,
    typeUrl: action.typeUrl,
    address: action.address,
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}

ProtocolTerritoryViewModel _dropTerritory(ProtocolTerritoryViewModel state, DropSelectedTerritory action) {
  return state.copyWith(
    ogs: null,
    selectedType: null,
    address: '',
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}

ProtocolTerritoryViewModel _error(ProtocolTerritoryViewModel state, ProtocolTerritoryError action) {
  return state.copyWith(
    ogs: state.ogs,
    selectedType: state.selectedType,
    address: state.address,
    isLoading: false,
    isError: true,
    errorMessage: action.errorMessage,
  );
}
