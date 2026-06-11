import 'dart:async';
import 'dart:io';

import 'package:gisogs_greenspacesapp/data/api/request/custom_dictionary_body.dart';
import 'package:gisogs_greenspacesapp/data/api/request/default_body.dart';
import 'package:gisogs_greenspacesapp/data/api/request/login_body.dart';
import 'package:gisogs_greenspacesapp/data/api/request/protocol_detail_body.dart';
import 'package:gisogs_greenspacesapp/data/api/request/protocol_list_body.dart';
import 'package:gisogs_greenspacesapp/data/api/request/search_org_body.dart';
import 'package:gisogs_greenspacesapp/data/api/service/hive_service.dart';
import 'package:gisogs_greenspacesapp/data/api/service/protocol_service.dart';
import 'package:gisogs_greenspacesapp/data/api/service/user_service.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/dictionary_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/municipality_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/organisation_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/action_log_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/doc_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/green_space_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/protocol_entity_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/protocol_list_data_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/work_category_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/work_condition.dart';
import 'package:gisogs_greenspacesapp/data/dto/select_object_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/user_dto.dart';
import 'package:gisogs_greenspacesapp/data/mapper/dictionaries/dictionary_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/dictionaries/municipality_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/dictionaries/organisation_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_detail/action_log_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_detail/doc_item_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_detail/green_space_object_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_detail/protocol_detail_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_list_data_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/work_category_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/work_condition_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/select_object_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/user_mapper.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/login_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/action_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/green_space_state.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/ogs_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/protocol_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_history.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_data.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_category.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_condition.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';

class ApiUtil {
  final UserService _userService;
  final ProtocolService _protocolService;

  ApiUtil(this._userService, this._protocolService);

  Future<User?> auth({required final Login login}) async {
    final body = GetLoginBody(login: login);
    try {
      final UserDTO? result = await _userService.auth(body);
      if (result != null) {
        return UserMapper.mapDTO(result);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ProtocolListData> listProtocols({required String userTokenId, required bool revision, required int page}) async {
    final body = ProtocolListBody(userToken: userTokenId, count: 10, page: page);
    try {
      final ProtocolListDataDTO result = await _protocolService.listProtocols(body: body, entityStateId: revision == true ? 3 : 1);

      return ProtocolListDataMapper.mapDTO(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WorkCategory>> getWorkCategories({required String userTokenId}) async {
    final CustomDictionaryBody body = CustomDictionaryBody(dictionaryCode: 'Kategoriya_rabot', userTokenId: userTokenId);

    try {
      final List<WorkCategoryDTO> result = await _protocolService.getWorkCategories(body: body);

      return result.map((e) => WorkCategoryMapper.mapDTO(e)).toList().cast<WorkCategory>();
    } catch (_) {
      rethrow;
    }
  }

  Future<List<WorkCondition>> getWorkConditions({required String userTokenId}) async {
    final CustomDictionaryBody body = CustomDictionaryBody(dictionaryCode: 'FT_work_condition', userTokenId: userTokenId);

    try {
      final List<WorkConditionDTO> result = await _protocolService.getWorkConditions(body: body);

      return result.map((e) => WorkConditionMapper.mapDTO(e)).toList().cast<WorkCondition>();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getDictionaries({required String userTokenId}) async {
    final body = DefaultBody(userToken: userTokenId);
    try {
      final DictionaryDTO result = await _protocolService.getDictionaries(body);

      // если результат не пуст, то пройдемся по полученным результатам и сохраним их в локальное хранилище
      await HiveService.addDictionaries(data: DictionaryMapper.mapDTO(result));
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getOrgsAndUsers({required String userTokenId}) async {
    final body = DefaultBody(userToken: userTokenId);
    try {
      final List<OrganisationDTO> result = await _protocolService.getOrgsAndUsers(body: body);
      List<Organisation> mappedResult = [];

      if (result.isNotEmpty) {
        for (OrganisationDTO org in result) {
          mappedResult.add(OrganisationMapper.mapDTO(org));
        }

        await HiveService.addOrgsAndUsers(data: mappedResult);
      }
    } catch (_) {
      rethrow;
    }
  }

  List<OgsType> getObjectKindSelect() {
    try {
      return HiveService.getOgsTypes();
    } catch (_) {
      rethrow;
    }
  }

  List<ActionType> getActionType() {
    try {
      return HiveService.getActionType();
    } catch (_) {
      rethrow;
    }
  }

  List<GreenSpaceState> getGreenSpaceStates() {
    try {
      return HiveService.getGreenSpaceStates();
    } catch (_) {
      rethrow;
    }
  }

  List<AreaType> getProtocolTerritory() {
    try {
      return HiveService.getTerritories();
    } catch (_) {
      rethrow;
    }
  }

  List<ElementType> getElementTypes() {
    try {
      return HiveService.getElementTypes();
    } catch (_) {
      rethrow;
    }
  }

  List<SelectObject> getAges() {
    try {
      return HiveService.getAges();
    } catch (_) {
      rethrow;
    }
  }

  List<SelectObject> getDiameters() {
    try {
      return HiveService.getDiameters();
    } catch (_) {
      rethrow;
    }
  }

  List<SelectObject> getFellingTypes() {
    try {
      return HiveService.getFellingTypes();
    } catch (_) {
      rethrow;
    }
  }

  List<Organisation> getOrgs() {
    try {
      return HiveService.getOrgsAndUsers();
    } catch (_) {
      rethrow;
    }
  }

  Future<ProtocolEntity?> getProtocolDetail({required String userTokenId, required int protocolId}) async {
    final body = ProtocolDetailBody(id: protocolId, userToken: userTokenId);
    try {
      final ProtocolEntityDTO? protocolData = await _protocolService.getProtocolDetail(body: body);
      final List<ElementType> elementTypes = HiveService.getElementTypes();
      if (protocolData != null) {
        return ProtocolDetailMapper.mapDTO(protocolData, elementTypes);
      }
    } catch (_) {
      rethrow;
    }
    return null;
  }

  Future<List<Organisation>> searchOrgs({required String userTokenId, required String query}) async {
    final body = SearchOrgBody(query: query, userToken: userTokenId);
    try {
      final List<OrganisationDTO> orgsList = await _protocolService.searchOrgs(body: body);

      if (orgsList.isNotEmpty) {
        return orgsList.map((e) => OrganisationMapper.mapDTO(e)).toList().cast<Organisation>();
      }
    } catch (_) {
      rethrow;
    }
    return [];
  }

  Future<int?> saveProtocol({required String userTokenId, required Map<String, dynamic> rawData, required bool revision}) async {
    final body = DefaultBody(userToken: userTokenId);
    try {
      final int? result = await _protocolService.saveProtocol(body: body, rawData: rawData);
      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> saveAreaList({required String userTokenId, required Map<String, dynamic> rawData, required bool revision, required int protocolId}) async {
    final body = DefaultBody(userToken: userTokenId);
    try {
      return await _protocolService.saveAreaList(protocolId: protocolId, body: body, rawData: rawData);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getDistricts({required String userTokenId}) async {
    List<SelectObject> result = [];
    final body = DefaultBody(userToken: userTokenId);
    try {
      final List<SelectObjectDTO> selectList = await _protocolService.getDistrictsByUser(body: body);

      if (selectList.isNotEmpty) {
        result = selectList.map((element) => SelectObjectMapper.mapDTO(element)).toList().cast<SelectObject>();

        await HiveService.addDistricts(data: result);
      }
    } catch (_) {
      rethrow;
    }
  }

  List<SelectObject> getLocalDistricts() {
    try {
      return HiveService.getDistricts();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getMunicipalities({required String userTokenId}) async {
    List<Municipality> result = [];
    final body = DefaultBody(userToken: userTokenId);
    try {
      final List<MunicipalityDTO> dataList = await _protocolService.getMunicipalities(body: body);

      if (dataList.isNotEmpty) {
        result = dataList.map((element) => MunicipalityMapper.mapDTO(element)).toList().cast<Municipality>();

        await HiveService.addMunicipalities(data: result);
      }
    } catch (_) {
      rethrow;
    }
  }

  List<Municipality> getLocalMunicipalities() {
    try {
      return HiveService.getMunicipalities();
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> deleteProtocol({required String userTokenId, required int protocolId}) async {
    final body = DefaultBody(userToken: userTokenId);
    return await _protocolService.deleteProtocolById(body: body, protocolId: protocolId);
  }

  Future<Doc?> uploadFile({
    required String userTokenId,
    required int elementId,
    required File file,
    required StreamController<Map<String, int>> progressStreamController,
    required int entityTypeId,
    String? customFileName,
    required bool photo,
  }) async {
    final body = DefaultBody(userToken: userTokenId);
    try {
      final DocDTO? savedDocDTO = await _protocolService.uploadFile(
        body: body,
        elementId: elementId,
        file: file,
        progressStreamController: progressStreamController,
        entityTypeId: entityTypeId,
        photo: photo,
        customFileName: customFileName,
      );

      return savedDocDTO != null ? DocItemMapper.mapDTO(savedDocDTO) : null;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<GreenSpaceObject>> getAreaList({required String userTokenId, required int protocolId}) async {
    final body = DefaultBody(userToken: userTokenId);
    try {
      final List<GreenSpaceObjectDTO> areaList = await _protocolService.getAreaList(
        body: body,
        protocolId: protocolId,
      );
      final List<ElementType> elementTypes = HiveService.getElementTypes();
      return areaList.isNotEmpty ? areaList.map((item) => GreenSpaceObjectMapper.mapDTO(item, elementTypes)).toList().cast<GreenSpaceObject>() : [];
    } catch (_) {
      rethrow;
    }
  }

  Future<List<ProtocolHistory>> getProtocolActionLog({required String userTokenId, required int protocolId}) async {
    final body = DefaultBody(userToken: userTokenId);
    try {
      final List<ActionLogDTO> historyLog = await _protocolService.getProtocolActionLog(
        body: body,
        protocolId: protocolId,
      );
      return historyLog.isNotEmpty ? historyLog.map((item) => ActionLogMapper.mapDTO(item)).toList().cast<ProtocolHistory>() : [];
    } catch (_) {
      rethrow;
    }
  }
}
