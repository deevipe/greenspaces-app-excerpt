import 'package:gisogs_greenspacesapp/data/dto/dictionaries/green_space_state_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/green_space_state.dart';

class GreenSpaceStateMapper {
  static GreenSpaceState mapDTO(GreenSpaceStateDTO data) => GreenSpaceState(
        id: data.id,
        title: data.title,
        elementTypeIds: data.elementTypeIds,
      );
}
