import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';

@immutable
class UserViewModel {
  final User user;
  final bool isLoading;
  final bool? isError;
  final String? errorMessage;

  const UserViewModel({
    required this.user,
    required this.isLoading,
    this.isError,
    this.errorMessage,
  });

  factory UserViewModel.initial() {
    return UserViewModel(
      user: User.initial(),
      isLoading: false,
    );
  }

  UserViewModel copyWith({
    required User user,
    required bool isLoading,
    bool? isError,
    String? errorMessage,
  }) {
    return UserViewModel(
      user: user,
      isLoading: isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserViewModel &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          isLoading == other.isLoading &&
          isError == other.isError &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => user.hashCode ^ isLoading.hashCode ^ isError.hashCode ^ errorMessage.hashCode;
}
