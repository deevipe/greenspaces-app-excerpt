class ProtocolHistory {
  final int id;
  final String date;
  final int actionTypeId;
  final String actionType;
  final String userName;
  final String details;

  ProtocolHistory({
    required this.id,
    required this.date,
    required this.actionType,
    required this.actionTypeId,
    required this.details,
    required this.userName,
  });
}
