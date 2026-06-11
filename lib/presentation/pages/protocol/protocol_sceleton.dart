import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/bottom_nav_bar.dart';

class ProtocolSceletonScreen extends StatelessWidget {
  const ProtocolSceletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
        routes: const [
          ProtocolListRouter(),
          ProtocolFormRouter(),
        ],
        duration: const Duration(milliseconds: 1200),
        builder: (BuildContext context, Widget child, animation) {
          final TabsRouter tabsRouter = AutoTabsRouter.of(context);

          return Container(
            decoration: AppDecorations.boxShadowDecoration,
            child: Stack(
              children: [
                FadeTransition(
                  opacity: animation,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(bottom: 84.0),
                    color: AppColors.primaryLight,
                    child: child,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: AppConstraints.screenPadding,
                  child: AppBottomNavBar(
                    router: tabsRouter,
                  ),
                )
              ],
            ),
          );
        });
  }
}
