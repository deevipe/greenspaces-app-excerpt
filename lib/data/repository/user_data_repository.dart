import 'package:gisogs_greenspacesapp/data/api/api_util.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/login_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';
import 'package:gisogs_greenspacesapp/domain/repository/user_repository.dart';

class UserDataRepository extends UserRepository {
  final ApiUtil _apiUtil;

  UserDataRepository(this._apiUtil);

  @override
  Future<User?> authUser({required Login login}) {
    return _apiUtil.auth(login: login);
  }
}
