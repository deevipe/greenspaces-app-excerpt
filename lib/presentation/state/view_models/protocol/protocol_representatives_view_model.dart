import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';

@immutable
class ProtocolRepresentativesViewModel {
  final List<Organisation> committeeList;
  final List<Organisation> sppList;
  final List<Organisation> otherList;
  final List<Representative> committeeRepresentatives;
  final List<Representative> sppRepresentatives;
  final UniqueKey? widgetKey;
  final Map<UniqueKey, List<OrganisationUser>> usersForSelects;
  final String? selectedOtherOrg;
  final String? otherFieldFio;
  final String? otherFieldPhone;
  final String? otherFieldPosition;
  final bool isLoading;
  final bool? fetchingDependencies;
  final bool? fetchingSppDependencies;
  final bool? searchingOtherOrgs;
  final bool? isError;
  final bool? searchError;
  final bool fillFio;
  final bool fillPhone;
  final bool fillPosition;
  final String? searchErrorMessage;
  final String? errorMessage;
  final bool validationFailed;

  const ProtocolRepresentativesViewModel({
    required this.committeeList,
    required this.sppList,
    required this.committeeRepresentatives,
    required this.sppRepresentatives,
    required this.usersForSelects,
    this.widgetKey,
    required this.isLoading,
    this.selectedOtherOrg,
    this.otherFieldFio,
    this.otherFieldPhone,
    this.otherFieldPosition,
    this.fetchingDependencies,
    this.fetchingSppDependencies,
    this.isError,
    this.errorMessage,
    this.searchingOtherOrgs,
    required this.otherList,
    this.searchError,
    required this.fillFio,
    required this.fillPhone,
    required this.fillPosition,
    this.searchErrorMessage,
    required this.validationFailed,
  });

  factory ProtocolRepresentativesViewModel.initial() => ProtocolRepresentativesViewModel(
        committeeList: const [],
        sppList: const [],
        committeeRepresentatives: [Representative.generateDefault(type: OrganizationType.committee)],
        sppRepresentatives: [Representative.generateDefault(type: OrganizationType.spp)],
        usersForSelects: const {},
        selectedOtherOrg: null,
        otherFieldFio: null,
        otherFieldPhone: null,
        otherFieldPosition: null,
        isLoading: false,
        fetchingDependencies: false,
        fetchingSppDependencies: false,
        isError: false,
        errorMessage: '',
        otherList: const [],
        searchingOtherOrgs: false,
        searchError: false,
        searchErrorMessage: '',
        validationFailed: false,
        fillFio: false,
        fillPhone: false,
        fillPosition: false,
      );

  ProtocolRepresentativesViewModel copyWith({
    List<Organisation>? committeeList,
    List<Organisation>? sppList,
    List<Organisation>? otherList,
    List<Representative>? committeeRepresentatives,
    List<Representative>? sppRepresentatives,
    UniqueKey? widgetKey,
    Map<UniqueKey, List<OrganisationUser>>? usersForSelects,
    String? selectedOtherOrg,
    String? otherFieldFio,
    String? otherFieldPhone,
    String? otherFieldPosition,
    bool? isLoading,
    bool? fetchingDependencies,
    bool? fetchingSppDependencies,
    bool? searchingOtherOrgs,
    bool? isError,
    bool? searchError,
    bool? fillFio,
    bool? fillPhone,
    bool? fillPosition,
    String? errorMessage,
    String? searchErrorMessage,
    bool? validationFailed,
  }) =>
      ProtocolRepresentativesViewModel(
        committeeList: committeeList ?? this.committeeList,
        otherList: otherList ?? this.otherList,
        sppList: sppList ?? this.sppList,
        committeeRepresentatives: committeeRepresentatives ?? this.committeeRepresentatives,
        sppRepresentatives: sppRepresentatives ?? this.sppRepresentatives,
        widgetKey: widgetKey,
        usersForSelects: usersForSelects ?? this.usersForSelects,
        isLoading: isLoading ?? this.isLoading,
        fetchingDependencies: fetchingDependencies ?? this.fetchingDependencies,
        fetchingSppDependencies: fetchingSppDependencies ?? this.fetchingSppDependencies,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
        otherFieldFio: otherFieldFio ?? this.otherFieldFio,
        otherFieldPhone: otherFieldPhone ?? this.otherFieldPhone,
        otherFieldPosition: otherFieldPosition ?? this.otherFieldPosition,
        selectedOtherOrg: selectedOtherOrg,
        searchError: searchError ?? this.searchError,
        searchingOtherOrgs: searchingOtherOrgs ?? this.searchingOtherOrgs,
        searchErrorMessage: searchErrorMessage ?? this.searchErrorMessage,
        validationFailed: validationFailed ?? this.validationFailed,
        fillFio: fillFio ?? this.fillFio,
        fillPhone: fillPhone ?? this.fillPhone,
        fillPosition: fillPosition ?? this.fillPosition,
      );

  Map<String, List<OrganisationUser>> _convertKeysToString(Map<UniqueKey, List<OrganisationUser>> data) {
    Map<String, List<OrganisationUser>> convertedData = {};

    data.forEach((key, list) {
      convertedData[key.toString()] = list;
    });

    return convertedData;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolRepresentativesViewModel &&
          runtimeType == other.runtimeType &&
          listEquals(committeeList, other.committeeList) &&
          listEquals(sppList, other.sppList) &&
          listEquals(otherList, other.otherList) &&
          listEquals(committeeRepresentatives, other.committeeRepresentatives) &&
          listEquals(sppRepresentatives, other.sppRepresentatives) &&
          json.encode(_convertKeysToString(usersForSelects)) == json.encode(_convertKeysToString(other.usersForSelects)) &&
          isLoading == other.isLoading &&
          fetchingDependencies == other.fetchingDependencies &&
          fetchingSppDependencies == other.fetchingSppDependencies &&
          selectedOtherOrg == other.selectedOtherOrg &&
          otherFieldFio == other.otherFieldFio &&
          otherFieldPhone == other.otherFieldPhone &&
          otherFieldPosition == other.otherFieldPosition &&
          searchingOtherOrgs == other.searchingOtherOrgs &&
          isError == other.isError &&
          searchError == other.searchError &&
          searchErrorMessage == other.searchErrorMessage &&
          widgetKey == other.widgetKey &&
          fillFio == other.fillFio &&
          fillPhone == other.fillPhone &&
          fillPosition == other.fillPosition &&
          validationFailed == other.validationFailed &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      committeeList.hashCode ^
      sppList.hashCode ^
      otherList.hashCode ^
      committeeRepresentatives.hashCode ^
      sppRepresentatives.hashCode ^
      isLoading.hashCode ^
      fetchingDependencies.hashCode ^
      fetchingSppDependencies.hashCode ^
      isError.hashCode ^
      errorMessage.hashCode ^
      widgetKey.hashCode ^
      usersForSelects.hashCode ^
      selectedOtherOrg.hashCode ^
      otherFieldFio.hashCode ^
      otherFieldPhone.hashCode ^
      otherFieldPosition.hashCode ^
      searchingOtherOrgs.hashCode ^
      searchError.hashCode ^
      validationFailed.hashCode ^
      fillFio.hashCode ^
      fillPhone.hashCode ^
      fillPosition.hashCode ^
      searchErrorMessage.hashCode;
}
