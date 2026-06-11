import 'package:gisogs_greenspacesapp/data/dto/dictionaries/organisation_user_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';

class OrganisationUserMapper {
  static OrganisationUser mapDTO(OrganisationUserDTO data) => OrganisationUser(
        id: data.id,
        fio: data.name,
        orgId: data.orgId,
        orgName: data.orgName,
        position: data.position,
        tel: data.phone,
      );
}
