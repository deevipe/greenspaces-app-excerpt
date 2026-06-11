import 'dart:io';

import 'dart:async';

import 'package:gisogs_greenspacesapp/data/api/api_util.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/protocol_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_history.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_data.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_category.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_condition.dart';
import 'package:gisogs_greenspacesapp/domain/repository/protocol_repository.dart';

class ProtocolDataRepository extends ProtocolRepository {
  final ApiUtil _apiUtil;

  ProtocolDataRepository(this._apiUtil);

  @override
  Future<ProtocolListData> getProtocolList({required String userTokenId, required bool revision, required int page}) {
    return _apiUtil.listProtocols(userTokenId: userTokenId, revision: revision, page: page);
  }

  @override
  Future<List<WorkCategory>> getWorkCategories({required String userTokenId}) {
    return _apiUtil.getWorkCategories(userTokenId: userTokenId);
  }

  @override
  Future<List<WorkCondition>> getWorkConditions({required String userTokenId}) {
    return _apiUtil.getWorkConditions(userTokenId: userTokenId);
  }

  @override
  Future<void> getDictionaries({required String userTokenId}) {
    return _apiUtil.getDictionaries(userTokenId: userTokenId);
  }

  @override
  Future<void> getOrgsAndUsers({required String userTokenId}) {
    return _apiUtil.getOrgsAndUsers(userTokenId: userTokenId);
  }

  @override
  Future<ProtocolEntity?> getProtocolDetail({required String userTokenId, required int protocolId}) {
    return _apiUtil.getProtocolDetail(userTokenId: userTokenId, protocolId: protocolId);
  }

  @override
  Future<List<Organisation>> searchOrgs({required String userTokenId, required String query}) {
    return _apiUtil.searchOrgs(userTokenId: userTokenId, query: query);
  }

  @override
  Future<int?> saveProtocol({required String userTokenId, required Map<String, dynamic> rawData, required bool revision}) {
    return _apiUtil.saveProtocol(rawData: rawData, revision: revision, userTokenId: userTokenId);
  }

  @override
  Future<void> getDistrictsByUser({required String userTokenId}) {
    return _apiUtil.getDistricts(userTokenId: userTokenId);
  }

  @override
  Future<void> getMunicipalities({required String userTokenId}) {
    return _apiUtil.getMunicipalities(userTokenId: userTokenId);
  }

  @override
  Future<bool> saveAreaList({required userTokenId, required Map<String, dynamic> rawData, required int protocolId, required bool revision}) {
    return _apiUtil.saveAreaList(rawData: rawData, revision: revision, userTokenId: userTokenId, protocolId: protocolId);
  }

  @override
  Future<bool> deleteProtocol({required String userTokenId, required int protocolId}) {
    return _apiUtil.deleteProtocol(userTokenId: userTokenId, protocolId: protocolId);
  }

  @override
  Future<Doc?> uploadFile({
    required String userTokenId,
    required int elementId,
    required File file,
    required StreamController<Map<String, int>> progressStreamController,
    required int entityTypeId,
    required bool photo,
    String? customFileName,
  }) async {
    return _apiUtil.uploadFile(
      userTokenId: userTokenId,
      elementId: elementId,
      file: file,
      progressStreamController: progressStreamController,
      entityTypeId: entityTypeId,
      photo: photo,
      customFileName: customFileName
    );
  }

  @override
  Future<List<GreenSpaceObject>> getAreaList({required String userTokenId, required int protocolId}) {
    return _apiUtil.getAreaList(userTokenId: userTokenId, protocolId: protocolId);
  }

  @override
  Future<List<ProtocolHistory>> getProtocolActionLog({required String userTokenId, required int protocolId}) {
    return _apiUtil.getProtocolActionLog(userTokenId: userTokenId, protocolId: protocolId);
  }
}
