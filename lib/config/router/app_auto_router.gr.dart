// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i22;
import 'package:auto_route/empty_router_widgets.dart' as _i7;
import 'package:flutter/material.dart' as _i23;

import '../../presentation/pages/auth/auth_screen.dart' as _i1;
import '../../presentation/pages/home/components/home_screen_navigation.dart'
    as _i5;
import '../../presentation/pages/home/home_screen.dart' as _i2;
import '../../presentation/pages/media/custom_camera_screen.dart' as _i3;
import '../../presentation/pages/media/custom_media_gallery.dart' as _i4;
import '../../presentation/pages/protocol/general_info_step/protocol_general_info_screen.dart'
    as _i10;
import '../../presentation/pages/protocol/protocol_list_screen.dart' as _i9;
import '../../presentation/pages/protocol/protocol_map_screen.dart' as _i15;
import '../../presentation/pages/protocol/protocol_sceleton.dart' as _i6;
import '../../presentation/pages/protocol/steps/protocol_history_step.dart'
    as _i21;
import '../../presentation/pages/protocol/steps/protocol_media_files_screen.dart'
    as _i20;
import '../../presentation/pages/protocol/steps/protocol_media_screen.dart'
    as _i18;
import '../../presentation/pages/protocol/steps/protocol_object_form_screen.dart'
    as _i17;
import '../../presentation/pages/protocol/steps/protocol_object_type_screen.dart'
    as _i16;
import '../../presentation/pages/protocol/steps/protocol_objects_list_screen.dart'
    as _i19;
import '../../presentation/pages/protocol/steps/protocol_representatives_screen.dart'
    as _i13;
import '../../presentation/pages/protocol/steps/protocol_territory_screen.dart'
    as _i14;
import '../../presentation/pages/protocol/steps/protocol_work_category_screen.dart'
    as _i11;
import '../../presentation/pages/protocol/steps/protocol_work_conditions_screen.dart'
    as _i12;
import '../../presentation/uikit/hero_router_page.dart' as _i8;
import 'home_route_guard.dart' as _i24;

class AppAutoRouter extends _i22.RootStackRouter {
  AppAutoRouter({
    _i23.GlobalKey<_i23.NavigatorState>? navigatorKey,
    required this.checkUserAuth,
  }) : super(navigatorKey);

  final _i24.CheckUserAuth checkUserAuth;

  @override
  final Map<String, _i22.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.AuthScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
      );
    },
    CustomCameraRoute.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i3.CustomCameraScreen(),
        maintainState: false,
        transitionsBuilder: _i22.TransitionsBuilders.zoomIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AppMediaGalleryRoute.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i4.AppMediaGalleryScreen(),
        maintainState: false,
        transitionsBuilder: _i22.TransitionsBuilders.zoomIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    HomeNavigationRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.HomeNavigationScreen(),
      );
    },
    ProtocolRouter.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i6.ProtocolSceletonScreen(),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolListRouter.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.EmptyRouterPage(),
      );
    },
    ProtocolFormRouter.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.HeroEmptyRouterPage(),
        maintainState: false,
      );
    },
    ProtocolList.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i9.ProtocolListScreen(),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolFirstStepRoute.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i10.ProtocolFirstStepScreen(),
        maintainState: false,
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolCategoryRoute.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i11.ProtocolCategoryScreen(),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolConditionsRoute.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i12.ProtocolConditionsScreen(),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolRepresentativesRoute.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i13.ProtocolRepresentativesScreen(),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolTerritoryRoute.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i14.ProtocolTerritoryScreen(),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MapRoute.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<MapRouteArgs>(
          orElse: () => MapRouteArgs(
                  layerUrl: queryParams.getString(
                'layerUrl',
                'https://gis.toris.gov.spb.ru/arccod1031/rest/services/KB/14_ZNOP_WGS/MapServer',
              )));
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: _i15.MapScreen(
          key: args.key,
          layerUrl: args.layerUrl,
        ),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolGreenSpaceRoute.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<ProtocolGreenSpaceRouteArgs>(
          orElse: () => ProtocolGreenSpaceRouteArgs(
              address: queryParams.optString('address')));
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: _i16.ProtocolGreenSpaceScreen(
          key: args.key,
          address: args.address,
        ),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolTerritoryObjectDetailRoute.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<ProtocolTerritoryObjectDetailRouteArgs>(
          orElse: () => ProtocolTerritoryObjectDetailRouteArgs(
                objectTitle: queryParams.optString('objectTitle'),
                address: queryParams.optString('address'),
              ));
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: _i17.ProtocolTerritoryObjectDetailScreen(
          key: args.key,
          objectTitle: args.objectTitle,
          address: args.address,
        ),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolMediaStepRoute.name: (routeData) {
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<ProtocolMediaStepRouteArgs>(
          orElse: () => ProtocolMediaStepRouteArgs(
                subTitle: queryParams.optString('subTitle'),
                areaId: queryParams.optInt('areaId'),
              ));
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: _i18.ProtocolMediaStepScreen(
          key: args.key,
          subTitle: args.subTitle,
          areaId: args.areaId,
        ),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolObjectsListRoute.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i19.ProtocolObjectsListScreen(),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolMediaFilesRoute.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i20.ProtocolMediaFilesScreen(),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProtocolHistoryRoute.name: (routeData) {
      return _i22.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i21.ProtocolHistoryScreen(),
        transitionsBuilder: _i22.TransitionsBuilders.slideLeftWithFade,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i22.RouteConfig> get routes => [
        _i22.RouteConfig(
          AuthRoute.name,
          path: '/auth',
        ),
        _i22.RouteConfig(
          HomeRoute.name,
          path: '/',
          guards: [checkUserAuth],
          children: [
            _i22.RouteConfig(
              HomeNavigationRoute.name,
              path: '',
              parent: HomeRoute.name,
            ),
            _i22.RouteConfig(
              ProtocolRouter.name,
              path: 'protocol',
              parent: HomeRoute.name,
              children: [
                _i22.RouteConfig(
                  ProtocolListRouter.name,
                  path: 'list',
                  parent: ProtocolRouter.name,
                  children: [
                    _i22.RouteConfig(
                      ProtocolList.name,
                      path: '',
                      parent: ProtocolListRouter.name,
                    )
                  ],
                ),
                _i22.RouteConfig(
                  ProtocolFormRouter.name,
                  path: 'create',
                  parent: ProtocolRouter.name,
                  children: [
                    _i22.RouteConfig(
                      ProtocolFirstStepRoute.name,
                      path: '',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      ProtocolCategoryRoute.name,
                      path: 'category',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      ProtocolConditionsRoute.name,
                      path: 'conditions',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      ProtocolRepresentativesRoute.name,
                      path: 'representatives',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      ProtocolTerritoryRoute.name,
                      path: 'territory',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      MapRoute.name,
                      path: 'map',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      ProtocolGreenSpaceRoute.name,
                      path: 'object',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      ProtocolTerritoryObjectDetailRoute.name,
                      path: 'object/detail',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      ProtocolMediaStepRoute.name,
                      path: 'object/media',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      ProtocolObjectsListRoute.name,
                      path: 'object/list',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      ProtocolMediaFilesRoute.name,
                      path: 'object/files',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      ProtocolHistoryRoute.name,
                      path: 'object/history',
                      parent: ProtocolFormRouter.name,
                    ),
                    _i22.RouteConfig(
                      '*#redirect',
                      path: '*',
                      parent: ProtocolFormRouter.name,
                      redirectTo: '',
                      fullMatch: true,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        _i22.RouteConfig(
          CustomCameraRoute.name,
          path: '/camera',
        ),
        _i22.RouteConfig(
          AppMediaGalleryRoute.name,
          path: '/gallery',
        ),
      ];
}

/// generated route for
/// [_i1.AuthScreen]
class AuthRoute extends _i22.PageRouteInfo<void> {
  const AuthRoute()
      : super(
          AuthRoute.name,
          path: '/auth',
        );

  static const String name = 'AuthRoute';
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i22.PageRouteInfo<void> {
  const HomeRoute({List<_i22.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.CustomCameraScreen]
class CustomCameraRoute extends _i22.PageRouteInfo<void> {
  const CustomCameraRoute()
      : super(
          CustomCameraRoute.name,
          path: '/camera',
        );

  static const String name = 'CustomCameraRoute';
}

/// generated route for
/// [_i4.AppMediaGalleryScreen]
class AppMediaGalleryRoute extends _i22.PageRouteInfo<void> {
  const AppMediaGalleryRoute()
      : super(
          AppMediaGalleryRoute.name,
          path: '/gallery',
        );

  static const String name = 'AppMediaGalleryRoute';
}

/// generated route for
/// [_i5.HomeNavigationScreen]
class HomeNavigationRoute extends _i22.PageRouteInfo<void> {
  const HomeNavigationRoute()
      : super(
          HomeNavigationRoute.name,
          path: '',
        );

  static const String name = 'HomeNavigationRoute';
}

/// generated route for
/// [_i6.ProtocolSceletonScreen]
class ProtocolRouter extends _i22.PageRouteInfo<void> {
  const ProtocolRouter({List<_i22.PageRouteInfo>? children})
      : super(
          ProtocolRouter.name,
          path: 'protocol',
          initialChildren: children,
        );

  static const String name = 'ProtocolRouter';
}

/// generated route for
/// [_i7.EmptyRouterPage]
class ProtocolListRouter extends _i22.PageRouteInfo<void> {
  const ProtocolListRouter({List<_i22.PageRouteInfo>? children})
      : super(
          ProtocolListRouter.name,
          path: 'list',
          initialChildren: children,
        );

  static const String name = 'ProtocolListRouter';
}

/// generated route for
/// [_i8.HeroEmptyRouterPage]
class ProtocolFormRouter extends _i22.PageRouteInfo<void> {
  const ProtocolFormRouter({List<_i22.PageRouteInfo>? children})
      : super(
          ProtocolFormRouter.name,
          path: 'create',
          initialChildren: children,
        );

  static const String name = 'ProtocolFormRouter';
}

/// generated route for
/// [_i9.ProtocolListScreen]
class ProtocolList extends _i22.PageRouteInfo<void> {
  const ProtocolList()
      : super(
          ProtocolList.name,
          path: '',
        );

  static const String name = 'ProtocolList';
}

/// generated route for
/// [_i10.ProtocolFirstStepScreen]
class ProtocolFirstStepRoute extends _i22.PageRouteInfo<void> {
  const ProtocolFirstStepRoute()
      : super(
          ProtocolFirstStepRoute.name,
          path: '',
        );

  static const String name = 'ProtocolFirstStepRoute';
}

/// generated route for
/// [_i11.ProtocolCategoryScreen]
class ProtocolCategoryRoute extends _i22.PageRouteInfo<void> {
  const ProtocolCategoryRoute()
      : super(
          ProtocolCategoryRoute.name,
          path: 'category',
        );

  static const String name = 'ProtocolCategoryRoute';
}

/// generated route for
/// [_i12.ProtocolConditionsScreen]
class ProtocolConditionsRoute extends _i22.PageRouteInfo<void> {
  const ProtocolConditionsRoute()
      : super(
          ProtocolConditionsRoute.name,
          path: 'conditions',
        );

  static const String name = 'ProtocolConditionsRoute';
}

/// generated route for
/// [_i13.ProtocolRepresentativesScreen]
class ProtocolRepresentativesRoute extends _i22.PageRouteInfo<void> {
  const ProtocolRepresentativesRoute()
      : super(
          ProtocolRepresentativesRoute.name,
          path: 'representatives',
        );

  static const String name = 'ProtocolRepresentativesRoute';
}

/// generated route for
/// [_i14.ProtocolTerritoryScreen]
class ProtocolTerritoryRoute extends _i22.PageRouteInfo<void> {
  const ProtocolTerritoryRoute()
      : super(
          ProtocolTerritoryRoute.name,
          path: 'territory',
        );

  static const String name = 'ProtocolTerritoryRoute';
}

/// generated route for
/// [_i15.MapScreen]
class MapRoute extends _i22.PageRouteInfo<MapRouteArgs> {
  MapRoute({
    _i23.Key? key,
    String layerUrl =
        'https://gis.toris.gov.spb.ru/arccod1031/rest/services/KB/14_ZNOP_WGS/MapServer',
  }) : super(
          MapRoute.name,
          path: 'map',
          args: MapRouteArgs(
            key: key,
            layerUrl: layerUrl,
          ),
          rawQueryParams: {'layerUrl': layerUrl},
        );

  static const String name = 'MapRoute';
}

class MapRouteArgs {
  const MapRouteArgs({
    this.key,
    this.layerUrl =
        'https://gis.toris.gov.spb.ru/arccod1031/rest/services/KB/14_ZNOP_WGS/MapServer',
  });

  final _i23.Key? key;

  final String layerUrl;

  @override
  String toString() {
    return 'MapRouteArgs{key: $key, layerUrl: $layerUrl}';
  }
}

/// generated route for
/// [_i16.ProtocolGreenSpaceScreen]
class ProtocolGreenSpaceRoute
    extends _i22.PageRouteInfo<ProtocolGreenSpaceRouteArgs> {
  ProtocolGreenSpaceRoute({
    _i23.Key? key,
    required String? address,
  }) : super(
          ProtocolGreenSpaceRoute.name,
          path: 'object',
          args: ProtocolGreenSpaceRouteArgs(
            key: key,
            address: address,
          ),
          rawQueryParams: {'address': address},
        );

  static const String name = 'ProtocolGreenSpaceRoute';
}

class ProtocolGreenSpaceRouteArgs {
  const ProtocolGreenSpaceRouteArgs({
    this.key,
    required this.address,
  });

  final _i23.Key? key;

  final String? address;

  @override
  String toString() {
    return 'ProtocolGreenSpaceRouteArgs{key: $key, address: $address}';
  }
}

/// generated route for
/// [_i17.ProtocolTerritoryObjectDetailScreen]
class ProtocolTerritoryObjectDetailRoute
    extends _i22.PageRouteInfo<ProtocolTerritoryObjectDetailRouteArgs> {
  ProtocolTerritoryObjectDetailRoute({
    _i23.Key? key,
    required String? objectTitle,
    String? address,
  }) : super(
          ProtocolTerritoryObjectDetailRoute.name,
          path: 'object/detail',
          args: ProtocolTerritoryObjectDetailRouteArgs(
            key: key,
            objectTitle: objectTitle,
            address: address,
          ),
          rawQueryParams: {
            'objectTitle': objectTitle,
            'address': address,
          },
        );

  static const String name = 'ProtocolTerritoryObjectDetailRoute';
}

class ProtocolTerritoryObjectDetailRouteArgs {
  const ProtocolTerritoryObjectDetailRouteArgs({
    this.key,
    required this.objectTitle,
    this.address,
  });

  final _i23.Key? key;

  final String? objectTitle;

  final String? address;

  @override
  String toString() {
    return 'ProtocolTerritoryObjectDetailRouteArgs{key: $key, objectTitle: $objectTitle, address: $address}';
  }
}

/// generated route for
/// [_i18.ProtocolMediaStepScreen]
class ProtocolMediaStepRoute
    extends _i22.PageRouteInfo<ProtocolMediaStepRouteArgs> {
  ProtocolMediaStepRoute({
    _i23.Key? key,
    String? subTitle,
    int? areaId,
  }) : super(
          ProtocolMediaStepRoute.name,
          path: 'object/media',
          args: ProtocolMediaStepRouteArgs(
            key: key,
            subTitle: subTitle,
            areaId: areaId,
          ),
          rawQueryParams: {
            'subTitle': subTitle,
            'areaId': areaId,
          },
        );

  static const String name = 'ProtocolMediaStepRoute';
}

class ProtocolMediaStepRouteArgs {
  const ProtocolMediaStepRouteArgs({
    this.key,
    this.subTitle,
    this.areaId,
  });

  final _i23.Key? key;

  final String? subTitle;

  final int? areaId;

  @override
  String toString() {
    return 'ProtocolMediaStepRouteArgs{key: $key, subTitle: $subTitle, areaId: $areaId}';
  }
}

/// generated route for
/// [_i19.ProtocolObjectsListScreen]
class ProtocolObjectsListRoute extends _i22.PageRouteInfo<void> {
  const ProtocolObjectsListRoute()
      : super(
          ProtocolObjectsListRoute.name,
          path: 'object/list',
        );

  static const String name = 'ProtocolObjectsListRoute';
}

/// generated route for
/// [_i20.ProtocolMediaFilesScreen]
class ProtocolMediaFilesRoute extends _i22.PageRouteInfo<void> {
  const ProtocolMediaFilesRoute()
      : super(
          ProtocolMediaFilesRoute.name,
          path: 'object/files',
        );

  static const String name = 'ProtocolMediaFilesRoute';
}

/// generated route for
/// [_i21.ProtocolHistoryScreen]
class ProtocolHistoryRoute extends _i22.PageRouteInfo<void> {
  const ProtocolHistoryRoute()
      : super(
          ProtocolHistoryRoute.name,
          path: 'object/history',
        );

  static const String name = 'ProtocolHistoryRoute';
}
