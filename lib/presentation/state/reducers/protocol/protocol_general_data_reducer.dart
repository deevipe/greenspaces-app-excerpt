import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_general_data_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_general_data_view_model.dart';
import 'package:redux/redux.dart';

final protocolGeneralReducer = combineReducers<ProtocolGeneralViewModel>([
  TypedReducer<ProtocolGeneralViewModel, UpdateGeneralProtocolData>(_update),
  TypedReducer<ProtocolGeneralViewModel, ProcessingDictionaries>(_processing),
  TypedReducer<ProtocolGeneralViewModel, SetProtocolDraftId>(_setDraft),
  TypedReducer<ProtocolGeneralViewModel, ResetGeneralProtocolData>(_reset),
  TypedReducer<ProtocolGeneralViewModel, PrepareForRevision>(_prepare),
  TypedReducer<ProtocolGeneralViewModel, GeneralProtocolDataError>(_error),
  TypedReducer<ProtocolGeneralViewModel, SearchOrgs>(_searchOtherOrgs),
  TypedReducer<ProtocolGeneralViewModel, SearchOrgsError>(_searchError),
  TypedReducer<ProtocolGeneralViewModel, SearchOrgsSuccess>(_searchSuccess),
  TypedReducer<ProtocolGeneralViewModel, ClearOrg>(_clearOtherOrgs),
  TypedReducer<ProtocolGeneralViewModel, RefreshMunicipalitiesList>(_fetchMunicipalities),
]);

ProtocolGeneralViewModel _update(ProtocolGeneralViewModel state, UpdateGeneralProtocolData action) {
  return state.copyWith(
    draftId: state.draftId,
    date: action.date,
    departmentId: action.departmentId,
    selectedDistrict: action.selectedDistrict,
    selectedMunicipality: action.selectedMunicpality,
    selectedOrg: action.selectedorg,
    contract: action.contract,
    subContract: action.subContract,
    otherOpt: action.otherOpt,
    contractRequisites: action.contractRequisites,
    subContractRequisites: action.subContractRequisites,
    otherRequisites: action.otherRequisites,
    docs: action.docs,
  );
}

ProtocolGeneralViewModel _processing(ProtocolGeneralViewModel state, ProcessingDictionaries action) {
  return state.copyWith(
    processing: action.processing,
    draftId: state.draftId,
    departmentId: state.departmentId,
    selectedDistrict: state.selectedDistrict,
    selectedMunicipality: state.selectedMunicipality,
    selectedOrg: state.selectedOrg,
    districtsList: action.districts,
    municipalitiesList: action.municipalities,
  );
}

ProtocolGeneralViewModel _setDraft(ProtocolGeneralViewModel state, SetProtocolDraftId action) {
  return state.copyWith(
    draftId: action.id,
    revision: action.revision,
    date: state.date,
    departmentId: state.departmentId,
    contract: state.contract,
    subContract: state.subContract,
    otherOpt: state.otherOpt,
    contractRequisites: state.contractRequisites,
    subContractRequisites: state.subContractRequisites,
    selectedDistrict: state.selectedDistrict,
    selectedMunicipality: state.selectedMunicipality,
    selectedOrg: state.selectedOrg,
    otherRequisites: state.otherRequisites,
  );
}

ProtocolGeneralViewModel _reset(ProtocolGeneralViewModel state, ResetGeneralProtocolData action) {
  return state.copyWith(
    draftId: null,
    revision: false,
    date: '',
    departmentId: null,
    contract: false,
    subContract: false,
    otherOpt: false,
    contractRequisites: '',
    subContractRequisites: '',
    selectedDistrict: null,
    selectedMunicipality: null,
    selectedOrg: null,
    otherRequisites: '',
  );
}

ProtocolGeneralViewModel _prepare(ProtocolGeneralViewModel state, PrepareForRevision action) {
  return state.copyWith(
    draftId: state.draftId,
    revision: state.revision,
    date: state.date,
    departmentId: state.departmentId,
    contract: state.contract,
    subContract: state.subContract,
    otherOpt: state.otherOpt,
    contractRequisites: state.contractRequisites,
    subContractRequisites: state.subContractRequisites,
    otherRequisites: state.otherRequisites,
    selectedDistrict: state.selectedDistrict,
    selectedMunicipality: state.selectedMunicipality,
    selectedOrg: state.selectedOrg,
    preparingForRevision: !action.finished,
  );
}

ProtocolGeneralViewModel _error(ProtocolGeneralViewModel state, GeneralProtocolDataError action) {
  return state.copyWith(
    draftId: state.draftId,
    revision: state.revision,
    date: state.date,
    departmentId: state.departmentId,
    contract: state.contract,
    subContract: state.subContract,
    otherOpt: state.otherOpt,
    contractRequisites: state.contractRequisites,
    subContractRequisites: state.subContractRequisites,
    otherRequisites: state.otherRequisites,
    preparingForRevision: state.preparingForRevision,
    needAuth: action.needAuth,
    selectedDistrict: state.selectedDistrict,
    selectedMunicipality: state.selectedMunicipality,
    selectedOrg: state.selectedOrg,
    isError: action.isError,
    errorMessage: action.errorMessage,
  );
}

ProtocolGeneralViewModel _searchOtherOrgs(ProtocolGeneralViewModel state, SearchOrgs action) {
  return state.copyWith(
    draftId: state.draftId,
    departmentId: state.departmentId,
    searchingOrgs: true,
    isError: false,
    errorMessage: '',
    searchError: false,
    searchErrorMessage: '',
    selectedDistrict: state.selectedDistrict,
    selectedMunicipality: state.selectedMunicipality,
    selectedOrg: state.selectedOrg,
  );
}

ProtocolGeneralViewModel _searchError(ProtocolGeneralViewModel state, SearchOrgsError action) {
  return state.copyWith(
    draftId: state.draftId,
    departmentId: state.departmentId,
    isError: false,
    searchingOrgs: false,
    errorMessage: '',
    searchError: true,
    searchErrorMessage: action.errorMessage,
    selectedDistrict: state.selectedDistrict,
    selectedMunicipality: state.selectedMunicipality,
    selectedOrg: state.selectedOrg,
  );
}

ProtocolGeneralViewModel _searchSuccess(ProtocolGeneralViewModel state, SearchOrgsSuccess action) {
  return state.copyWith(
    draftId: state.draftId,
    departmentId: state.departmentId,
    isError: false,
    searchingOrgs: false,
    errorMessage: '',
    searchError: false,
    searchErrorMessage: '',
    orgsList: action.list,
    selectedDistrict: state.selectedDistrict,
    selectedMunicipality: state.selectedMunicipality,
    selectedOrg: state.selectedOrg,
  );
}

ProtocolGeneralViewModel _clearOtherOrgs(ProtocolGeneralViewModel state, ClearOrg action) {
  return state.copyWith(
    draftId: state.draftId,
    departmentId: state.departmentId,
    isError: false,
    errorMessage: '',
    searchingOrgs: false,
    searchError: false,
    searchErrorMessage: '',
    selectedOrg: null,
    selectedDistrict: state.selectedDistrict,
    selectedMunicipality: state.selectedMunicipality,
    orgsList: [],
  );
}

ProtocolGeneralViewModel _fetchMunicipalities(ProtocolGeneralViewModel state, RefreshMunicipalitiesList action) {
  return state.copyWith(
    draftId: state.draftId,
    departmentId: state.departmentId,
    isError: false,
    errorMessage: '',
    searchingOrgs: false,
    searchError: false,
    searchErrorMessage: '',
    selectedDistrict: state.selectedDistrict,
    selectedMunicipality: null,
    selectedOrg: state.selectedOrg,
    orgsList: state.orgsList,
    municipalitiesList: action.list,
    fetchingMunicipalities: action.fetching,
  );
}
