// Flutter imports:
import 'package:flutter/foundation.dart';

enum EsriGeometryType {
  point,
  polyline,
  polygon,
}

extension LayerGeometryType on EsriGeometryType {
  String get name => describeEnum(this);
}
