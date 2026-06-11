import 'package:flutter/foundation.dart';

enum AllowedImageTypes {
  jpg,
  jpeg,
  png,
  svg
}

extension AllowedImageTypeExtension on AllowedImageTypes {
  String get name => describeEnum(this);
}
