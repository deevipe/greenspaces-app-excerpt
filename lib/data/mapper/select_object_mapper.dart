import 'package:gisogs_greenspacesapp/data/dto/select_object_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';

class SelectObjectMapper {
  static SelectObject mapDTO(SelectObjectDTO data) {
    return SelectObject(id: data.id, title: data.name);
  }
}
