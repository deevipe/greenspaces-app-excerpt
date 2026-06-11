import 'package:flutter/foundation.dart';

enum UploadEntityType {
  protocol,
  work,
}

extension UploadEntityTypeExtension on UploadEntityType {
  String get name => describeEnum(this);

  // По значению возвращаем id для фильтра entity_state_id
  int get getApiId {
    switch (this) {
      case UploadEntityType.protocol:
        return 17;
      case UploadEntityType.work:
        return 18;
    }
  }
}
