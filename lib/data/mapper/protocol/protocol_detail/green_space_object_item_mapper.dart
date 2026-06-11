import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/green_space_item_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object_item.dart';

class GreenSpaceObjectItemMapper {
  static GreenSpaceObjectItem mapDTO(GreenSpaceObjectItemDTO data, List<ElementType> elementTypes) => GreenSpaceObjectItem(
        id: data.id,
        typeId: data.typeId,
        type: _getElementType(id: data.typeId, elementTypes: elementTypes),
        multiStem: data.multiStem,
        selectedKind: data.selectedKind,
        selectedWorkType: data.selectedWorkType,
        selectedWorkSubType: data.selectedWorkSubType,
        selectedObjectState: data.selectedObjectState,
        selectedDiameter: data.selectedDiameter,
        otherStateValue: data.otherStateValue,
        selectedAge: data.selectedAge,
        areaValue: data.areaValue?.toString(),
        amountValue: data.amountValue != null ? '${data.amountValue}' : null,
        stemAmount: null,
        pictures: [],
        stemList: [],
      );

  static ElementType? _getElementType({required int id, required List<ElementType> elementTypes}) {
    ElementType? typeRes;
    for (var type in elementTypes) {
      if (type.id == id) {
        typeRes = type;
      }
    }

    return typeRes;
  }
}
