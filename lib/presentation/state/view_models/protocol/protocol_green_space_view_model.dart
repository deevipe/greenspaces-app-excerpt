import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';

@immutable
class ProtocolGreenSpaceViewModel {
  final List<ElementType> availableList;
  final ElementType? selectedGreenSpace;
  final bool isLoading;
  final bool? isError;
  final String? errorMessage;
  const ProtocolGreenSpaceViewModel({
    required this.availableList,
    this.selectedGreenSpace,
    required this.isLoading,
    this.isError,
    this.errorMessage,
  });

  factory ProtocolGreenSpaceViewModel.initial() =>
      const ProtocolGreenSpaceViewModel(availableList: [], selectedGreenSpace: null, isLoading: false, isError: false, errorMessage: '');

  ProtocolGreenSpaceViewModel copyWith({
    List<ElementType>? availableList,
    ElementType? selectedGreenSpace,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
  }) => ProtocolGreenSpaceViewModel(
    availableList: availableList ?? this.availableList,
    selectedGreenSpace: selectedGreenSpace,
    isLoading: isLoading ?? this.isLoading,
    isError: isError ?? this.isError,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProtocolGreenSpaceViewModel && runtimeType == other.runtimeType && listEquals(availableList, other.availableList) && selectedGreenSpace == other.selectedGreenSpace && isLoading == other.isLoading && isError == other.isError && errorMessage == other.errorMessage;

  @override
  int get hashCode => availableList.hashCode ^ selectedGreenSpace.hashCode ^ isLoading.hashCode ^ isError.hashCode ^ errorMessage.hashCode;
}
