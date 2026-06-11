import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_condition.dart';

class UpdateProtocolWorkCondition {
  final List<int> condition;
  final String? otherName;
  UpdateProtocolWorkCondition({
    required this.condition,
    this.otherName,
  });
}

class ResetProtocolWorkCondition {}

class FetchWorkConditions {}

class FetchWorkConditionsSuccess {
  final List<WorkCondition> conditions;
  FetchWorkConditionsSuccess({required this.conditions});
}

class WorkConditionsError {
  final String? errorMessage;
  WorkConditionsError({this.errorMessage});
}
