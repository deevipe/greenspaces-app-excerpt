import 'package:flutter/foundation.dart';

enum ProtocolStatus {
  draft,
  approval,
  approved,
  returned,
}

extension ProtocolStatusExtension on ProtocolStatus {
  String get name => describeEnum(this);

  // По значению возвращаем id для фильтра entity_state_id
  int? get getApiId {
    switch (this) {
      case ProtocolStatus.draft:
        return 1;
      case ProtocolStatus.approval:
        return 2;
      case ProtocolStatus.returned:
        return 3;
      case ProtocolStatus.approved:
        return 4;
      default:
        return null;
    }
  }
}
