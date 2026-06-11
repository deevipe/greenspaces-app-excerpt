import 'package:gisogs_greenspacesapp/data/dto/dictionaries/area_type_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';

class AreaTypeMapper {
  static AreaType mapDTO(AreaTypeDTO data) => AreaType(
        id: data.id.toString(),
        title: data.title,
        layerUrl: data.url,
      );
}
