import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/action_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/green_space_state.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/ogs_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/repository_module.dart';

class LocalDataUseCase {
  List<SelectObject> getObjectKindSelect({required int gsType}) {
    try {
      List<SelectObject> sortedTypes = [];
      final List<OgsType> ogsTypes = RepositoryModule.localRepository().getObjectKindSelect();

      if (ogsTypes.isNotEmpty) {
        for (OgsType element in ogsTypes) {
          if (element.elementTypeId == gsType) {
            sortedTypes.add(SelectObject(id: element.id.toString(), title: element.title));
          }
        }
      }

      return sortedTypes;
    } catch (_) {
      rethrow;
    }
  }

  List<SelectObject> getObjectStateSelect({required int gsType, required int workCategory}) {
    try {
      List<SelectObject> filteredStates = [];
      final List<GreenSpaceState> statesList = RepositoryModule.localRepository().getObjectStateSelect();

      if (statesList.isNotEmpty) {
        for (GreenSpaceState state in statesList) {
          if (state.workCatIds == null || state.workCatIds!.contains(workCategory)) {
            if (state.elementTypeIds.contains(gsType)) {
              filteredStates.add(SelectObject(id: state.id.toString(), title: state.title));
            }
          }
        }
      }

      return filteredStates;
    } catch (_) {
      rethrow;
    }
  }

  List<SelectObject> getWorkTypeSelect({required int gsType}) {
    try {
      final List<SelectObject> sortedActionTypes = [];
      final List<ActionType> actionTypes = RepositoryModule.localRepository().getActionType();

      if (actionTypes.isNotEmpty) {
        for (ActionType element in actionTypes) {
          if (element.elementTypeId == gsType) {
            sortedActionTypes.add(SelectObject(id: element.id.toString(), title: element.title));
          }
        }
      }

      return sortedActionTypes;
    } catch (_) {
      rethrow;
    }
  }

  List<SelectObject> getDiameters() {
    try {
      return RepositoryModule.localRepository().getDiameters();
      // return RepositoryModule.protocolRepository()
    } catch (_) {
      rethrow;
    }
  }

  List<SelectObject> getAges() {
    try {
      return RepositoryModule.localRepository().getAges();
    } catch (_) {
      rethrow;
    }
  }

  List<SelectObject> getFellingTypes() {
    try {
      final List<SelectObject> protocolsData = RepositoryModule.localRepository().getFellingTypes();

      return protocolsData;
    } catch (_) {
      rethrow;
    }
  }

  List<SelectObject> getLocalDistricts() {
    try {
      final List<SelectObject> data = RepositoryModule.localRepository().getLocalDistricts();

      return data;
    } catch (_) {
      rethrow;
    }
  }

    List<Municipality> getLocalMunicipalities({required int districtId}) {
    try {
      final List<Municipality> data = RepositoryModule.localRepository().getLocalMunicipalities(districtId: districtId);

      return data;
    } catch (_) {
      rethrow;
    }
  }

  List<AreaType> getProtocolTerritory() {
    try {
      final List<AreaType> protocolsData = RepositoryModule.localRepository().getProtocolTerritories();

      return protocolsData;
    } catch (_) {
      rethrow;
    }
  }

  List<ElementType> getElementTypes({required int selectedWorkCat}) {
    try {
      List<ElementType> list = [];
      final List<ElementType> allTypes = RepositoryModule.localRepository().getElementTypes();

      if (allTypes.isNotEmpty) {
        for (ElementType element in allTypes) {
          if (element.workCatIds.contains(selectedWorkCat)) {
            list.add(element);
          }
        }
      }

      return list;
    } catch (_) {
      rethrow;
    }
  }

  Map<OrganizationType, List<Organisation>> getOrgsByType() {
    final List<Organisation> orgs = RepositoryModule.localRepository().getOrgsAndUsers();
    Map<OrganizationType, List<Organisation>> mappedResult = {OrganizationType.committee: [], OrganizationType.spp: []};

    for (Organisation item in orgs) {
      if (item.type == OrganizationType.committee) {
        mappedResult[OrganizationType.committee]!.add(item);
      } else {
        mappedResult[OrganizationType.spp]!.add(item);
      }
    }

    return mappedResult;
  }

  List<OrganisationUser> getCommiteeUsersSelect({required int orgId, required List<Organisation> orgs}) {
    for (Organisation item in orgs) {
      if (item.id == orgId) {
        return item.members;
      }
    }
    return [];
  }
}
