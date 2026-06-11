import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/stem_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/save_draft_redirect.dart';

@immutable
class ProtocolObjectViewModel {
  final int? savedAreaId;
  final int? elementId; // id of element in areaList "Elements" array
  final ElementType? type;
  final List<SelectObject> kind;
  final List<SelectObject> workType;
  final List<SelectObject> workSubType;
  final List<SelectObject> objectState;
  final List<SelectObject> diameters;
  final List<SelectObject> ages;
  final int objectIndex;
  final List<GreenSpaceObject> savedItems;
  final String? selectedKind;
  final String? selectedWorkType;
  final String? selectedWorkSubType;
  final String? selectedObjectState;
  final String? selectedDiameter;
  final String? otherStateValue;
  final String? selectedAge;
  final String? areaValue;
  final String? amountValue;
  final String? stemAmount;
  final List<Stem> stemList;
  final bool multiStem;
  final bool copy;
  final bool isLoading;
  final bool fetchingWorkSubType;
  final bool? processingDraft;
  final DraftRedirect? redirectOption;
  final bool? isError;
  final String? errorMessage;

  const ProtocolObjectViewModel({
    this.savedAreaId,
    this.elementId,
    required this.type,
    required this.kind,
    required this.workType,
    required this.workSubType,
    required this.objectState,
    required this.diameters,
    required this.ages,
    required this.objectIndex,
    required this.savedItems,
    this.selectedKind,
    this.selectedWorkType,
    this.selectedWorkSubType,
    this.selectedObjectState,
    this.otherStateValue,
    this.selectedDiameter,
    this.selectedAge,
    this.areaValue,
    this.amountValue,
    this.stemAmount,
    required this.copy,
    required this.stemList,
    required this.multiStem,
    required this.isLoading,
    required this.fetchingWorkSubType,
    this.processingDraft,
    this.redirectOption,
    this.isError,
    this.errorMessage,
  });

  factory ProtocolObjectViewModel.initial() => const ProtocolObjectViewModel(
        type: null,
        kind: [],
        workType: [],
        workSubType: [],
        diameters: [],
        ages: [],
        objectState: [],
        objectIndex: 0,
        savedItems: [],
        isLoading: false,
        fetchingWorkSubType: false,
        isError: false,
        errorMessage: '',
        multiStem: false,
        selectedDiameter: null,
        stemList: [],
        processingDraft: false,
        redirectOption: DraftRedirect.none,
        copy: false,
      );

  ProtocolObjectViewModel copyWith({
    int? savedAreaId,
    int? elementId,
    ElementType? type,
    List<SelectObject>? kind,
    List<SelectObject>? workType,
    List<SelectObject>? workSubType,
    List<SelectObject>? objectState,
    List<SelectObject>? diameters,
    List<SelectObject>? ages,
    int? objectIndex,
    List<GreenSpaceObject>? savedItems,
    String? selectedKind,
    String? selectedWorkType,
    String? selectedWorkSubType,
    String? selectedObjectState,
    String? otherStateValue,
    String? selectedDiameter,
    String? selectedAge,
    String? areaValue,
    String? amountValue,
    String? stemAmount,
    List<Stem>? stemList,
    bool? copy,
    bool? multiStem,
    bool? isLoading,
    bool? fetchingWorkSubType,
    bool? processingDraft,
    DraftRedirect? redirectOption,
    bool? isError,
    String? errorMessage,
  }) =>
      ProtocolObjectViewModel(
        savedAreaId: savedAreaId ?? this.savedAreaId,
        elementId: elementId ?? this.elementId,
        type: type ?? this.type,
        kind: kind ?? this.kind,
        workType: workType ?? this.workType,
        workSubType: workSubType ?? this.workSubType,
        diameters: diameters ?? this.diameters,
        ages: ages ?? this.ages,
        objectState: objectState ?? this.objectState,
        objectIndex: objectIndex ?? this.objectIndex,
        savedItems: savedItems ?? this.savedItems,
        selectedKind: selectedKind,
        selectedWorkType: selectedWorkType,
        selectedWorkSubType: selectedWorkSubType,
        selectedObjectState: selectedObjectState,
        selectedDiameter: selectedDiameter,
        otherStateValue: otherStateValue,
        selectedAge: selectedAge,
        areaValue: areaValue,
        amountValue: amountValue,
        stemAmount: stemAmount,
        stemList: stemList ?? this.stemList,
        copy: copy ?? this.copy,
        multiStem: multiStem ?? this.multiStem,
        isLoading: isLoading ?? this.isLoading,
        fetchingWorkSubType: fetchingWorkSubType ?? this.fetchingWorkSubType,
        processingDraft: processingDraft ?? this.processingDraft,
        redirectOption: redirectOption ?? this.redirectOption,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolObjectViewModel &&
          runtimeType == other.runtimeType &&
          savedAreaId == other.savedAreaId &&
          elementId == other.elementId &&
          type == other.type &&
          listEquals(kind, other.kind) &&
          listEquals(workType, other.workType) &&
          listEquals(workSubType, other.workSubType) &&
          listEquals(objectState, other.objectState) &&
          listEquals(diameters, other.diameters) &&
          listEquals(ages, other.ages) &&
          listEquals(savedItems, other.savedItems) &&
          selectedKind == other.selectedKind &&
          selectedWorkType == other.selectedWorkType &&
          selectedWorkSubType == other.selectedWorkSubType &&
          selectedObjectState == other.selectedObjectState &&
          otherStateValue == other.otherStateValue &&
          selectedDiameter == other.selectedDiameter &&
          selectedAge == other.selectedAge &&
          areaValue == other.areaValue &&
          amountValue == other.amountValue &&
          stemAmount == other.stemAmount &&
          copy == other.copy &&
          listEquals(stemList, other.stemList) &&
          multiStem == other.multiStem &&
          isLoading == other.isLoading &&
          fetchingWorkSubType == other.fetchingWorkSubType &&
          isError == other.isError &&
          processingDraft == other.processingDraft &&
          redirectOption == other.redirectOption &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      savedAreaId.hashCode ^
      elementId.hashCode ^
      type.hashCode ^
      kind.hashCode ^
      workType.hashCode ^
      workSubType.hashCode ^
      objectState.hashCode ^
      diameters.hashCode ^
      ages.hashCode ^
      savedItems.hashCode ^
      selectedKind.hashCode ^
      selectedWorkType.hashCode ^
      selectedWorkSubType.hashCode ^
      selectedObjectState.hashCode ^
      otherStateValue.hashCode ^
      selectedDiameter.hashCode ^
      selectedAge.hashCode ^
      areaValue.hashCode ^
      amountValue.hashCode ^
      copy.hashCode ^
      stemAmount.hashCode ^
      stemList.hashCode ^
      multiStem.hashCode ^
      isLoading.hashCode ^
      fetchingWorkSubType.hashCode ^
      processingDraft.hashCode ^
      redirectOption.hashCode ^
      isError.hashCode ^
      errorMessage.hashCode;
}
