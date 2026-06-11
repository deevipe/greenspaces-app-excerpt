import 'package:gisogs_greenspacesapp/domain/entity/login/login_entity.dart';

class GetLoginBody {
  final Login login;

  GetLoginBody({required this.login});

  Map<String, dynamic> toApi() {
    return {
      'username': login.username,
      'password': login.password,
    };
  }
}
