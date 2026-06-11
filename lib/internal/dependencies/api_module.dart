import 'package:gisogs_greenspacesapp/data/api/api_util.dart';
import 'package:gisogs_greenspacesapp/data/api/service/protocol_service.dart';
import 'package:gisogs_greenspacesapp/data/api/service/user_service.dart';

class ApiModule {
  static ApiUtil? _apiUtil;

  static ApiUtil apiUtil() {
    _apiUtil ??= ApiUtil(UserService(), ProtocolService());
    return _apiUtil!;
  }
}
