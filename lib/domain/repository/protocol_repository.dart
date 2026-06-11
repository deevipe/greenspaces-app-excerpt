import 'dart:async';
import 'dart:io';

import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/protocol_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_history.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_data.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_category.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_condition.dart';

abstract class ProtocolRepository {
  Future<ProtocolListData> getProtocolList({required String userTokenId, required bool revision, required int page});
  Future<void> getDictionaries({required String userTokenId});
  Future<void> getOrgsAndUsers({required String userTokenId});
  Future<void> getDistrictsByUser({required String userTokenId});
  Future<void> getMunicipalities({required String userTokenId});
  Future<List<WorkCategory>> getWorkCategories({required String userTokenId});
  Future<List<WorkCondition>> getWorkConditions({required String userTokenId});
  Future<ProtocolEntity?> getProtocolDetail({required String userTokenId, required int protocolId});
  Future<List<Organisation>> searchOrgs({required String userTokenId, required String query});
  Future<int?> saveProtocol({required String userTokenId, required Map<String, dynamic> rawData, required bool revision});
  Future<bool> saveAreaList({required String userTokenId, required Map<String, dynamic> rawData, required int protocolId, required bool revision});
  Future<List<GreenSpaceObject>> getAreaList({required String userTokenId, required int protocolId});
  Future<bool> deleteProtocol({required String userTokenId, required int protocolId});
  Future<Doc?> uploadFile({
    required String userTokenId,
    required int elementId,
    required File file,
    required StreamController<Map<String, int>> progressStreamController,
    required int entityTypeId,
    required bool photo,
    String? customFileName,
  });
  Future<List<ProtocolHistory>> getProtocolActionLog({required String userTokenId, required int protocolId});
}
