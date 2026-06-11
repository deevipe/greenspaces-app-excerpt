import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';

class FetchingProtocolFourthStep {
  final bool refresh;
  FetchingProtocolFourthStep({required this.refresh});
}

class FetchingCommitteeDependencies {
  final UniqueKey widgetKey;
  final bool spp;
  FetchingCommitteeDependencies({required this.spp, required this.widgetKey});
}

class FetchProtocolFourthStepSuccess {
  final List<Organisation> committeeList;
  final List<Organisation> sppList;
  final Map<UniqueKey, List<OrganisationUser>> usersForSelects;

  FetchProtocolFourthStepSuccess({
    required this.committeeList,
    required this.sppList,
    required this.usersForSelects,
  });
}

class UpdateSelectChoice {
  final UniqueKey? widgetKey;
  final List<Representative>? committeeRepresentatives;
  final List<Representative>? sppRepresentatives;
  final String? otherOrg;
  final String? otherFieldFio;
  final String? otherFieldPhone;
  final String? otherFieldPosition;

  UpdateSelectChoice({
    required this.widgetKey,
    this.committeeRepresentatives,
    this.sppRepresentatives,
    this.otherOrg,
    this.otherFieldFio,
    this.otherFieldPhone,
    this.otherFieldPosition,
  });
}

class UpdateOtherOrgChoice {
  final String? selectedOtherOrg;
  UpdateOtherOrgChoice({this.selectedOtherOrg});
}

class ProtocolFourthStepError {
  final String errorMessage;

  ProtocolFourthStepError({
    required this.errorMessage,
  });
}

class ResetRepresentativesStep {}

class SearchOtherOrgs {}

class SearchOtherOrgsSuccess {
  final List<Organisation> list;
  SearchOtherOrgsSuccess({required this.list});
}

class ClearOtherOrg {}

class SearchOtherOrgsError {
  final String errorMessage;
  SearchOtherOrgsError({required this.errorMessage});
}

class UpdateRepresentativesBlock {
  final OrganizationType type;
  final List<Representative> newList;
  final UniqueKey? widgetKey;
  UpdateRepresentativesBlock({this.widgetKey, required this.type, required this.newList});
}

class ToggleStepValidationError {
  final bool validationFailed;
  final bool fillFio;
  final bool fillPhone;
  final bool fillPosition;
  ToggleStepValidationError({
    required this.validationFailed,
    required this.fillFio,
    required this.fillPhone,
    required this.fillPosition,
  });
}
