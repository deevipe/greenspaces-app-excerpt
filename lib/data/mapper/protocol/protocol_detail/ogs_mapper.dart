import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/ogs_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/ogs_entity.dart';

class OgsMapper {
  static Ogs mapDTO(OgsDTO? data) => Ogs(id: data?.id, name: data?.name);
}
