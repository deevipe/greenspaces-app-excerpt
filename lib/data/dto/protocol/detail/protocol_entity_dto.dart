import 'package:gisogs_greenspacesapp/data/dto/dictionaries/municipality_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/organisation_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/doc_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/green_space_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/representative_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';

class ProtocolEntityDTO {
  final int id;
  final String? date;
  final MunicipalityDTO? municipality;
  final SelectObject? selectedDistrict;
  final OrganisationDTO? selectedOrg;
  final String? departmentId;
  final String? contractNum;
  final String? contractDate;
  final String? subContractNum;
  final String? subContractDate;
  final String? reasonComment;
  final String? workCategory;
  final String? otherConditionName;
  final List<int>? selectedWorkConditions;
  final List<RepresentativeDTO> representatives;
  final List<GreenSpaceObjectDTO> objects;
  final int statusId;
  final List<DocDTO> docs;

  const ProtocolEntityDTO({
    required this.id,
    this.date,
    this.municipality,
    this.selectedDistrict,
    this.selectedOrg,
    this.departmentId,
    this.contractNum,
    this.contractDate,
    this.subContractNum,
    this.subContractDate,
    this.reasonComment,
    this.workCategory,
    this.otherConditionName,
    this.selectedWorkConditions,
    required this.representatives,
    required this.objects,
    required this.docs,
    required this.statusId,
  });

  factory ProtocolEntityDTO.fromJson(Map<String, dynamic> json) => ProtocolEntityDTO(
        id: json['obj']['Id'],
        date: json['obj']['InspectionDate'],
        departmentId: parseStringParam(properties: json['obj']['Properties'].cast<Map<String, dynamic>>(), type: PropertyType.department),
        municipality: json['obj']['Municipality'] != null && (json['obj']['Municipality']['Id'] != null || json['obj']['Municipality']['Id'] != '')
            ? MunicipalityDTO.fromJson(json['obj']['Municipality'])
            : null,
        selectedDistrict: json['obj']['District'] != null && (json['obj']['District']['Id'] != null || json['obj']['District']['Id'] != '')
            ? SelectObject(id: json['obj']['District']['Id'].toString(), title: json['obj']['District']['Title'])
            : null,
        selectedOrg:
            json['obj']['Organization'] != null && json['obj']['Organization'].isNotEmpty ? OrganisationDTO.fromJson(json['obj']['Organization']) : null,
        contractNum: json['obj']['ContractNum'],
        contractDate: json['obj']['ContractDate'],
        subContractNum: json['obj']['SubcontractNum'],
        subContractDate: json['obj']['SubcontractDate'],
        reasonComment: json['obj']['ReasonComment'],
        workCategory: parseStringParam(properties: json['obj']['Properties'].cast<Map<String, dynamic>>(), type: PropertyType.category),
        otherConditionName: parseStringParam(properties: json['obj']['Properties'].cast<Map<String, dynamic>>(), type: PropertyType.conditionOther),
        selectedWorkConditions: parseWorkConditions(properties: json['obj']['Properties'].cast<Map<String, dynamic>>()),
        representatives: (json['obj']['Representatives'] != null && json['obj']['Representatives'].isNotEmpty)
            ? json['obj']['Representatives'].map((item) => RepresentativeDTO.fromJson(item)).toList().cast<RepresentativeDTO>()
            : [],
        objects: (json['areaList'] != null && json['areaList'].isNotEmpty)
            ? json['areaList'].map((item) => GreenSpaceObjectDTO.fromJson(item)).toList().cast<GreenSpaceObjectDTO>()
            : [],
        docs: json['docs'].map((json) => DocDTO.fromJson(json)).toList().cast<DocDTO>(),
        statusId: json['obj']['EntityStateId'],
      );
}

enum PropertyType { category, department, conditionOther }

String? parseStringParam({required List<Map<String, dynamic>> properties, required PropertyType type}) {
  String? res;
  switch (type) {
    case PropertyType.department:
      for (Map<String, dynamic> prop in properties) {
        if (prop['Property']['Name'] == 'Department_FT') {
          res = prop['Value']['OriginalValue']?.toString();
        }
      }
      break;
    case PropertyType.conditionOther:
      for (Map<String, dynamic> prop in properties) {
        if (prop['Property']['Name'] == 'comment_work_condition_FT') {
          res = prop['Value']['OriginalValue']?.toString();
        }
      }
      break;
    case PropertyType.category:
      for (Map<String, dynamic> prop in properties) {
        if (prop['Property']['Name'] == 'Work_Type_FT') {
          res = prop['Value']['OriginalValue'];
        }
      }
      break;
  }

  return res;
}

List<int> parseWorkConditions({required List<Map<String, dynamic>> properties}) {
  List<int> res = [];
  List<String> originalVals = [];
  for (Map<String, dynamic> prop in properties) {
    if (prop['Property']['Name'] == 'work_conditions_FT') {
      originalVals = prop['Value']['OriginalValue']?.split(',') ?? [];
    }
  }
  if (originalVals.isNotEmpty) {
    res = originalVals.map((e) => int.parse(e)).toList();
  }

  return res;
}
