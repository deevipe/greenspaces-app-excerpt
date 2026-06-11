import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';

@immutable
class ProtocolGeneralViewModel {
  final int? draftId;
  final String date;
  final List<Organisation> orgsList;
  final List<Municipality> municipalitiesList;
  final List<SelectObject> districtsList;
  final Municipality? selectedMunicipality;
  final SelectObject? selectedDistrict;
  final Organisation? selectedOrg;
  final int? departmentId;
  final bool contract;
  final bool subContract;
  final bool otherOpt;
  final bool? revision;
  final bool preparingForRevision;
  final bool? needAuth;
  final String? contractRequisites;
  final String? subContractRequisites;
  final String? otherRequisites;
  final bool processing;
  final bool searchingOrgs;
  final bool? isError;
  final bool? searchError;
  final bool? fetchingMunicipalities;
  final String? errorMessage;
  final String? searchErrorMessage;
  final List<Doc> docs;

  const ProtocolGeneralViewModel({
    this.draftId,
    required this.date,
    required this.processing,
    required this.searchingOrgs,
    required this.searchError,
    this.departmentId,
    required this.orgsList,
    required this.municipalitiesList,
    required this.districtsList,
    this.selectedMunicipality,
    this.selectedOrg,
    this.selectedDistrict,
    required this.contract,
    required this.subContract,
    required this.otherOpt,
    required this.preparingForRevision,
    this.needAuth,
    this.isError,
    this.errorMessage,
    this.contractRequisites,
    this.subContractRequisites,
    this.otherRequisites,
    this.revision,
    this.fetchingMunicipalities,
    this.searchErrorMessage,
    required this.docs,
  });

  factory ProtocolGeneralViewModel.initial() => const ProtocolGeneralViewModel(
        orgsList: [],
        municipalitiesList: [],
        districtsList: [],
        date: '',
        contract: false,
        subContract: false,
        preparingForRevision: false,
        otherOpt: false,
        contractRequisites: '',
        subContractRequisites: '',
        otherRequisites: '',
        processing: false,
        searchingOrgs: false,
        searchError: false,
        isError: false,
        fetchingMunicipalities: false,
        docs: [],
      );

  ProtocolGeneralViewModel copyWith({
    List<Organisation>? orgsList,
    List<Municipality>? municipalitiesList,
    List<SelectObject>? districtsList,
    Organisation? selectedOrg,
    Municipality? selectedMunicipality,
    SelectObject? selectedDistrict,
    int? draftId,
    String? date,
    int? departmentId,
    bool? contract,
    bool? subContract,
    bool? otherOpt,
    bool? revision,
    bool? needAuth,
    bool? searchError,
    bool? fetchingMunicipalities,
    bool? preparingForRevision,
    String? contractRequisites,
    String? subContractRequisites,
    String? otherRequisites,
    bool? isError,
    bool? processing,
    bool? searchingOrgs,
    String? errorMessage,
    String? searchErrorMessage,
    List<Doc>? docs,
  }) =>
      ProtocolGeneralViewModel(
        draftId: draftId,
        orgsList: orgsList ?? this.orgsList,
        municipalitiesList: municipalitiesList ?? this.municipalitiesList,
        districtsList: districtsList ?? this.districtsList,
        selectedMunicipality: selectedMunicipality,
        selectedOrg: selectedOrg,
        selectedDistrict: selectedDistrict,
        date: date ?? this.date,
        departmentId: departmentId,
        needAuth: needAuth,
        contract: contract ?? this.contract,
        subContract: subContract ?? this.subContract,
        otherOpt: otherOpt ?? this.otherOpt,
        contractRequisites: contractRequisites ?? this.contractRequisites,
        subContractRequisites: subContractRequisites ?? this.subContractRequisites,
        otherRequisites: otherRequisites ?? this.otherRequisites,
        revision: revision ?? this.revision,
        preparingForRevision: preparingForRevision ?? this.preparingForRevision,
        isError: isError,
        processing: processing ?? this.processing,
        searchingOrgs: searchingOrgs ?? this.searchingOrgs,
        searchError: searchError ?? this.searchError,
        errorMessage: errorMessage,
        searchErrorMessage: searchErrorMessage,
        fetchingMunicipalities: fetchingMunicipalities ?? this.fetchingMunicipalities,
        docs: docs ?? this.docs,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolGeneralViewModel &&
          runtimeType == other.runtimeType &&
          json.encode(orgsList) == json.encode(other.orgsList) &&
          json.encode(municipalitiesList) == json.encode(other.municipalitiesList) &&
          json.encode(districtsList) == json.encode(other.districtsList) &&
          json.encode(docs) == json.encode(other.docs) &&
          selectedOrg == other.selectedOrg &&
          selectedMunicipality == other.selectedMunicipality &&
          selectedDistrict == other.selectedDistrict &&
          draftId == other.draftId &&
          date == other.date &&
          departmentId == other.departmentId &&
          isError == other.isError &&
          errorMessage == other.errorMessage &&
          searchErrorMessage == other.searchErrorMessage &&
          needAuth == other.needAuth &&
          contract == other.contract &&
          subContract == other.subContract &&
          otherOpt == other.otherOpt &&
          revision == other.revision &&
          preparingForRevision == other.preparingForRevision &&
          contractRequisites == other.contractRequisites &&
          subContractRequisites == other.subContractRequisites &&
          processing == other.processing &&
          searchingOrgs == other.searchingOrgs &&
          searchError == other.searchError &&
          fetchingMunicipalities == other.fetchingMunicipalities &&
          otherRequisites == other.otherRequisites;

  @override
  int get hashCode =>
      orgsList.hashCode ^
      municipalitiesList.hashCode ^
      districtsList.hashCode ^
      selectedMunicipality.hashCode ^
      selectedOrg.hashCode ^
      selectedDistrict.hashCode ^
      draftId.hashCode ^
      date.hashCode ^
      departmentId.hashCode ^
      isError.hashCode ^
      errorMessage.hashCode ^
      searchErrorMessage.hashCode ^
      needAuth.hashCode ^
      contract.hashCode ^
      subContract.hashCode ^
      otherOpt.hashCode ^
      preparingForRevision.hashCode ^
      revision.hashCode ^
      contractRequisites.hashCode ^
      subContractRequisites.hashCode ^
      processing.hashCode ^
      searchingOrgs.hashCode ^
      searchError.hashCode ^
      fetchingMunicipalities.hashCode ^
      otherRequisites.hashCode;
}
