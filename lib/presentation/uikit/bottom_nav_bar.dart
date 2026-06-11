import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/app_navigation_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_save_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/app_navigation_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class AppBottomNavBar extends StatelessWidget {
  final TabsRouter router;
  const AppBottomNavBar({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      StoreProvider.of<AppState>(context).dispatch(resetAllFormSteps());
      return Navigator.canPop(context);
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: StoreConnector<AppState, AppNavigationViewModel>(
          converter: (store) => store.state.appNavState,
          onWillChange: (oldState, state) {
            if (oldState?.formIsOpen != state.formIsOpen && state.formIsOpen == false) {
              context.tabsRouter.setActiveIndex(0);
            }
          },
          distinct: true,
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width - 34, // за вычетом всех padding & margin
              height: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding * 2, vertical: 3.0),
              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 20.0),
              decoration: AppDecorations.boxShadowDecoration.copyWith(color: AppColors.barsBg),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () => router.activeIndex == 1 ? HelperUtils.showWarningDialog(context: context) : null,
                          child: Container(
                            color: AppColors.transparent,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.homeIcon,
                                  width: 20,
                                  height: 20,
                                  color: router.activeIndex == 0 ? AppColors.green : AppColors.primaryDark,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  BottomNavigationTitle.home,
                                  style: AppTextStyle.openSans12W500.apply(color: router.activeIndex == 0 ? AppColors.green : AppColors.primaryDark),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            StoreProvider.of<AppState>(context).dispatch(UpdateAppNavigation(formIsOpen: true));
                            router.setActiveIndex(1);
                            
                          },
                          child: (router.activeIndex == 1 || StoreProvider.of<AppState>(context).state.protocolListState.revision == true)
                              ? const SizedBox.shrink()
                              : Container(
                                  height: 50,
                                  color: AppColors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      StoreProvider.of<AppState>(context).state.protocolGeneralStepState.revision == true
                                          ? Icon(
                                              Icons.copy_sharp,
                                              color: router.activeIndex == 1 ? AppColors.green : AppColors.primaryDark,
                                            )
                                          : SvgPicture.asset(
                                              AppIcons.plusIcon,
                                              width: 20,
                                              height: 20,
                                              color: router.activeIndex == 1 ? AppColors.green : AppColors.primaryDark,
                                            ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        StoreProvider.of<AppState>(context).state.protocolGeneralStepState.revision == true
                                            ? BottomNavigationTitle.editProtocol
                                            : BottomNavigationTitle.addProtocol,
                                        style: AppTextStyle.openSans12W500.apply(color: router.activeIndex == 1 ? AppColors.green : AppColors.primaryDark),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
