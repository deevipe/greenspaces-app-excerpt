import 'package:auto_route/auto_route.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/domain/utils/shared_preferences.dart';

class CheckUserAuth extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final int? userId = SharedStorageService.getInt(PreferenceKey.userId);

    if (userId != null) {
      resolver.next(true);
    } else {
      // remove user's token and userId from system
      SharedStorageService.remove(PreferenceKey.userId);
      SharedStorageService.remove(PreferenceKey.userTokenId);
      router.push(const AuthRoute());
    }
  }
}
