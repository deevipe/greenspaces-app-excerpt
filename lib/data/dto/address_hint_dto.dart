// Package imports:
import 'package:latlong2/latlong.dart';

class AddressHintDTO {
  final String value;
  final LatLng? coordinates;

  AddressHintDTO({required this.value, required this.coordinates});

  factory AddressHintDTO.fromJson(Map<String, dynamic> json) => AddressHintDTO(
        value: json['value'],
        coordinates: (json['data']['geo_lat'] != null && json['data']['geo_lon'] != null)
            ? LatLng(
                double.parse(json['data']['geo_lat']),
                double.parse(json['data']['geo_lon']),
              )
            : null,
      );
}
