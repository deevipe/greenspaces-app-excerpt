import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_history.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/protocol_status.dart';

class ProtocolEntity {
  final int? id;
  final User? user;
  final String? date;
  final int? departmentId;
  final SelectObject? selectedDistrict;
  final Municipality? selectedMunicipality;
  final Organisation? selectedOrg;
  final bool contract;
  final bool subContract;
  final bool otherOpt;
  final String? contractRequisites;
  final String? subContractRequisites;
  final String? otherRequisites;
  final int? workCategory;
  final String? otherConditionName;
  final List<int> selectedWorkConditions;
  final List<Representative> representatives;
  final Representative? otherRepresentative;
  final List<GreenSpaceObject> objects;
  final List<ProtocolHistory> history;
  final List<String?> projectPhotos;
  final List<String?> projectFiles;
  final ProtocolStatus status;
  final List<Doc> docs;

  ProtocolEntity({
    required this.id,
    this.user,
    required this.date,
    this.departmentId,
    required this.contract,
    required this.subContract,
    required this.otherOpt,
    this.selectedDistrict,
    this.selectedMunicipality,
    this.selectedOrg,
    this.contractRequisites,
    this.subContractRequisites,
    this.otherRequisites,
    this.workCategory,
    this.otherConditionName,
    required this.selectedWorkConditions,
    required this.objects,
    required this.history,
    required this.projectPhotos,
    required this.projectFiles,
    required this.status,
    required this.representatives,
    this.otherRepresentative,
    required this.docs,
  });

  ProtocolEntity updateWith({
    int? id,
    User? user,
    String? date,
    int? departmentId,
    bool? contract,
    SelectObject? selectedDistrict,
    Municipality? selectedMunicipality,
    Organisation? selectedOrg,
    String? contractRequisites,
    bool? subContract,
    bool? otherOpt,
    String? subContractRequisites,
    String? otherRequisites,
    int? workCategory,
    String? otherConditionName,
    List<int>? selectedWorkConditions,
    List<Representative>? representatives,
    Representative? otherRepresentative,
    List<GreenSpaceObject>? objects,
    List<ProtocolHistory>? history,
    List<String?>? projectPhotos,
    List<String?>? projectFiles,
    ProtocolStatus? status,
    List<Doc>? docs,
  }) =>
      ProtocolEntity(
          id: id ?? this.id,
          user: user ?? this.user,
          date: date ?? this.date,
          departmentId: departmentId ?? this.departmentId,
          selectedDistrict: selectedDistrict ?? this.selectedDistrict,
          selectedMunicipality: selectedMunicipality ?? this.selectedMunicipality,
          selectedOrg: selectedOrg ?? this.selectedOrg,
          contract: contract ?? this.contract,
          contractRequisites: contractRequisites ?? this.contractRequisites,
          subContract: subContract ?? this.subContract,
          subContractRequisites: subContractRequisites ?? this.subContractRequisites,
          otherOpt: otherOpt ?? this.otherOpt,
          otherRequisites: otherRequisites ?? this.otherRequisites,
          workCategory: workCategory ?? this.workCategory,
          selectedWorkConditions: selectedWorkConditions ?? this.selectedWorkConditions,
          otherConditionName: otherConditionName ?? this.otherConditionName,
          representatives: representatives ?? this.representatives,
          objects: objects ?? this.objects,
          history: history ?? this.history,
          projectPhotos: projectPhotos ?? this.projectPhotos,
          projectFiles: projectFiles ?? this.projectFiles,
          status: status ?? this.status,
          otherRepresentative: otherRepresentative ?? this.otherRepresentative,
          docs: docs ?? this.docs);
}
