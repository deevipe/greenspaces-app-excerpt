import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_category.dart';

class UpdateProtocolWorkCategory {
  final int? categoryId;
  UpdateProtocolWorkCategory({required this.categoryId});
}

class FetchWorkCategories {}

class FetchWorkCategoriesSuccess {
  final List<WorkCategory> categories;
  FetchWorkCategoriesSuccess({required this.categories});
}

class ResetProtocolWorkCategory {}

class WorkCategoryError {
  final String errorMessage;
  WorkCategoryError({required this.errorMessage});
}
