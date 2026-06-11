import 'package:collection/collection.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/protocol_entity_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/representative_dto.dart';
import 'package:gisogs_greenspacesapp/data/mapper/dictionaries/municipality_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/dictionaries/organisation_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_detail/doc_item_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_detail/green_space_object_mapper.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_detail/representatives_mapper.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/protocol_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';
import 'package:gisogs_greenspacesapp/domain/enums/protocol_status.dart';
import 'package:intl/intl.dart';

class ProtocolDetailMapper {
  static ProtocolEntity mapDTO(ProtocolEntityDTO data, List<ElementType> elementTypes) {
    final RepresentativeDTO? otherRepresentative = data.representatives.firstWhereOrNull((element) => element.typeId == 3);
    return ProtocolEntity(
      id: data.id,
      date: convertInspectionDate(date: data.date),
      departmentId: (data.departmentId != null && data.departmentId != '') ? int.parse(data.departmentId!) : null,
      selectedDistrict: data.selectedDistrict,
      selectedMunicipality: data.municipality != null ? MunicipalityMapper.mapDTO(data.municipality!) : null,
      selectedOrg: data.selectedOrg != null ? OrganisationMapper.mapDTO(data.selectedOrg!) : null,
      contract: data.contractNum != null && data.contractNum != '',
      subContract: data.subContractNum != null && data.subContractNum != '',
      otherOpt: data.reasonComment?.isNotEmpty ?? false,
      objects: data.objects.map((object) => GreenSpaceObjectMapper.mapDTO(object, elementTypes)).toList().cast<GreenSpaceObject>(),
      history: [],
      projectPhotos: [],
      projectFiles: [],
      status: data.statusId == 1 ? ProtocolStatus.draft : ProtocolStatus.returned,
      otherRepresentative: otherRepresentative != null ? RepresentativesMapper.mapDTO(otherRepresentative) : null,
      selectedWorkConditions: data.selectedWorkConditions ?? [],
      workCategory: (data.workCategory != null && data.workCategory != '') ? int.tryParse(data.workCategory!) : null,
      contractRequisites: buildContractRequiesites(cNum: data.contractNum, date: data.contractDate),
      subContractRequisites: buildContractRequiesites(cNum: data.subContractNum, date: data.subContractDate),
      otherRequisites: data.reasonComment != '' && data.reasonComment != null ? data.reasonComment : null,
      otherConditionName: data.otherConditionName,
      representatives: data.representatives.map((representative) => RepresentativesMapper.mapDTO(representative)).toList().cast<Representative>(),
      docs: data.docs.map((doc) => DocItemMapper.mapDTO(doc)).toList().cast<Doc>(),
    );
  }
}

// необходимый формат пр. 02/03/2023
String convertInspectionDate({String? date}) {
  if (date != null) {
    final DateTime? convertedDate = DateTime.tryParse(date);
    String formattedDate = '';
    if (convertedDate != null) {
      formattedDate = DateFormat("dd/MM/y", "ru").format(convertedDate);
    }

    return formattedDate;
  } else {
    return '';
  }
}

String buildContractRequiesites({String? cNum, String? date}) {
  if (date == null) {
    return '';
  } else {
    final DateTime? convertedDate = DateTime.tryParse(date);
    String formattedDate = '';
    if (convertedDate != null) {
      formattedDate = DateFormat("dd.MM.y", "ru").format(convertedDate);
    }

    if (formattedDate != '') {
      return cNum != null ? '$cNum / $formattedDate' : '- / $formattedDate';
    } else {
      return cNum != null ? '$cNum / -' : '- / -';
    }
  }
}
