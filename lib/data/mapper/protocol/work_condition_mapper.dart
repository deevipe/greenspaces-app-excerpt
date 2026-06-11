import 'package:gisogs_greenspacesapp/data/dto/dictionaries/work_condition.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_condition.dart';

class WorkConditionMapper {
  static WorkCondition mapDTO(WorkConditionDTO data) {
    return WorkCondition(id: data.id, title: data.title);
  }
}
