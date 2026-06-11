import 'package:gisogs_greenspacesapp/domain/entity/login/login_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';

abstract class UserRepository {
  Future<User?> authUser({
    required Login login,
  });
}
