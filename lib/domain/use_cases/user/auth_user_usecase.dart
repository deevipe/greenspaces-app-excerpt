import 'package:gisogs_greenspacesapp/domain/entity/login/login_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';
import 'package:gisogs_greenspacesapp/data/api/service/hive_service.dart';
import 'package:gisogs_greenspacesapp/domain/utils/shared_preferences.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/repository_module.dart';

class AuthUserUseCase {
  Future<User?> logIn({required String login, required String password}) async {
    User? userData;
    try {
      userData = await RepositoryModule.userRepository().authUser(login: Login(username: login, password: password));

      if (userData != null) {
        /// Добавим данные о пользователе в локальное хранилище для уменьшения
        /// кол-ва запросов (в перспективе) + сохраним в SharedPreferences данные
        /// об id пользователя. По нему мы будем ориентироваться залогинен ли
        /// пользователь
        await SharedStorageService.setInt(PreferenceKey.userId, userData.id);
        await SharedStorageService.setString(PreferenceKey.userTokenId, userData.token);
        await HiveService.addUser(data: userData);
      }
      return userData;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> logOut() async {
    try {
      await SharedStorageService.remove(PreferenceKey.userId);
      await SharedStorageService.remove(PreferenceKey.userTokenId);
      await HiveService.clearUser();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> toggleRememberMe({required bool value}) async {
    try {
      await SharedStorageService.setBool(PreferenceKey.remeberMe, value);
    } catch (_) {
      rethrow;
    }
  }

  Future<bool?> getRemeberMeValue() async {
    try {
      return SharedStorageService.getBool(PreferenceKey.remeberMe);
    } catch (_) {
      rethrow;
    }
  }
}
