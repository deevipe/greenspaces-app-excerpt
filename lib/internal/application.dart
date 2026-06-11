import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/router/home_route_guard.dart';
import 'package:gisogs_greenspacesapp/config/theme/theme.dart';
import 'package:gisogs_greenspacesapp/domain/utils/shared_preferences.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_reducer.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    final bool rememberMe = SharedStorageService.getBool(PreferenceKey.remeberMe) ?? true;
    final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
    if (userTokenId.isNotEmpty && !rememberMe) {
      await SharedStorageService.remove(PreferenceKey.userId);
      await SharedStorageService.remove(PreferenceKey.userTokenId);
    }
  }

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
    middleware: [thunkMiddleware, LoggingMiddleware.printer()],
  );

  final _appRouter = AppAutoRouter(checkUserAuth: CheckUserAuth());

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'ОГС. Порубочные билеты',
        locale: const Locale('ru', 'RU'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
        ],
        theme: AppTheme.lightTheme(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate: _appRouter.delegate(),
        builder: (BuildContext context, Widget? child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child!),
          maxWidth: 1280,
          minWidth: 480,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: MOBILE),
            ResponsiveBreakpoint.autoScale(1000, name: MOBILE),
            ResponsiveBreakpoint.resize(1200, name: MOBILE),
            ResponsiveBreakpoint.autoScale(2460, name: MOBILE),
          ],
        ),
      ),
    );
  }
}
