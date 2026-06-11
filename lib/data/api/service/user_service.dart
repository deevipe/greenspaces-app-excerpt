import 'package:dio/dio.dart';
import 'package:gisogs_greenspacesapp/config/dio_settings.dart';
import 'package:gisogs_greenspacesapp/config/exceptions.dart';
import 'package:gisogs_greenspacesapp/data/api/request/login_body.dart';
import 'package:gisogs_greenspacesapp/data/dto/user_dto.dart';

class UserService {
  final Dio _dio;

  UserService({
    Dio? dio,
  }) : _dio = dio ?? DioSettings.createDio();

  Future<UserDTO?> auth(GetLoginBody body) async {
    UserDTO? result;
    try {
      Response response = await _dio.post(
        '/mwp/login',
        queryParameters: body.toApi(),
      );

      if (DioHandler.checkResponse(response)) {
        if (response.data != null) {
          try {
            result = UserDTO.fromJson(response.data);
          } catch (e) {
            throw ParseException();
          }
        }
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
