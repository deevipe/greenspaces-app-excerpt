import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';

class UpdateGeneralProtocolData {
  final String? date;
  final int? departmentId;
  final Municipality? selectedMunicpality;
  final SelectObject? selectedDistrict;
  final Organisation? selectedorg;
  final bool? contract;
  final bool? subContract;
  final bool? otherOpt;
  final String? contractRequisites;
  final String? subContractRequisites;
  final String? otherRequisites;
  final List<Doc>? docs;
  UpdateGeneralProtocolData({
    this.date,
    this.departmentId,
    this.contract,
    this.subContract,
    this.otherOpt,
    this.contractRequisites,
    this.subContractRequisites,
    this.otherRequisites,
    this.selectedDistrict,
    this.selectedMunicpality,
    this.selectedorg,
    this.docs,
  });
}

class SetProtocolDraftId {
  final int id;
  final bool revision;
  SetProtocolDraftId({required this.id, required this.revision});
}

class ResetGeneralProtocolData {}

class PrepareForRevision {
  final bool finished;
  PrepareForRevision({required this.finished});
}

class GeneralProtocolDataError {
  final bool needAuth;
  final bool isError;
  final String? errorMessage;

  GeneralProtocolDataError({required this.needAuth, required this.isError, this.errorMessage});
}

class ProcessingDictionaries {
  final bool processing;
  final List<SelectObject> districts;
  final List<Municipality> municipalities;

  ProcessingDictionaries({required this.processing, required this.districts, required this.municipalities});
}

class SearchOrgs {}

class SearchOrgsSuccess {
  final List<Organisation> list;
  SearchOrgsSuccess({required this.list});
}

class ClearOrg {}

class SearchOrgsError {
  final String errorMessage;
  SearchOrgsError({required this.errorMessage});
}

class RefreshMunicipalitiesList {
  final bool fetching;
  final List<Municipality> list;

  RefreshMunicipalitiesList({required this.fetching, required this.list});
}

class UpdateUploadedDocs {
  final List<Doc> docs;

  UpdateUploadedDocs({required this.docs});
}
