import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';

class ProcessUserAction {
  ProcessUserAction();
}

class GetUserSuccessAction {
  final User user;

  GetUserSuccessAction({
    required this.user,
  });
}

class UserErrorAction {
  final User user;
  final String errorMessage;

  UserErrorAction({
    required this.user,
    required this.errorMessage,
  });
}
