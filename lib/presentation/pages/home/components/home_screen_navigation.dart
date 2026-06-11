import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_list_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_list_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class HomeNavigationScreen extends StatelessWidget {
  const HomeNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 270.0,
                decoration: AppDecorations.boxShadowDecoration,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 80.0, left: AppConstraints.screenPadding, right: AppConstraints.screenPadding),
                padding: const EdgeInsets.symmetric(horizontal: 53.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppDictionary.protocolReestr,
                      style: AppTextStyle.openSans24W700.apply(color: AppColors.primaryDark),
                    ),
                    const SizedBox(
                      height: 57.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          InkwellButton(
                            function: () {
                              StoreProvider.of<AppState>(context).dispatch(SetRevisionProcess(value: false));
                              StoreProvider.of<AppState>(context).dispatch(getProtocolList(
                                completer: null,
                                revision: StoreProvider.of<AppState>(context).state.protocolListState.revision ?? false,
                                page: 1,
                              ));
                              context.pushRoute(const ProtocolRouter(children: [ProtocolListRouter()]));
                            },
                            child: SvgPicture.asset(
                              AppIcons.projectIcon,
                              width: 79.0,
                              height: 65.0,
                            ),
                          ),
                          const Text(
                            AppDictionary.project,
                            style: AppTextStyle.openSans14W400,
                          ),
                        ]),
                        Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          InkwellButton(
                            function: () {
                              StoreProvider.of<AppState>(context).dispatch(SetRevisionProcess(value: true));
                              StoreProvider.of<AppState>(context).dispatch(getProtocolList(
                                completer: null,
                                revision: StoreProvider.of<AppState>(context).state.protocolListState.revision ?? false,
                                page: 1,
                              ));
                              context.pushRoute(const ProtocolRouter(children: [ProtocolListRouter()]));
                            },
                            child: SvgPicture.asset(
                              AppIcons.improveProjectIcon,
                              width: 85.0,
                              height: 65.0,
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(8.0, 0.0),
                            child: const Text(
                              AppDictionary.revision,
                              style: AppTextStyle.openSans14W400,
                            ),
                          )
                        ]),
                      ],
                    ),
                    const SizedBox(height: 75.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
