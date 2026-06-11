import 'package:gisogs_greenspacesapp/data/dto/dictionaries/dictionary_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/ogs_type_dto.dart';
import 'package:gisogs_greenspacesapp/data/mapper/dictionaries/area_type_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/action_type_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/element_type_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/green_space_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/ogs_type_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/select_object_mapper.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/action_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/dictionary.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/green_space_state.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/ogs_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';

class DictionaryMapper {
  static Dictionary mapDTO(DictionaryDTO data) => Dictionary(
        actionTypes: data.actionTypes.map((data) => ActionTypeMapper.mapDTO(data)).toList().cast<ActionType>(),
        elementTypes: data.elementTypes.map((data) => ElementTypeMapper.mapDTO(data)).toList().cast<ElementType>(),
        greenSpaceStates: data.greenSpaceStates.map((data) => GreenSpaceStateMapper.mapDTO(data)).toList().cast<GreenSpaceState>(),
        ogsTypes: _mapOgsTypes(data.ogsTypes),
        areaTypes: data.areaTypes.map((data) => AreaTypeMapper.mapDTO(data)).toList().cast<AreaType>(),
        workMethods: data.workMethods.map((data) => SelectObjectMapper.mapDTO(data)).toList().cast<SelectObject>(),
        ages: data.ages.map((data) => SelectObjectMapper.mapDTO(data)).toList().cast<SelectObject>(),
        diameters: data.diameters.map((data) => SelectObjectMapper.mapDTO(data)).toList().cast<SelectObject>(),
      );

  static List<OgsType> _mapOgsTypes(List<OgsTypeDTO> data) {
    int id = 1;
    List<OgsType> result = [];
    for (var item in data) {
      result.add(OgsTypeMapper.mapDTO(item, id));
      id++;
    }

    return result;
  }
}
