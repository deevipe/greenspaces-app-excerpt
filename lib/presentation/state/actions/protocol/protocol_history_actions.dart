import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_history.dart';

class FetchingProtocolHistory {}

class FetchingProtocolHistorySuccess {
  final List<ProtocolHistory> list;

  FetchingProtocolHistorySuccess({
    required this.list,
  });
}

class ResetProtocolHistory {}

class ProtocolHistoryError {
  final String errorMessage;

  ProtocolHistoryError({
    required this.errorMessage,
  });
}
