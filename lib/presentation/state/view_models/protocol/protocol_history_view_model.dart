import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_history.dart';

@immutable
class ProtocolHistoryViewModel {
  final List<ProtocolHistory> history;
  final bool isLoading;
  final bool? isError;
  final String? errorMessage;

  const ProtocolHistoryViewModel({
    required this.history,
    required this.isLoading,
    this.isError,
    this.errorMessage,
  });

  factory ProtocolHistoryViewModel.initial() => const ProtocolHistoryViewModel(history: [], isLoading: false, isError: false, errorMessage: '');

  ProtocolHistoryViewModel copyWith({
    List<ProtocolHistory>? history,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
  }) =>
      ProtocolHistoryViewModel(
        history: history ?? this.history,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolHistoryViewModel &&
          runtimeType == other.runtimeType &&
          listEquals(history, other.history) &&
          isLoading == other.isLoading &&
          isError == other.isError &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => history.hashCode ^ isLoading.hashCode ^ isError.hashCode ^ errorMessage.hashCode;
}
