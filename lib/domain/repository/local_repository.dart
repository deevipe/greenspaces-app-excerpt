import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/action_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/green_space_state.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/ogs_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';

abstract class LocalRepository {
  List<OgsType> getObjectKindSelect();
  List<ActionType> getActionType();
  List<GreenSpaceState> getObjectStateSelect();
  List<AreaType> getProtocolTerritories();
  List<SelectObject> getDiameters();
  List<SelectObject> getAges();
  List<SelectObject> getFellingTypes();
  List<SelectObject> getLocalDistricts();
  List<Municipality> getLocalMunicipalities({required int districtId});
  List<ElementType> getElementTypes();
  List<Organisation> getOrgsAndUsers();
}
