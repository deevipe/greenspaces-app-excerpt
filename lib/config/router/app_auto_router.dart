import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';

import 'package:gisogs_greenspacesapp/config/constants/routes_const.dart';
import 'package:gisogs_greenspacesapp/config/router/home_route_guard.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/auth/auth_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/home/components/home_screen_navigation.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/home/home_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/media/custom_camera_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/media/custom_media_gallery.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/protocol_list_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/protocol_map_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/protocol_sceleton.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/general_info_step/protocol_general_info_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/steps/protocol_history_step.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/steps/protocol_media_files_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/steps/protocol_media_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/steps/protocol_object_form_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/steps/protocol_object_type_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/steps/protocol_objects_list_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/steps/protocol_representatives_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/steps/protocol_territory_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/steps/protocol_work_category_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/steps/protocol_work_conditions_screen.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/hero_router_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(path: Routes.auth, page: AuthScreen),
    AutoRoute(
      path: Routes.home,
      guards: [CheckUserAuth],
      page: HomeScreen,
      children: [
        AutoRoute(path: Routes.tabDefault, page: HomeNavigationScreen),
        CustomRoute(
          name: 'ProtocolRouter',
          path: Routes.protocol,
          page: ProtocolSceletonScreen,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
          children: [
            AutoRoute(
              path: Routes.tabNested,
              page: EmptyRouterPage,
              name: 'ProtocolListRouter',
              // transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
              children: [
                CustomRoute(
                  name: 'ProtocolList',
                  path: Routes.tabDefault,
                  page: ProtocolListScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
              ],
            ),
            AutoRoute(
              path: Routes.protocolForm,
              page: HeroEmptyRouterPage,
              name: 'ProtocolFormRouter',
              maintainState: false,
              // transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
              children: [
                CustomRoute(
                  path: Routes.tabDefault,
                  page: ProtocolFirstStepScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                  maintainState: false,
                ),
                CustomRoute(
                  path: Routes.protocolFormCategory,
                  page: ProtocolCategoryScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                CustomRoute(
                  path: Routes.protocolFormConditions,
                  page: ProtocolConditionsScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                CustomRoute(
                  path: Routes.protocolFormRepresentatives,
                  page: ProtocolRepresentativesScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                CustomRoute(
                  path: Routes.protocolFormTerritory,
                  page: ProtocolTerritoryScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                CustomRoute(
                  path: Routes.protocolFormMap,
                  page: MapScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                CustomRoute(
                  path: Routes.protocolFormObject,
                  page: ProtocolGreenSpaceScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                CustomRoute(
                  path: Routes.protocolFormObjectDetail,
                  page: ProtocolTerritoryObjectDetailScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                CustomRoute(
                  path: Routes.protocolFormObjectMedia,
                  page: ProtocolMediaStepScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                CustomRoute(
                  path: Routes.protocolFormObjectsList,
                  page: ProtocolObjectsListScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                CustomRoute(
                  path: Routes.protocolFormFiles,
                  page: ProtocolMediaFilesScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                CustomRoute(
                  path: Routes.protocolFormHistory,
                  page: ProtocolHistoryScreen,
                  transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
                ),
                RedirectRoute(path: '*', redirectTo: Routes.tabDefault),
              ],
            ),
            // RedirectRoute(path: '*', redirectTo: Routes.tabDefault),
          ],
        ),
        // RedirectRoute(path: '*', redirectTo: Routes.tabDefault),
      ],
    ),
    CustomRoute(
      path: Routes.camera,
      page: CustomCameraScreen,
      transitionsBuilder: TransitionsBuilders.zoomIn,
      maintainState: false,
    ),
    CustomRoute(
      path: Routes.gallery,
      page: AppMediaGalleryScreen,
      transitionsBuilder: TransitionsBuilders.zoomIn,
      maintainState: false,
    ),
  ],
)
class $AppAutoRouter {}
