class UserDTO {
  final int id;
  final String? fio;
  final String department;
  final String token;

  UserDTO.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['UserID']),
        fio = json['FIO'],
        department = _getOrgName(json['CustomInfo']),
        token = json['TokenID'];
}

String _getOrgName(Map<String, dynamic>? data) {
  String res = '';

  try {
    if (data != null) {
      res = data['organisationName'] ?? '';
    }
  } catch (e) {
    rethrow;
  }

  return res;
}
