import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_category.dart';

@immutable
class ProtocolWorkCategoryViewModel {
  final List<WorkCategory> categories;
  final bool isLoading;
  final int? selectedCategory;
  final bool? isError;
  final String? errorMessage;

  const ProtocolWorkCategoryViewModel({
    required this.categories,
    required this.isLoading,
    this.isError,
    this.errorMessage,
    this.selectedCategory,
  });

  factory ProtocolWorkCategoryViewModel.initial() => const ProtocolWorkCategoryViewModel(categories: [], isLoading: false, isError: false, errorMessage: '');

  ProtocolWorkCategoryViewModel copyWith({
    int? selectedCategory,
    List<WorkCategory>? categories,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
  }) =>
      ProtocolWorkCategoryViewModel(
        categories: categories ?? this.categories,
        selectedCategory: selectedCategory,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolWorkCategoryViewModel &&
          runtimeType == other.runtimeType &&
          selectedCategory == other.selectedCategory &&
          listEquals(categories, other.categories) &&
          isLoading == other.isLoading &&
          isError == other.isError &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => categories.hashCode ^ selectedCategory.hashCode ^ isLoading.hashCode ^ isError.hashCode ^ errorMessage.hashCode;
}
