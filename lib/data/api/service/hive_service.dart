// Package imports:
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/action_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/dictionary.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/green_space_state.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/ogs_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';

class HiveService {
  static late Box user;
  static late Box actionTypes;
  static late Box elementTypes;
  static late Box greenSpaceStates;
  static late Box ogsTypes;
  static late Box diameters;
  static late Box ages;
  static late Box areaTypes;
  static late Box fellingMethods;
  static late Box districts;
  static late Box municipalities;

  static late Box organisations;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ActionTypeAdapter());
    Hive.registerAdapter(ElementTypeAdapter());
    Hive.registerAdapter(GreenSpaceStateAdapter());
    Hive.registerAdapter(OgsTypeAdapter());
    Hive.registerAdapter(SelectObjectAdapter());
    Hive.registerAdapter(OrganisationUserAdapter());
    Hive.registerAdapter(OrganizationTypeAdapter());
    Hive.registerAdapter(OrganisationAdapter());
    Hive.registerAdapter(MunicipalityAdapter());
    Hive.registerAdapter(AreaTypeAdapter());

    user = await Hive.openBox<User>('users');
    actionTypes = await Hive.openBox<ActionType>('actionType');
    elementTypes = await Hive.openBox<ElementType>('elementType');
    greenSpaceStates = await Hive.openBox<GreenSpaceState>('greenSpaceState');
    ogsTypes = await Hive.openBox<OgsType>('ogsType');
    diameters = await Hive.openBox<SelectObject>('diameters');
    ages = await Hive.openBox<SelectObject>('ages');
    areaTypes = await Hive.openBox<AreaType>('areaTypes');
    fellingMethods = await Hive.openBox<SelectObject>('fellingMethods');
    organisations = await Hive.openBox<Organisation>('organisations');
    districts = await Hive.openBox<SelectObject>('districts');
    municipalities = await Hive.openBox<Municipality>('municipalities');
  }

  static Future<User?> getUserById({required int userId}) async {
    return await user.get(userId);
  }

  static Future<void> addUser({required User data}) async {
    // clear box first
    await user.clear();
    await user.put(data.id, data);
  }

  static Future<void> clearUser() async {
    await user.clear();
  }

  static Future<void> addDictionaries({required Dictionary data}) async {
    // Очистим все словари
    await actionTypes.clear();
    await elementTypes.clear();
    await greenSpaceStates.clear();
    await ogsTypes.clear();
    await diameters.clear();
    await ages.clear();
    await areaTypes.clear();
    await fellingMethods.clear();

    if (data.actionTypes.isNotEmpty) {
      actionTypes.addAll(data.actionTypes);
    }
    if (data.elementTypes.isNotEmpty) {
      elementTypes.addAll(data.elementTypes);
    }
    if (data.greenSpaceStates.isNotEmpty) {
      greenSpaceStates.addAll(data.greenSpaceStates);
    }
    if (data.ogsTypes.isNotEmpty) {
      ogsTypes.addAll(data.ogsTypes);
    }
    if (data.diameters.isNotEmpty) {
      diameters.addAll(data.diameters);
    }
    if (data.ages.isNotEmpty) {
      ages.addAll(data.ages);
    }
    if (data.areaTypes.isNotEmpty) {
      areaTypes.addAll(data.areaTypes);
    }
    if (data.workMethods.isNotEmpty) {
      fellingMethods.addAll(data.workMethods);
    }
  }

  static Future<void> addDistricts({required List<SelectObject> data}) async {
    await districts.clear();
    districts.addAll(data);
  }

  static Future<void> addMunicipalities({required List<Municipality> data}) async {
    await municipalities.clear();
    municipalities.addAll(data);
  }

  static List<AreaType> getTerritories() {
    return areaTypes.values.toList().cast<AreaType>();
  }

  static List<ElementType> getElementTypes() {
    return elementTypes.values.toList().cast<ElementType>();
  }

  static List<OgsType> getOgsTypes() {
    return ogsTypes.values.toList().cast<OgsType>();
  }

  static List<GreenSpaceState> getGreenSpaceStates() {
    return greenSpaceStates.values.toList().cast<GreenSpaceState>();
  }

  static List<ActionType> getActionType() {
    return actionTypes.values.toList().cast<ActionType>();
  }

  static List<SelectObject> getAges() {
    return ages.values.toList().cast<SelectObject>();
  }

  static List<SelectObject> getDiameters() {
    return diameters.values.toList().cast<SelectObject>();
  }

  static List<SelectObject> getFellingTypes() {
    return fellingMethods.values.toList().cast<SelectObject>();
  }

  static Future<void> addOrgsAndUsers({required List<Organisation> data}) async {
    // Очистим все словари
    await organisations.clear();

    organisations.addAll(data);
  }

  static List<Organisation> getOrgsAndUsers() {
    return organisations.values.toList().cast<Organisation>();
  }

  static List<SelectObject> getDistricts() {
    return districts.values.toList().cast<SelectObject>();
  }

  static List<Municipality> getMunicipalities() {
    return municipalities.values.toList().cast<Municipality>();
  }
}
