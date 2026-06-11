import 'package:gisogs_greenspacesapp/data/dto/dictionaries/work_category_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_category.dart';

class WorkCategoryMapper {
  static WorkCategory mapDTO(WorkCategoryDTO data) {
    return WorkCategory(id: data.id, title: data.title);
  }
}
