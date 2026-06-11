import 'package:gisogs_greenspacesapp/data/repository/local_data_repository.dart';
import 'package:gisogs_greenspacesapp/data/repository/protocol_data_repository.dart';
import 'package:gisogs_greenspacesapp/data/repository/user_data_repository.dart';
import 'package:gisogs_greenspacesapp/domain/repository/local_repository.dart';
import 'package:gisogs_greenspacesapp/domain/repository/protocol_repository.dart';
import 'package:gisogs_greenspacesapp/domain/repository/user_repository.dart';

import 'package:gisogs_greenspacesapp/internal/dependencies/api_module.dart';

class RepositoryModule {
  static UserRepository? _userRepository;
  static ProtocolRepository? _protocolRepository;
  static LocalRepository? _localRepository;

  static UserRepository userRepository() {
    _userRepository ??= UserDataRepository(ApiModule.apiUtil());
    return _userRepository!;
  }

  static ProtocolRepository protocolRepository() {
    _protocolRepository ??= ProtocolDataRepository(ApiModule.apiUtil());
    return _protocolRepository!;
  }

  static LocalRepository localRepository() {
    _localRepository ??= LocalDataRepository(ApiModule.apiUtil());
    return _localRepository!;
  }
}
