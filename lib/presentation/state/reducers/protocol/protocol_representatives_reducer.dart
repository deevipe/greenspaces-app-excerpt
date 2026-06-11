import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_representatives_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_representatives_view_model.dart';
import 'package:redux/redux.dart';

final protocolRepresentativesReducer = combineReducers<ProtocolRepresentativesViewModel>([
  TypedReducer<ProtocolRepresentativesViewModel, FetchingProtocolFourthStep>(_process),
  TypedReducer<ProtocolRepresentativesViewModel, FetchingCommitteeDependencies>(_fetchDeps),
  TypedReducer<ProtocolRepresentativesViewModel, UpdateSelectChoice>(_update),
  TypedReducer<ProtocolRepresentativesViewModel, UpdateOtherOrgChoice>(_updateOtherOrg),
  TypedReducer<ProtocolRepresentativesViewModel, FetchProtocolFourthStepSuccess>(_success),
  TypedReducer<ProtocolRepresentativesViewModel, ProtocolFourthStepError>(_errorHandler),
  TypedReducer<ProtocolRepresentativesViewModel, ResetRepresentativesStep>(_reset),
  TypedReducer<ProtocolRepresentativesViewModel, SearchOtherOrgs>(_searchOtherOrgs),
  TypedReducer<ProtocolRepresentativesViewModel, SearchOtherOrgsError>(_searchError),
  TypedReducer<ProtocolRepresentativesViewModel, SearchOtherOrgsSuccess>(_searchSuccess),
  TypedReducer<ProtocolRepresentativesViewModel, ClearOtherOrg>(_clearOtherOrgs),
  TypedReducer<ProtocolRepresentativesViewModel, UpdateRepresentativesBlock>(_updateRepresentatives),
  TypedReducer<ProtocolRepresentativesViewModel, ToggleStepValidationError>(_toggleValid),
]);

ProtocolRepresentativesViewModel _process(ProtocolRepresentativesViewModel state, FetchingProtocolFourthStep action) {
  return state.copyWith(
    isLoading: !action.refresh,
    fetchingDependencies: false,
    fetchingSppDependencies: false,
    committeeList: state.committeeList,
    sppList: state.sppList,
    usersForSelects: state.usersForSelects,
    otherFieldFio: state.otherFieldFio,
    selectedOtherOrg: state.selectedOtherOrg,
    isError: false,
    errorMessage: '',
    searchError: false,
    searchErrorMessage: '',
  );
}

ProtocolRepresentativesViewModel _fetchDeps(ProtocolRepresentativesViewModel state, FetchingCommitteeDependencies action) {
  return state.copyWith(
    isLoading: false,
    fetchingDependencies: !action.spp,
    fetchingSppDependencies: action.spp,
    widgetKey: action.widgetKey,
    otherFieldFio: state.otherFieldFio,
    isError: false,
    errorMessage: '',
    searchError: false,
    searchErrorMessage: '',
    selectedOtherOrg: state.selectedOtherOrg,
  );
}

ProtocolRepresentativesViewModel _update(ProtocolRepresentativesViewModel state, UpdateSelectChoice action) {
  return state.copyWith(
    committeeRepresentatives: action.committeeRepresentatives,
    sppRepresentatives: action.sppRepresentatives,
    otherFieldFio: action.otherFieldFio,
    otherFieldPhone: action.otherFieldPhone,
    otherFieldPosition: action.otherFieldPosition,
    searchError: false,
    selectedOtherOrg: action.otherOrg ?? state.selectedOtherOrg,
    searchErrorMessage: '',
    widgetKey: action.widgetKey,
    validationFailed: false,
  );
}

ProtocolRepresentativesViewModel _updateOtherOrg(ProtocolRepresentativesViewModel state, UpdateOtherOrgChoice action) {
  return state.copyWith(otherFieldFio: state.otherFieldFio, selectedOtherOrg: action.selectedOtherOrg, searchError: false, searchErrorMessage: '');
}

ProtocolRepresentativesViewModel _success(ProtocolRepresentativesViewModel state, FetchProtocolFourthStepSuccess action) {
  return state.copyWith(
      committeeList: action.committeeList,
      sppList: action.sppList,
      usersForSelects: action.usersForSelects,
      isLoading: false,
      fetchingDependencies: false,
      fetchingSppDependencies: false,
      isError: false,
      errorMessage: '',
      searchError: false,
      selectedOtherOrg: state.selectedOtherOrg,
      searchErrorMessage: '');
}

ProtocolRepresentativesViewModel _reset(ProtocolRepresentativesViewModel state, ResetRepresentativesStep action) {
  return state.copyWith(
    widgetKey: null,
    committeeList: [],
    sppList: [],
    otherList: [],
    committeeRepresentatives: [Representative.generateDefault(type: OrganizationType.committee)],
    sppRepresentatives: [Representative.generateDefault(type: OrganizationType.spp)],
    usersForSelects: {},
    isLoading: false,
    fetchingDependencies: false,
    fetchingSppDependencies: false,
    isError: false,
    errorMessage: '',
    searchError: false,
    selectedOtherOrg: null,
    otherFieldFio: '',
    searchErrorMessage: '',
  );
}

ProtocolRepresentativesViewModel _errorHandler(ProtocolRepresentativesViewModel state, ProtocolFourthStepError action) {
  return state.copyWith(
      isLoading: false,
      fetchingDependencies: false,
      isError: true,
      errorMessage: action.errorMessage,
      searchError: false,
      selectedOtherOrg: state.selectedOtherOrg,
      searchErrorMessage: '');
}

ProtocolRepresentativesViewModel _searchOtherOrgs(ProtocolRepresentativesViewModel state, SearchOtherOrgs action) {
  return state.copyWith(
    isLoading: false,
    fetchingDependencies: false,
    searchingOtherOrgs: true,
    isError: false,
    errorMessage: '',
    searchError: false,
    searchErrorMessage: '',
    otherFieldFio: state.otherFieldFio,
  );
}

ProtocolRepresentativesViewModel _searchError(ProtocolRepresentativesViewModel state, SearchOtherOrgsError action) {
  return state.copyWith(
    isLoading: false,
    fetchingDependencies: false,
    searchingOtherOrgs: false,
    isError: false,
    errorMessage: '',
    searchError: true,
    searchErrorMessage: action.errorMessage,
    selectedOtherOrg: state.selectedOtherOrg,
    otherFieldFio: state.otherFieldFio,
  );
}

ProtocolRepresentativesViewModel _searchSuccess(ProtocolRepresentativesViewModel state, SearchOtherOrgsSuccess action) {
  return state.copyWith(
    isLoading: false,
    fetchingDependencies: false,
    searchingOtherOrgs: false,
    isError: false,
    errorMessage: '',
    searchError: false,
    searchErrorMessage: '',
    otherFieldFio: state.otherFieldFio,
    selectedOtherOrg: state.selectedOtherOrg,
    otherList: action.list,
  );
}

ProtocolRepresentativesViewModel _clearOtherOrgs(ProtocolRepresentativesViewModel state, ClearOtherOrg action) {
  return state.copyWith(
    isLoading: false,
    fetchingDependencies: false,
    searchingOtherOrgs: false,
    isError: false,
    errorMessage: '',
    searchError: false,
    searchErrorMessage: '',
    otherFieldFio: state.otherFieldFio,
    selectedOtherOrg: null,
    otherList: [],
  );
}

ProtocolRepresentativesViewModel _updateRepresentatives(ProtocolRepresentativesViewModel state, UpdateRepresentativesBlock action) {
  return state.copyWith(
    isLoading: false,
    isError: false,
    searchError: false,
    widgetKey: action.widgetKey,
    selectedOtherOrg: state.selectedOtherOrg,
    committeeRepresentatives: action.type == OrganizationType.committee ? action.newList : state.committeeRepresentatives,
    sppRepresentatives: action.type == OrganizationType.spp ? action.newList : state.sppRepresentatives,
    errorMessage: '',
    searchErrorMessage: '',
  );
}

ProtocolRepresentativesViewModel _toggleValid(ProtocolRepresentativesViewModel state, ToggleStepValidationError action) {
  return state.copyWith(
    isLoading: false,
    isError: false,
    searchError: false,
    widgetKey: null,
    committeeRepresentatives: state.committeeRepresentatives,
    sppRepresentatives: state.sppRepresentatives,
    selectedOtherOrg: state.selectedOtherOrg,
    validationFailed: action.validationFailed,
    fillFio: action.fillFio,
    fillPhone: action.fillPhone,
    fillPosition: action.fillPosition,
  );
}
