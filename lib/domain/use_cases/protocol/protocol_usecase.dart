import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object_item.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/protocol_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_history.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_data.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_category.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_condition.dart';
import 'package:gisogs_greenspacesapp/domain/enums/file_upload_entity_type.dart';
import 'package:gisogs_greenspacesapp/domain/enums/protocol_status.dart';
import 'package:gisogs_greenspacesapp/domain/utils/shared_preferences.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/repository_module.dart';

class ProtocolUseCase {
  Future<ProtocolListData> listProtocols({required bool revision, required int page}) async {
    try {
      final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
      final ProtocolListData protocolsData =
          await RepositoryModule.protocolRepository().getProtocolList(userTokenId: userTokenId, revision: revision, page: page);

      return protocolsData;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<WorkCategory>> getWorkCategories() async {
    try {
      final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
      final List<WorkCategory> categories = await RepositoryModule.protocolRepository().getWorkCategories(userTokenId: userTokenId);

      return categories;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<WorkCondition>> getWorkConditions() async {
    try {
      final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
      final List<WorkCondition> conditions = await RepositoryModule.protocolRepository().getWorkConditions(userTokenId: userTokenId);

      // Отсортируем условия по Id в порядке убывания
      conditions.sort((a, b) => (a.id < b.id) ? 0 : 1);

      return conditions;
    } catch (_) {
      rethrow;
    }
  }

  /// Данный метод должен вызываться при запуске приложения, чтобы подготовить
  /// локальное хранилище к взаимодействию. Большая часть селектов / кнопок выбора
  /// будет браться из локального хранилища
  Future<void> getDictionaries({required String userTokenId}) async {
    try {
      // Получим все словари через метод апи
      await RepositoryModule.protocolRepository().getDictionaries(userTokenId: userTokenId);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'getDictionaries failed');
      rethrow;
    }
  }

  Future<void> getDistricts({required String userTokenId}) async {
    try {
      await RepositoryModule.protocolRepository().getDistrictsByUser(userTokenId: userTokenId);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'get districts failed');
    }
  }

  Future<void> getMunicipalities({required String userTokenId}) async {
    try {
      await RepositoryModule.protocolRepository().getMunicipalities(userTokenId: userTokenId);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'get municipalities failed');
    }
  }

  /// Данный метод вызывается при запуске приложения, если пользователь залогинен
  /// В противном случае вызывается сразу после логина пользователя
  Future<void> getOrgsAndUsers({required String userTokenId}) async {
    try {
      // Получим одним методом все организации, пользователей
      await RepositoryModule.protocolRepository().getOrgsAndUsers(userTokenId: userTokenId);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'getOrgsAndUsers failed');
      rethrow;
    }
  }

  Future<ProtocolEntity?> getProtocolDetail({required int protocolId}) async {
    try {
      final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
      final ProtocolEntity? protocolData = await RepositoryModule.protocolRepository().getProtocolDetail(userTokenId: userTokenId, protocolId: protocolId);

      return protocolData;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<Organisation>> searchOrgs({required String query}) async {
    try {
      final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
      final List<Organisation> orgsData = await RepositoryModule.protocolRepository().searchOrgs(userTokenId: userTokenId, query: query);

      return orgsData;
    } catch (_) {
      rethrow;
    }
  }

  Future<int?> saveProtocol({required ProtocolEntity protocolDraft, required bool revision}) async {
    try {
      final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);

      // Подготовим модель для отправки на сервер
      List<dynamic> representativesModel = [];

      // Список представителей не может быть пустым по логике экрана
      if (protocolDraft.representatives.isNotEmpty) {
        for (Representative representative in protocolDraft.representatives) {
          representativesModel.add({
            "RepresentativeMemberId": representative.userId,
            "RepresentativeTypeId": representative.typeId,
            "RepresentativeId": representative.representativeId,
            "TypeName": representative.typeId == 1 ? "Комитет" : "СПП",
            "OrganizationId": representative.orgId,
            "OrgName": representative.orgName,
            "Name": representative.userName,
            "Position": representative.userPosition,
            "Phone": representative.userPhone,
          });
        }
      }

      if (protocolDraft.otherRepresentative != null) {
        representativesModel.add({
          "RepresentativeTypeId": 3,
          "OrganizationId": protocolDraft.otherRepresentative!.orgId,
          "OrgName": protocolDraft.otherRepresentative!.orgName,
          "Name": protocolDraft.otherRepresentative!.userName,
          "Position": protocolDraft.otherRepresentative!.userPosition,
          "Phone": protocolDraft.otherRepresentative!.userPhone,
        });
      }

      final Map<String, dynamic> rawData = {
        "Id": protocolDraft.id,
        "EntityType": "Protocol",
        "EntityStateId": protocolDraft.status.getApiId,
        "InspectionDate": protocolDraft.date,
        "DistrictId": int.parse(protocolDraft.selectedDistrict!.id),
        "MunicipalityId": protocolDraft.selectedMunicipality!.id,
        "OrganizationId": protocolDraft.selectedOrg!.id,
        "Reason": protocolDraft.contract
            ? 1
            : protocolDraft.subContract
                ? 2
                : protocolDraft.otherOpt
                    ? 4
                    : 0,
        "ContractNum": protocolDraft.contractRequisites != null ? protocolDraft.contractRequisites!.split(' / ').first : '',
        "ContractDate": protocolDraft.contractRequisites?.split(' / ').last,
        "SubcontractNum": protocolDraft.subContractRequisites != null ? protocolDraft.subContractRequisites!.split(' / ').first : '',
        "SubcontractDate": protocolDraft.subContractRequisites?.split(' / ').last,
        "ReasonComment": protocolDraft.otherRequisites,
        "Representatives": representativesModel,
        "CreatedBy": protocolDraft.user?.id,
        "ModifiedBy": protocolDraft.user?.id,
        "PropertiesFormCommon": [
          {
            "Property": {
              "Id": 546,
              "DataType": "dictionary",
              "Title": "Отдел",
              "IsEdit": true,
              "ForbidEdit": false,
              "DictionaryName": "FT_Department",
              "Multiple": false,
              "Required": false
            },
            "OriginalValue": protocolDraft.departmentId
          },
          {
            "Property": {
              "Id": 461,
              "DataType": "dictionary",
              "Title": "Категория работ",
              "IsEdit": true,
              "ForbidEdit": false,
              "DictionaryName": "Kategoriya_rabot",
              "Multiple": false,
              "Required": false
            },
            "OriginalValue": protocolDraft.workCategory
          },
          {
            "Property": {
              "Id": 528,
              "DataType": "text",
              "Title": "Доп поле к категории работ",
              "IsEdit": true,
              "ForbidEdit": false,
              "DictionaryName": "",
              "Multiple": false,
              "Required": false
            },
            "OriginalValue": ""
          },
          {
            "Property": {
              "Id": 529,
              "DataType": "dictionary",
              "Title": "Условия производства работ",
              "IsEdit": true,
              "ForbidEdit": false,
              "DictionaryName": "FT_work_condition",
              "Multiple": true,
              "Required": false
            },
            "OriginalValueIds": protocolDraft.selectedWorkConditions
          },
          {
            "Property": {
              "Id": 530,
              "DataType": "string",
              "Title": "Доп поле к условия производтсва работ",
              "IsEdit": true,
              "ForbidEdit": false,
              "DictionaryName": "",
              "Multiple": false,
              "Required": false
            },
            "OriginalValue": protocolDraft.otherConditionName ?? ''
          }
        ]
      };

      final int? result = await RepositoryModule.protocolRepository().saveProtocol(userTokenId: userTokenId, rawData: rawData, revision: revision);

      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> saveProtocolAreaList(
      {required ProtocolEntity protocolDraft, required List<AreaType> territories, required int? protocolId, required bool revision}) async {
    List<dynamic> areaList = [];
    Map<String, dynamic> rawData = {'areas': areaList, "deletedAreas": []};
    final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
    try {
      if (protocolDraft.objects.isNotEmpty) {
        for (GreenSpaceObject object in protocolDraft.objects) {
          AreaType? selectedTerritory = territories.firstWhere((element) => element.id == object.territoryTypeId.toString());
          areaList.add({
            "Ogs": object.ogs != null ? object.ogs!.toJson() : {"id": null, "name": null},
            "Id": object.id ?? 0,
            "AreaTypes": [
              {"Id": int.tryParse(selectedTerritory.id), "Title": selectedTerritory.title}
            ],
            "Address": object.address,
            "Elements": object.items.asMap().entries.map((entry) {
              // final int idx = entry.key;
              final GreenSpaceObjectItem item = entry.value;
              return {
                "Id": item.id ?? 0,
                "Count": (item.amountValue != null && item.amountValue!.isNotEmpty) ? int.parse(item.amountValue!) : null,
                "Area": (item.areaValue != null && item.areaValue!.isNotEmpty) ? double.parse(item.areaValue!) : null,
                "OgsType": (item.selectedKind != null && item.selectedKind != '') ? {"Id": 0, "Title": item.selectedKind?.split('_').last ?? ''} : null,
                "Diameter": item.selectedDiameter != null
                    ? {"Id": int.tryParse(item.selectedDiameter?.split('_').first ?? '0'), "Title": item.selectedDiameter?.split('_').last ?? ''}
                    : null,
                "Age": item.selectedAge != null
                    ? {"Id": int.tryParse(item.selectedAge?.split('_').first ?? '0'), "Title": item.selectedAge?.split('_').last ?? ''}
                    : null,
                "ActionType": {"Id": int.tryParse(item.selectedWorkType?.split('_').first ?? '0'), "Title": item.selectedWorkType?.split('_').last ?? ''},
                "ElementType": {"Id": item.type?.id ?? 0, "Title": item.type?.title ?? ''},
                "DiameterText": "",
                "Multitrunk": item.stemList.isNotEmpty,
                "HasPhoto": protocolDraft.projectPhotos.isNotEmpty,
                "WorkMethod": item.selectedWorkSubType != null
                    ? {"Id": int.tryParse(item.selectedWorkSubType?.split('_').first ?? '0'), "Title": item.selectedWorkSubType?.split('_') ?? ''}
                    : null,
                "StateIds": item.selectedObjectState != null ? [item.selectedObjectState!.split('_').first] : [],
                "States": item.selectedObjectState != null
                    ? [
                        {"Id": item.selectedObjectState?.split('_').first ?? 0, "Title": item.selectedObjectState?.split('_').last ?? ''}
                      ]
                    : [],
                "StateOther": item.otherStateValue ?? '',
                "IsNew": (item.id == null || item.id == 0),
                "IsGazon": [11, 4, 10].contains(item.type?.id)
              };
            }).toList(),
            "DeletedElements": [],
            "selectedElement": {
              "Id": null,
              "ElementType": null,
              "OgsType": null,
              "Diameter": null,
              "Age": null,
              "Count": null,
              "Area": null,
              "ActionType": null,
              "DiameterText": "",
              "Multitrunk": false,
              "IsGazon": false
            },
            "inlineElement": {
              "Id": null,
              "ElementType": null,
              "OgsType": null,
              "Diameter": null,
              "Age": null,
              "Count": null,
              "Area": null,
              "ActionType": null,
              "DiameterText": "",
              "Multitrunk": false,
              "IsGazon": false
            }
          });
        }

        rawData['areas'] = areaList;
      }
      return await RepositoryModule.protocolRepository().saveAreaList(userTokenId: userTokenId, rawData: rawData, revision: revision, protocolId: protocolId!);
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> deleteProtocolById({required int protocolId}) async {
    try {
      final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
      return await RepositoryModule.protocolRepository().deleteProtocol(userTokenId: userTokenId, protocolId: protocolId);
    } catch (_) {
      rethrow;
    }
  }

  Future<Doc?> uploadFile({
    required int elementId,
    required File file,
    required StreamController<Map<String, int>> progressStreamController,
    required UploadEntityType entityType,
    required bool photo,
    String? customFileName,
  }) async {
    try {
      final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
      return await RepositoryModule.protocolRepository().uploadFile(
        userTokenId: userTokenId,
        elementId: elementId,
        file: file,
        progressStreamController: progressStreamController,
        entityTypeId: entityType.getApiId,
        customFileName: customFileName,
        photo: photo
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<List<GreenSpaceObject>> getAreaList({required int protocolId}) async {
    try {
      final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
      return await RepositoryModule.protocolRepository().getAreaList(userTokenId: userTokenId, protocolId: protocolId);
    } catch (_) {
      rethrow;
    }
  }

  Future<List<ProtocolHistory>> getProtocolActionLog({required int protocolId}) async {
    try {
      final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
      return await RepositoryModule.protocolRepository().getProtocolActionLog(userTokenId: userTokenId, protocolId: protocolId);
    } catch (_) {
      rethrow;
    }
  }
}
