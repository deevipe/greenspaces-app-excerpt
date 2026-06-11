import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/ogs_entity.dart';

@immutable
class ProtocolTerritoryViewModel {
  final String address;
  final List<AreaType> list;
  final Ogs? ogs;
  final int? selectedType;
  final String typeUrl;
  final bool isLoading;
  final bool? isError;
  final String? errorMessage;

  const ProtocolTerritoryViewModel({
    this.selectedType,
    this.ogs,
    required this.typeUrl,
    required this.address,
    required this.isLoading,
    required this.list,
    this.isError,
    this.errorMessage,
  });

  factory ProtocolTerritoryViewModel.initial() =>
      const ProtocolTerritoryViewModel(isLoading: false, errorMessage: '', isError: false, selectedType: null, address: '', list: [], typeUrl: '');

  ProtocolTerritoryViewModel copyWith({
    String? address,
    String? typeUrl,
    Ogs? ogs,
    int? selectedType,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<AreaType>? list,
  }) =>
      ProtocolTerritoryViewModel(
        address: address ?? this.address,
        ogs: ogs,
        typeUrl: typeUrl ?? this.typeUrl,
        isLoading: isLoading ?? this.isLoading,
        selectedType: selectedType,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
        list: list ?? this.list,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolTerritoryViewModel &&
          runtimeType == other.runtimeType &&
          listEquals(list, other.list) &&
          selectedType == other.selectedType &&
          address == other.address &&
          typeUrl == other.typeUrl &&
          isLoading == other.isLoading &&
          isError == other.isError &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => selectedType.hashCode ^ address.hashCode ^ isLoading.hashCode ^ isError.hashCode ^ errorMessage.hashCode ^ typeUrl.hashCode;
}
