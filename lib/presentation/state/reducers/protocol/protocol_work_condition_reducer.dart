import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_work_condition_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_work_conditions_view_model.dart';
import 'package:redux/redux.dart';

final protocolWorkConditionReducer = combineReducers<ProtocolWorkConditionViewModel>([
  TypedReducer<ProtocolWorkConditionViewModel, UpdateProtocolWorkCondition>(_update),
  TypedReducer<ProtocolWorkConditionViewModel, ResetProtocolWorkCondition>(_reset),
  TypedReducer<ProtocolWorkConditionViewModel, FetchWorkConditions>(_fetch),
  TypedReducer<ProtocolWorkConditionViewModel, FetchWorkConditionsSuccess>(_success),
  TypedReducer<ProtocolWorkConditionViewModel, WorkConditionsError>(_error),
]);

ProtocolWorkConditionViewModel _fetch(ProtocolWorkConditionViewModel state, FetchWorkConditions action) {
  return state.copyWith(
    selectedCondition: [],
    isLoading: true,
    isError: false,
    errorMessage: '',
  );
}

ProtocolWorkConditionViewModel _success(ProtocolWorkConditionViewModel state, FetchWorkConditionsSuccess action) {
  return state.copyWith(
    conditions: action.conditions,
    selectedCondition: state.selectedCondition,
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}

ProtocolWorkConditionViewModel _update(ProtocolWorkConditionViewModel state, UpdateProtocolWorkCondition action) {
  return state.copyWith(
    selectedCondition: action.condition,
    otherName: action.otherName,
  );
}

ProtocolWorkConditionViewModel _reset(ProtocolWorkConditionViewModel state, ResetProtocolWorkCondition action) {
  return state.copyWith(
    selectedCondition: [],
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}

ProtocolWorkConditionViewModel _error(ProtocolWorkConditionViewModel state, WorkConditionsError action) {
  return state.copyWith(
    conditions: state.conditions,
    selectedCondition: state.selectedCondition,
    isLoading: false,
    isError: true,
    errorMessage: action.errorMessage,
  );
}
