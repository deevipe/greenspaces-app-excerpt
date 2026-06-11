import 'package:gisogs_greenspacesapp/data/api/api_util.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/action_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/green_space_state.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/ogs_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/repository/local_repository.dart';

class LocalDataRepository extends LocalRepository {
  final ApiUtil _apiUtil;

  LocalDataRepository(this._apiUtil);

  @override
  List<OgsType> getObjectKindSelect() {
    return _apiUtil.getObjectKindSelect();
  }

  @override
  List<ActionType> getActionType() {
    return _apiUtil.getActionType();
  }

  @override
  List<GreenSpaceState> getObjectStateSelect() {
    return _apiUtil.getGreenSpaceStates();
  }

  @override
  List<AreaType> getProtocolTerritories() {
    return _apiUtil.getProtocolTerritory();
  }

  @override
  List<ElementType> getElementTypes() {
    return _apiUtil.getElementTypes();
  }

  @override
  List<SelectObject> getAges() {
    return _apiUtil.getAges();
  }

  @override
  List<SelectObject> getDiameters() {
    return _apiUtil.getDiameters();
  }

  @override
  List<SelectObject> getFellingTypes() {
    return _apiUtil.getFellingTypes();
  }

  @override
  List<Organisation> getOrgsAndUsers() {
    return _apiUtil.getOrgs();
  }

  @override
  List<SelectObject> getLocalDistricts() {
    return _apiUtil.getLocalDistricts();
  }

  @override
  List<Municipality> getLocalMunicipalities({required int districtId}) {
    final List<Municipality> fullList = _apiUtil.getLocalMunicipalities();
    List<Municipality> sortedList = [];
    for (Municipality element in fullList) {
      if (element.districtId == districtId) {
        sortedList.add(element);
      }
    }

    return sortedList;
  }
}
