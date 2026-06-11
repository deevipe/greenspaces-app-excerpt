import 'package:gisogs_greenspacesapp/data/dto/dictionaries/organisation_user_dto.dart';

class OrganisationDTO {
  final int id;
  final int typeId;
  final String name;
  final List<OrganisationUserDTO> members;

  const OrganisationDTO({required this.id, required this.typeId, required this.name, required this.members});

  factory OrganisationDTO.fromJson(Map<String, dynamic> json) => OrganisationDTO(
        id: json['Representatives'] != null ? json['Representatives'].first['Id'] : json['id'] ?? json['Id'],
        typeId: json['Id'] ?? 3, // Сводим данные из разных источников к одной модели
        name: json['Representatives'] != null ? json['Representatives'].first['Name'] : json['text'] ?? json['Name'],
        members: json['Representatives'] != null
            ? json['Representatives'].first['Members'].map((member) => OrganisationUserDTO.fromJson(member)).toList().cast<OrganisationUserDTO>()
            : [],
      );
}
