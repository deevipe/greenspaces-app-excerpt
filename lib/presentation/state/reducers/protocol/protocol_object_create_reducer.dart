import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_green_space_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_object_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_object_view_model.dart';
import 'package:redux/redux.dart';

final protocolObjectCreateReducer = combineReducers<ProtocolObjectViewModel>([
  TypedReducer<ProtocolObjectViewModel, FetchingObjectSelectData>(_fetch),
  TypedReducer<ProtocolObjectViewModel, FetchingWorkSubType>(_fetchSubType),
  TypedReducer<ProtocolObjectViewModel, HandleMultistemCheckbox>(_handleCheckbox),
  TypedReducer<ProtocolObjectViewModel, DropWorkSubTypes>(_dropSubtypes),
  TypedReducer<ProtocolObjectViewModel, UpdateObjectData>(_update),
  TypedReducer<ProtocolObjectViewModel, SaveGreenSpaceItem>(_saveItem),
  TypedReducer<ProtocolObjectViewModel, IncrementObjectIndex>(_increment),
  TypedReducer<ProtocolObjectViewModel, ChangeStemAmount>(_changeStems),
  TypedReducer<ProtocolObjectViewModel, ReviseObject>(_reviseObject),
  TypedReducer<ProtocolObjectViewModel, ResetGreenSpace>(_reset),
  TypedReducer<ProtocolObjectViewModel, ResetGreenSpaceItems>(_resetItems),
  TypedReducer<ProtocolObjectViewModel, FetchObjectSelectDataSuccess>(_success),
  TypedReducer<ProtocolObjectViewModel, SetObjectGreenSpaceType>(_setType),
  TypedReducer<ProtocolObjectViewModel, ProtocolObjectError>(_errorHandler),
  TypedReducer<ProtocolObjectViewModel, ToogleSaveProtocolProcess>(_toggleSaveDraft),
  TypedReducer<ProtocolObjectViewModel, SetAreaAndElementId>(_setAreaAndElement),
]);

ProtocolObjectViewModel _fetch(ProtocolObjectViewModel state, FetchingObjectSelectData action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: true,
    savedItems: state.savedItems,
    objectIndex: state.objectIndex,
    selectedDiameter: state.selectedDiameter,
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: state.selectedWorkSubType,
    selectedWorkType: state.selectedWorkType,
    otherStateValue: state.otherStateValue,
    selectedAge: state.selectedAge,
    stemAmount: state.stemAmount,
    areaValue: state.areaValue,
    amountValue: state.amountValue,
    copy: false,
  );
}

ProtocolObjectViewModel _fetchSubType(ProtocolObjectViewModel state, FetchingWorkSubType action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    fetchingWorkSubType: true,
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: state.selectedWorkSubType,
    selectedWorkType: state.selectedWorkType,
    otherStateValue: state.otherStateValue,
    selectedDiameter: state.selectedDiameter,
    selectedAge: state.selectedAge,
    stemAmount: state.stemAmount,
    areaValue: state.areaValue,
    amountValue: state.amountValue,
    copy: false,
  );
}

ProtocolObjectViewModel _success(ProtocolObjectViewModel state, FetchObjectSelectDataSuccess action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    fetchingWorkSubType: false,
    kind: action.kind,
    objectState: action.objectState,
    workType: action.workType,
    ages: action.ages,
    diameters: action.diameters,
    workSubType: action.workSubType,
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: state.selectedWorkSubType,
    selectedWorkType: state.selectedWorkType,
    otherStateValue: state.otherStateValue,
    selectedDiameter: state.selectedDiameter,
    selectedAge: state.selectedAge,
    stemAmount: state.stemAmount,
    areaValue: state.areaValue,
    amountValue: state.amountValue,
    copy: false,
  );
}

ProtocolObjectViewModel _dropSubtypes(ProtocolObjectViewModel state, DropWorkSubTypes action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    fetchingWorkSubType: false,
    kind: state.kind,
    objectState: state.objectState,
    workType: state.workType,
    workSubType: [],
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: null,
    selectedWorkType: state.selectedWorkType,
    otherStateValue: state.otherStateValue,
    selectedDiameter: state.selectedDiameter,
    selectedAge: state.selectedAge,
    stemAmount: state.stemAmount,
    areaValue: state.areaValue,
    amountValue: state.amountValue,
    copy: false,
  );
}

ProtocolObjectViewModel _handleCheckbox(ProtocolObjectViewModel state, HandleMultistemCheckbox action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    fetchingWorkSubType: false,
    kind: state.kind,
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: state.selectedWorkSubType,
    selectedWorkType: state.selectedWorkType,
    otherStateValue: state.otherStateValue,
    savedItems: state.savedItems,
    multiStem: action.value,
    selectedDiameter: state.selectedDiameter,
    selectedAge: state.selectedAge,
    stemAmount: state.stemAmount,
    areaValue: state.areaValue,
    amountValue: state.amountValue,
    copy: false,
  );
}

ProtocolObjectViewModel _update(ProtocolObjectViewModel state, UpdateObjectData action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    fetchingWorkSubType: false,
    selectedKind: action.selectedKind,
    selectedObjectState: action.selectedObjectState,
    selectedWorkSubType: action.selectedWorkSubType,
    selectedWorkType: action.selectedWorkType,
    otherStateValue: action.otherStateValue,
    selectedDiameter: action.selectedDiameter,
    selectedAge: action.selectedAge,
    stemAmount: action.stemAmount,
    areaValue: action.areaValue,
    amountValue: action.amountValue,
    stemList: action.stemList,
    copy: action.copy,
  );
}

ProtocolObjectViewModel _setType(ProtocolObjectViewModel state, SetObjectGreenSpaceType action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    type: action.type,
    fetchingWorkSubType: false,
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: state.selectedWorkSubType,
    selectedWorkType: state.selectedWorkType,
    otherStateValue: state.otherStateValue,
    selectedDiameter: state.selectedDiameter,
    copy: false,
  );
}

ProtocolObjectViewModel _saveItem(ProtocolObjectViewModel state, SaveGreenSpaceItem action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    fetchingWorkSubType: false,
    savedItems: action.savedItems,
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: state.selectedWorkSubType,
    selectedWorkType: state.selectedWorkType,
    otherStateValue: state.otherStateValue,
    selectedDiameter: state.selectedDiameter,
    multiStem: state.multiStem,
    copy: false,
  );
}

ProtocolObjectViewModel _increment(ProtocolObjectViewModel state, IncrementObjectIndex action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    objectIndex: (state.objectIndex + 1),
    fetchingWorkSubType: false,
    savedItems: state.savedItems,
    selectedKind: null,
    selectedObjectState: null,
    selectedWorkSubType: null,
    selectedWorkType: null,
    otherStateValue: '',
    selectedDiameter: null,
    multiStem: false,
    kind: [],
    workType: [],
    workSubType: [],
    objectState: [],
    copy: false,
  );
}

ProtocolObjectViewModel _changeStems(ProtocolObjectViewModel state, ChangeStemAmount action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    objectIndex: state.objectIndex,
    fetchingWorkSubType: false,
    savedItems: state.savedItems,
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: state.selectedWorkSubType,
    selectedWorkType: state.selectedWorkType,
    selectedAge: state.selectedAge,
    stemList: state.stemList,
    stemAmount: action.newAmount,
    otherStateValue: state.otherStateValue,
    selectedDiameter: state.selectedDiameter,
    multiStem: state.multiStem,
    copy: false,
  );
}

ProtocolObjectViewModel _reviseObject(ProtocolObjectViewModel state, ReviseObject action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    objectIndex: action.index,
    fetchingWorkSubType: false,
    savedItems: action.savedObjects,
    selectedKind: null,
    selectedObjectState: null,
    selectedWorkSubType: null,
    selectedWorkType: null,
    otherStateValue: '',
    selectedDiameter: null,
    multiStem: false,
    kind: [],
    workType: [],
    workSubType: [],
    objectState: [],
    copy: false,
  );
}

ProtocolObjectViewModel _reset(ProtocolObjectViewModel state, ResetGreenSpace action) {
  return state.copyWith(
    elementId: 0,
    savedAreaId: action.areaId,
    isError: false,
    errorMessage: '',
    isLoading: false,
    objectIndex: state.objectIndex,
    fetchingWorkSubType: false,
    savedItems: state.savedItems,
    selectedKind: null,
    selectedObjectState: null,
    selectedWorkSubType: null,
    selectedWorkType: null,
    otherStateValue: '',
    selectedDiameter: null,
    multiStem: false,
    kind: [],
    workType: [],
    workSubType: [],
    objectState: [],
    copy: false,
  );
}

ProtocolObjectViewModel _resetItems(ProtocolObjectViewModel state, ResetGreenSpaceItems action) {
  return state.copyWith(
    isError: false,
    errorMessage: '',
    isLoading: false,
    objectIndex: null,
    fetchingWorkSubType: false,
    savedItems: [],
    selectedKind: null,
    selectedObjectState: null,
    selectedWorkSubType: null,
    selectedWorkType: null,
    otherStateValue: '',
    selectedDiameter: null,
    multiStem: false,
    kind: [],
    workType: [],
    workSubType: [],
    objectState: [],
    copy: false,
  );
}

ProtocolObjectViewModel _errorHandler(ProtocolObjectViewModel state, ProtocolObjectError action) {
  return state.copyWith(
    isLoading: false,
    fetchingWorkSubType: false,
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: state.selectedWorkSubType,
    selectedWorkType: state.selectedWorkType,
    otherStateValue: state.otherStateValue,
    selectedDiameter: state.selectedDiameter,
    isError: true,
    processingDraft: false,
    errorMessage: action.errorMessage,
  );
}

ProtocolObjectViewModel _toggleSaveDraft(ProtocolObjectViewModel state, ToogleSaveProtocolProcess action) {
  return state.copyWith(
    isLoading: false,
    fetchingWorkSubType: false,
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: state.selectedWorkSubType,
    selectedWorkType: state.selectedWorkType,
    otherStateValue: state.otherStateValue,
    selectedDiameter: state.selectedDiameter,
    selectedAge: state.selectedAge,
    areaValue: state.areaValue,
    amountValue: state.amountValue,
    stemAmount: state.stemAmount,
    isError: false,
    redirectOption: action.option,
    processingDraft: action.isProcessing,
    errorMessage: '',
  );
}

ProtocolObjectViewModel _setAreaAndElement(ProtocolObjectViewModel state, SetAreaAndElementId action) {
  return state.copyWith(
    elementId: action.elementId,

    isLoading: false,
    fetchingWorkSubType: false,
    selectedKind: state.selectedKind,
    selectedObjectState: state.selectedObjectState,
    selectedWorkSubType: state.selectedWorkSubType,
    selectedWorkType: state.selectedWorkType,
    otherStateValue: state.otherStateValue,
    selectedDiameter: state.selectedDiameter,
    selectedAge: state.selectedAge,
    areaValue: state.areaValue,
    amountValue: state.amountValue,
    stemAmount: state.stemAmount,
    isError: false,
    redirectOption: state.redirectOption,
    processingDraft: state.processingDraft,
    errorMessage: '',
  );
}
