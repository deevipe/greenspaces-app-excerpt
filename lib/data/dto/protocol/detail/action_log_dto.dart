class ActionLogDTO {
  final int id;
  final String date;
  final int actionTypeId;
  final String actionType;
  final String userName;
  final String details;

  ActionLogDTO({
    required this.id,
    required this.date,
    required this.actionTypeId,
    required this.actionType,
    required this.userName,
    required this.details,
  });

  factory ActionLogDTO.fromJson(Map<String, dynamic> json) => ActionLogDTO(
        id: json['Id'],
        date: json['Date'] ?? '',
        actionTypeId: json['ActionTypeId'] ?? 0,
        actionType: json['ActionType'] ?? '',
        userName: json['UserName'] ?? '',
        details: json['Details'] ?? '',
      );
}
