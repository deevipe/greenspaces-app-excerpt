import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/green_space_dto.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_detail/green_space_object_item_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_detail/ogs_mapper.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object_item.dart';

class GreenSpaceObjectMapper {
  static GreenSpaceObject mapDTO(GreenSpaceObjectDTO data, List<ElementType> elementTypes) => GreenSpaceObject(
        id: data.id,
        ogs: OgsMapper.mapDTO(data.ogs),
        territoryTypeId: data.territoryType,
        territoryType: GreenSpaceObject.getTerritoryType(data.territoryType),
        address: data.address ?? '',
        items: data.items.map((item) => GreenSpaceObjectItemMapper.mapDTO(item, elementTypes)).toList().cast<GreenSpaceObjectItem>(),
      );
}
