import 'dart:async';
import 'dart:convert';
import 'package:gisogs_greenspacesapp/data/api/utils/background_parser.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/area_type_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/dictionary_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/action_log_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/green_space_dto.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/dio_settings.dart';
import 'package:gisogs_greenspacesapp/config/exceptions.dart';
import 'package:gisogs_greenspacesapp/data/api/request/custom_dictionary_body.dart';
import 'package:gisogs_greenspacesapp/data/api/request/default_body.dart';
import 'package:gisogs_greenspacesapp/data/api/request/protocol_detail_body.dart';
import 'package:gisogs_greenspacesapp/data/api/request/protocol_list_body.dart';
import 'package:gisogs_greenspacesapp/data/api/request/search_org_body.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/action_type_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/municipality_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/organisation_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/element_type_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/green_space_state_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/doc_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/ogs_type_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/protocol_entity_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/protocol_list_data_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/work_category_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/work_condition.dart';
import 'package:gisogs_greenspacesapp/data/dto/select_object_dto.dart';

final parser = BackgroundParser();

class ProtocolService {
  final Dio _dio;

  ProtocolService({
    Dio? dio,
  }) : _dio = dio ?? DioSettings.createDio();

  Future<ProtocolListDataDTO> listProtocols({
    required ProtocolListBody body,
    required int entityStateId,
  }) async {
    ProtocolListDataDTO result = ProtocolListDataDTO.initial();
    try {
      final Response response = await _dio.post(
        '/protocol/GetList/',
        options: Options(
          contentType: 'multipart/form-data',
        ),
        data: json.encode({
          "order": {"by": "created", "direction": "desc"},
          "filters": {"id": null, "entity_state_id": entityStateId},
          "searchStr": ""
        }),
        queryParameters: body.toApi(),
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            result = ProtocolListDataDTO.fromJson(response.data);
          } catch (_) {
            throw ParseException();
          }
        }
      }

      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<WorkCategoryDTO>> getWorkCategories({required CustomDictionaryBody body}) async {
    List<WorkCategoryDTO> result = [];
    try {
      final Response response = await _dio.get(
        '/dictionary/getcustomdictionaryitems/',
        queryParameters: body.toApi(),
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            result = response.data.map((item) => WorkCategoryDTO.fromJson(item)).toList().cast<WorkCategoryDTO>();
          } catch (_) {
            throw ParseException();
          }
        }
      }

      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<WorkConditionDTO>> getWorkConditions({required CustomDictionaryBody body}) async {
    List<WorkConditionDTO> result = [];
    try {
      final Response response = await _dio.get(
        '/dictionary/getcustomdictionaryitems/',
        queryParameters: body.toApi(),
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            result = response.data.map((item) => WorkConditionDTO.fromJson(item)).toList().cast<WorkConditionDTO>();
          } catch (_) {
            throw ParseException();
          }
        }
      }

      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<DictionaryDTO> getDictionaries(DefaultBody body) async {
    DictionaryDTO result = DictionaryDTO.initial();
    try {
      final Response response = await _dio.get('/protocol/getDictionaries', queryParameters: body.toApi());

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            if (response.data['actionTypes'] != null && response.data['actionTypes'].isNotEmpty) {
              result.actionTypes.addAll(response.data['actionTypes'].map((item) => ActionTypeDTO.fromJson(item)).toList().cast<ActionTypeDTO>());
            }

            if (response.data['elementTypes'] != null && response.data['elementTypes'].isNotEmpty) {
              result.elementTypes.addAll(response.data['elementTypes'].map((item) => ElementTypeDTO.fromJson(item)).toList().cast<ElementTypeDTO>());
            }

            if (response.data['greenSpaceStates'] != null && response.data['greenSpaceStates'].isNotEmpty) {
              result.greenSpaceStates
                  .addAll(response.data['greenSpaceStates'].map((item) => GreenSpaceStateDTO.fromJson(item)).toList().cast<GreenSpaceStateDTO>());
            }

            if (response.data['ogsTypes'] != null && response.data['ogsTypes'].isNotEmpty) {
              result.ogsTypes.addAll(response.data['ogsTypes'].map((item) => OgsTypeDTO.fromJson(item)).toList().cast<OgsTypeDTO>());
            }

            if (response.data['areaTypes'] != null && response.data['areaTypes'].isNotEmpty) {
              result.areaTypes.addAll(response.data['areaTypes'].map((item) => AreaTypeDTO.fromJson(item)).toList().cast<AreaTypeDTO>());
            }

            if (response.data['workMethods'] != null && response.data['workMethods'].isNotEmpty) {
              result.workMethods.addAll(response.data['workMethods'].map((item) => SelectObjectDTO.fromJson(item)).toList().cast<SelectObjectDTO>());
            }

            if (response.data['diameters'] != null && response.data['diameters'].isNotEmpty) {
              result.diameters.addAll(response.data['diameters'].map((item) => SelectObjectDTO.fromJson(item)).toList().cast<SelectObjectDTO>());
            }

            if (response.data['ages'] != null && response.data['ages'].isNotEmpty) {
              result.ages.addAll(response.data['ages'].map((item) => SelectObjectDTO.fromJson(item)).toList().cast<SelectObjectDTO>());
            }
          } catch (_) {
            throw ParseException();
          }
        }
      }
      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<OrganisationDTO>> getOrgsAndUsers({required DefaultBody body}) async {
    List<OrganisationDTO> result = [];

    try {
      final Response response = await _dio.get('/protocol/representatives', queryParameters: body.toApi());
      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          result = response.data.map((representative) => OrganisationDTO.fromJson(representative)).toList().cast<OrganisationDTO>();
        }
      }

      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<ProtocolEntityDTO?> getProtocolDetail({required ProtocolDetailBody body}) async {
    try {
      ProtocolEntityDTO? result;

      final Response response = await _dio.get('/protocol/getCard', queryParameters: body.toApi());
      if (DioHandler.checkResponse(response)) {
        try {
          result = ProtocolEntityDTO.fromJson(response.data);
        } catch (_) {
          throw ParseException();
        }
      }

      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<OrganisationDTO>> searchOrgs({required SearchOrgBody body}) async {
    try {
      List<OrganisationDTO> result = [];
      // '/mwp/getOrganizations' версия для АПИ. Тяжелая и медленная
      final Response response = await _dio.get('/Organization/GetOrganizationJsonNew', queryParameters: body.toApi(), options: Options(receiveTimeout: 120000));
      if (DioHandler.checkResponse(response)) {
        try {
          result = await parser.parseOtherOrgs(response.data);
        } catch (_) {
          throw ParseException();
        }
      }

      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<int?> saveProtocol({required DefaultBody body, required Map<String, dynamic> rawData}) async {
    int? result;
    try {
      final Response response = await _dio.post(
        '/protocol/save/',
        data: json.encode(rawData),
        queryParameters: body.toApi(),
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            if (response.data['success'] == true) {
              result = response.data['id'];
            }
          } catch (_) {
            throw ParseException();
          }
        }
      }
      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> saveAreaList({required int protocolId, required DefaultBody body, required Map<String, dynamic> rawData}) async {
    bool result = false;
    try {
      final Response response = await _dio.post(
        '/protocol/saveElements/$protocolId',
        options: Options(
          contentType: 'multipart/form-data',
        ),
        data: json.encode(rawData),
        queryParameters: body.toApi(),
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            if (response.data['Success'] == true) {
              result = true;
            } else {
              return Future.error(response.data['Error'] ?? GeneralErrors.generalError);
            }
          } catch (_) {
            throw ParseException();
          }
        }
      }
      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<SelectObjectDTO>> getDistrictsByUser({required DefaultBody body}) async {
    List<SelectObjectDTO> result = [];
    try {
      final Response response = await _dio.get(
        '/dictionary/districtsByCurrentUserOrg/',
        queryParameters: body.toApi(),
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            result = await parser.parseSelectObject(response.data);
          } catch (_) {
            throw ParseException();
          }
        }
      }
    } catch (_) {
      rethrow;
    }
    return result;
  }

  Future<List<MunicipalityDTO>> getMunicipalities({required DefaultBody body}) async {
    List<MunicipalityDTO> result = [];
    try {
      final Response response = await _dio.get(
        '/dictionary/getMunicipalityJson/',
        queryParameters: body.toApi(),
      );
      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            result = response.data.map((json) => MunicipalityDTO.fromJson(json)).toList().cast<MunicipalityDTO>();
          } catch (_) {
            throw ParseException();
          }
        }
      }
    } catch (_) {
      rethrow;
    }
    return result;
  }

  Future<bool> deleteProtocolById({required DefaultBody body, required int protocolId}) async {
    bool res = false;

    try {
      final Response response = await _dio.post(
        '/protocol/delete',
        data: json.encode({
          'ids': [protocolId]
        }),
        queryParameters: body.toApi(),
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          if (response.data['success'] == true) {
            res = true;
          } else {
            return Future.error('Не удалось удалить протокол');
          }
        }
      }

      return res;
    } catch (_) {
      rethrow;
    }
  }

  Future<DocDTO?> uploadFile({
    required int elementId,
    required DefaultBody body,
    required File file,
    required StreamController<Map<String, int>> progressStreamController,
    required int entityTypeId,
    String? customFileName,
    required bool photo,
  }) async {
    final String? mimeType = lookupMimeType(file.path);
    MediaType? mediaType;

    if (mimeType != null) {
      final List<String> params = mimeType.split('/');
      mediaType = MediaType(params.first, params.last);
    }
    MultipartFile? mFile;
    try {
      mFile = await MultipartFile.fromFile(file.path, filename: file.path.split('/').last, contentType: mediaType ?? MediaType('multipart', 'form-data'));
    } catch (e) {
      throw ParseException();
    }

    final FormData formData = FormData.fromMap({
      'entityType': entityTypeId,
      'fileComment': '',
      'fileTitle': customFileName ?? file.path.split('/').last,
      'oldFile': false,
      'file': mFile,
      // 'escapedName': ''
      'doctype': photo ? 2 : 1,
      'published': null
    });

    _dio.post(
      "/document/upload/$elementId",
      data: formData,
      queryParameters: body.toApi(),
      onSendProgress: (int sent, int total) {
        progressStreamController.add(({'sent': sent.round(), 'total': total.round()}));
      },
    ).then((Response response) async {
      if (DioHandler.checkResponse(response)) {
        if (response.data != null && response.data['error'] == null) {
          try {
            return DocDTO.fromJson(response.data);
          } catch (_) {
            throw ParseException();
          }
        } else {
          return Future.error(response.data['error'] ?? 'Ошибка загрузки файла');
        }
      }

      //Do whatever you want with the response
    }).whenComplete(
      () => progressStreamController.close(),
    );

    return null;
  }

  Future<List<GreenSpaceObjectDTO>> getAreaList({required DefaultBody body, required int protocolId}) async {
    List<GreenSpaceObjectDTO> result = [];
    try {
      final Response response = await _dio.get(
        '/protocol/getAreaWithElements/$protocolId',
        queryParameters: body.toApi(),
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            if (response.data['success'] == true) {
              result = response.data['areaList'].map((json) => GreenSpaceObjectDTO.fromJson(json)).toList().cast<GreenSpaceObjectDTO>();
            }
          } catch (_) {
            throw ParseException();
          }
        }
      }

      return result;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<ActionLogDTO>> getProtocolActionLog({required DefaultBody body, required int protocolId}) async {
    List<ActionLogDTO> result = [];
    try {
      final Response response = await _dio.get(
        '/protocol/actionLog/$protocolId',
        queryParameters: body.toApi(),
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            result = response.data.map((json) => ActionLogDTO.fromJson(json)).toList().cast<ActionLogDTO>();
          } catch (_) {
            throw ParseException();
          }
        }
      }

      return result;
    } catch (_) {
      rethrow;
    }
  }
}
