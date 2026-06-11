import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/representative_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';

class RepresentativesMapper {
  static Representative mapDTO(RepresentativeDTO data) => Representative(
        id: data.id,
        typeId: data.typeId,
        typeName: data.typeName,
        orgId: data.orgId,
        representativeId: data.representativeId,
        orgName: data.orgName,
        userId: data.userId,
        userName: data.userName,
        userPhone: data.userPhone,
        userPosition: data.userPosition,
      );
}
