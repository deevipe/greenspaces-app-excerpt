import 'package:gisogs_greenspacesapp/data/dto/dictionaries/action_type_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/action_type.dart';

class ActionTypeMapper {
  static ActionType mapDTO(ActionTypeDTO data) => ActionType(
        id: data.id,
        title: data.title,
        elementTypeId: data.elementTypeId,
        parentIds: data.parentIds,
      );
}
