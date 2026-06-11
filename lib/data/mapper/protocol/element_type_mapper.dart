import 'package:gisogs_greenspacesapp/data/dto/dictionaries/element_type_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';

class ElementTypeMapper {
  static ElementType mapDTO(ElementTypeDTO data) => ElementType(
        id: data.id,
        title: data.title,
        workCatIds: data.workCatIds,
      );
}
