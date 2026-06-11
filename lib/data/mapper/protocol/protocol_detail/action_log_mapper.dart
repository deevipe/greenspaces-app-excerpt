import 'package:gisogs_greenspacesapp/data/dto/protocol/detail/action_log_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_history.dart';

class ActionLogMapper {
  static ProtocolHistory mapDTO(ActionLogDTO data) => ProtocolHistory(
        id: data.id,
        date: data.date,
        actionType: data.actionType,
        actionTypeId: data.actionTypeId,
        details: data.details,
        userName: data.userName,
      );
}
