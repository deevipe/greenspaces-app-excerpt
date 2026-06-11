import 'package:gisogs_greenspacesapp/data/dto/user_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';

class UserMapper {
  static User mapDTO(UserDTO userDTO) {
    final List<String> fioExploded = userDTO.fio?.split(' ') ?? [];
    return User(
      id: userDTO.id,
      name: fioExploded[1].isEmpty ? '' : fioExploded[1],
      surname: fioExploded[0].isEmpty ? '' : fioExploded[0],
      lastName: fioExploded[2].isEmpty ? '' : fioExploded[2],
      department: userDTO.department,
      token: userDTO.token,
    );
  }
}
