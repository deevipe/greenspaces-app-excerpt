import 'package:gisogs_greenspacesapp/domain/use_cases/protocol/local_data_usecase.dart';
import 'package:gisogs_greenspacesapp/domain/use_cases/protocol/protocol_usecase.dart';
import 'package:gisogs_greenspacesapp/domain/use_cases/user/auth_user_usecase.dart';

class UseCaseModule {
  static AuthUserUseCase? _authUseCases;
  static ProtocolUseCase? _protocolUseCase;
  static LocalDataUseCase? _localDataUseCase;

  static AuthUserUseCase user() {
    _authUseCases ??= AuthUserUseCase();
    return _authUseCases!;
  }

  static ProtocolUseCase protocol() {
    _protocolUseCase ??= ProtocolUseCase();
    return _protocolUseCase!;
  }

  static LocalDataUseCase local() {
    _localDataUseCase ??= LocalDataUseCase();
    return _localDataUseCase!;
  }
}
