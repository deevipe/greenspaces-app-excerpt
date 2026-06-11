import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_condition.dart';

@immutable
class ProtocolWorkConditionViewModel {
  final List<WorkCondition> conditions;
  final bool isLoading;
  final List<int> selectedCondition;
  final String? otherName;
  final bool? isError;
  final String? errorMessage;

  const ProtocolWorkConditionViewModel({
    required this.conditions,
    required this.selectedCondition,
    required this.isLoading,
    this.isError,
    this.errorMessage,
    this.otherName,
  });

  factory ProtocolWorkConditionViewModel.initial() =>
      const ProtocolWorkConditionViewModel(conditions: [], selectedCondition: [], otherName: null, isLoading: false, isError: false, errorMessage: '');

  ProtocolWorkConditionViewModel copyWith({
    required List<int> selectedCondition,
    List<WorkCondition>? conditions,
    final String? otherName,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
  }) =>
      ProtocolWorkConditionViewModel(
        conditions: conditions ?? this.conditions,
        selectedCondition: selectedCondition,
        otherName: otherName ?? this.otherName,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolWorkConditionViewModel &&
          runtimeType == other.runtimeType &&
          listEquals(conditions, other.conditions) &&
          listEquals(selectedCondition, other.selectedCondition) &&
          isLoading == other.isLoading &&
          isError == other.isError &&
          errorMessage == other.errorMessage &&
          otherName == other.otherName;

  @override
  int get hashCode => conditions.hashCode ^ otherName.hashCode ^ selectedCondition.hashCode ^ isLoading.hashCode ^ isError.hashCode ^ errorMessage.hashCode;
}
