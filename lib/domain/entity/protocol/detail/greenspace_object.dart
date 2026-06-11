import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object_item.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/ogs_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/protocol_territory.dart';

class GreenSpaceObject {
  final int? id;
  final Ogs? ogs;
  final ProtocolTerritoryType? territoryType;
  final int? territoryTypeId;
  final String address;
  final List<GreenSpaceObjectItem> items;

  GreenSpaceObject({
    this.id,
    this.ogs,
    this.territoryTypeId,
    this.territoryType,
    required this.address,
    required this.items,
  });

  GreenSpaceObject copyWith({
    required List<GreenSpaceObjectItem> newItems,
    int? id,
    Ogs? ogs,
    ProtocolTerritoryType? territoryType,
    int? territoryTypeId,
  }) =>
      GreenSpaceObject(
        id: id ?? this.id,
        ogs: ogs ?? this.ogs,
        territoryTypeId: territoryTypeId ?? this.territoryTypeId,
        territoryType: territoryType ?? this.territoryType,
        address: address,
        items: newItems,
      );

  // Свитчер по id приходящим с сервера
  static ProtocolTerritoryType? getTerritoryType(int? typeId) {
    switch (typeId) {
      case 1:
        return ProtocolTerritoryType.znopGz;
      case 2:
        return ProtocolTerritoryType.znopRo;
      case 3:
        return ProtocolTerritoryType.znopMz;
      case 4:
        return ProtocolTerritoryType.znStreetSpecial;
      case 5:
        return ProtocolTerritoryType.znLimited;
      case 6:
        return ProtocolTerritoryType.znUnlimited;
      case 7:
        return ProtocolTerritoryType.znSpecial;
      default:
        return null;
    }
  }
}
