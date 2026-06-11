import 'package:gisogs_greenspacesapp/data/dto/dictionaries/organisation_dto.dart';
import 'package:gisogs_greenspacesapp/data/mapper/dictionaries/organisation_user_mapper.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';

class OrganisationMapper {
  static Organisation mapDTO(OrganisationDTO data) {
    return Organisation(
      id: data.id,
      name: data.name,
      type: data.typeId == 1 ? OrganizationType.committee : data.typeId == 2 ? OrganizationType.spp : OrganizationType.other,
      members: data.members.map((member) => OrganisationUserMapper.mapDTO(member)).toList().cast<OrganisationUser>(),
    );
  }
}
