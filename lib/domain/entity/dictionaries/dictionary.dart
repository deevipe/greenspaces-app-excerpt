import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/action_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/green_space_state.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/ogs_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';

class Dictionary {
  final List<ActionType> actionTypes;
  final List<ElementType> elementTypes;
  final List<GreenSpaceState> greenSpaceStates;
  final List<OgsType> ogsTypes;
  final List<SelectObject> diameters;
  final List<SelectObject> ages;
  final List<AreaType> areaTypes;
  final List<SelectObject> workMethods;

  Dictionary({
    required this.actionTypes,
    required this.elementTypes,
    required this.greenSpaceStates,
    required this.ogsTypes,
    required this.diameters,
    required this.ages,
    required this.areaTypes,
    required this.workMethods,
  });
}
