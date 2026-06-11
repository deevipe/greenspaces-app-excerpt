import 'package:gisogs_greenspacesapp/data/dto/dictionaries/municipality_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';

class MunicipalityMapper {
  static Municipality mapDTO(MunicipalityDTO data) => Municipality(
        id: data.id,
        districtId: data.districtId,
        title: data.title,
        oktmo: data.oktmo,
      );
}
