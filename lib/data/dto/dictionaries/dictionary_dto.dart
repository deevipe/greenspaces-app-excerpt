import 'package:gisogs_greenspacesapp/data/dto/dictionaries/action_type_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/area_type_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/element_type_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/green_space_state_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/ogs_type_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/select_object_dto.dart';

class DictionaryDTO {
  final List<ActionTypeDTO> actionTypes;
  final List<ElementTypeDTO> elementTypes;
  final List<GreenSpaceStateDTO> greenSpaceStates;
  final List<OgsTypeDTO> ogsTypes;
  final List<AreaTypeDTO> areaTypes;
  final List<SelectObjectDTO> ages;
  final List<SelectObjectDTO> diameters;
  final List<SelectObjectDTO> workMethods;

  DictionaryDTO({
    required this.actionTypes,
    required this.elementTypes,
    required this.greenSpaceStates,
    required this.ogsTypes,
    required this.areaTypes,
    required this.workMethods,
    required this.ages,
    required this.diameters,
  });

  factory DictionaryDTO.initial() => DictionaryDTO(
        actionTypes: [],
        elementTypes: [],
        greenSpaceStates: [],
        ogsTypes: [],
        areaTypes: [],
        workMethods: [],
        ages: [],
        diameters: []
      );
}
