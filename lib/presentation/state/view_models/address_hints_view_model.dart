// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/domain/entity/address_hint_entity.dart';

@immutable
class AddressHintsViewModel {
  final String? query;
  final List<AddressHint> suggestions;
  final bool toggled;
  final bool? isLoading;
  final bool? isError;
  final String? errorMessage;

  const AddressHintsViewModel({
    this.query,
    required this.suggestions,
    required this.toggled,
    this.isLoading,
    this.isError,
    this.errorMessage,
  });

  AddressHintsViewModel copyWith({
    String? query,
    List<AddressHint>? suggestions,
    bool? toggled,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
  }) =>
      AddressHintsViewModel(
        query: query ?? this.query,
        suggestions: suggestions ?? this.suggestions,
        toggled: toggled ?? this.toggled,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  factory AddressHintsViewModel.initial() => const AddressHintsViewModel(
        suggestions: [],
        toggled: false,
        isLoading: false,
        isError: false,
        errorMessage: '',
      );
}
