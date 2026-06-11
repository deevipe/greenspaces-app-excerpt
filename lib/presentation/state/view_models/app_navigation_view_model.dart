import 'package:flutter/foundation.dart';

@immutable
class AppNavigationViewModel {
  final bool formIsOpen;

  const AppNavigationViewModel({required this.formIsOpen});

  factory AppNavigationViewModel.initial() => const AppNavigationViewModel(formIsOpen: false);

  AppNavigationViewModel copyWith({
    bool? formIsOpen,
  }) =>
      AppNavigationViewModel(formIsOpen: formIsOpen ?? this.formIsOpen);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNavigationViewModel && runtimeType == other.runtimeType && formIsOpen == other.formIsOpen;

  @override
  int get hashCode => formIsOpen.hashCode;
}
