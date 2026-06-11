import 'package:gisogs_greenspacesapp/data/dto/protocol/ogs_type_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/ogs_type.dart';

class OgsTypeMapper {
  static OgsType mapDTO(OgsTypeDTO data, int id) => OgsType(
        id: id,
        title: data.title,
        elementTypeId: data.elementTypeId,
      );
}
