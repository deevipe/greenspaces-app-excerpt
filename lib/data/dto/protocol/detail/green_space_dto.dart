import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/green_space_item_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/ogs_dto.dart';

class GreenSpaceObjectDTO {
  final int id;
  final OgsDTO? ogs;
  final int? territoryType;
  final String? address;
  final List<GreenSpaceObjectItemDTO> items;

  GreenSpaceObjectDTO({
    required this.id,
    this.ogs,
    this.territoryType,
    this.address,
    required this.items,
  });

  factory GreenSpaceObjectDTO.fromJson(Map<String, dynamic> json) => GreenSpaceObjectDTO(
        id: json['Id'],
        ogs: OgsDTO.fromJson(json['Ogs']),
        territoryType: json['AreaTypes'] != null && json['AreaTypes'].isNotEmpty ? json['AreaTypes'].first['Id'] : null,
        address: json['Address'],
        items: json['Elements'].map((element) => GreenSpaceObjectItemDTO.fromJson(element)).toList().cast<GreenSpaceObjectItemDTO>(),
      );
}
