// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/constants/routes_const.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/user_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/user/user_view_model.dart';
import 'package:gisogs_greenspacesapp/domain/utils/shared_preferences.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/shimmer_loading/shimmer_general.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/shimmer_loading/shimmer_loader.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';

class AppBarUser extends StatelessWidget {
  const AppBarUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserViewModel>(
      converter: (store) => store.state.userAppBarState,
      distinct: true,
      onInit: (store) => store.state.userAppBarState.user.id != 0 ? null : store.dispatch(getUserData),
      onDidChange: (oldState, newState) {
        if (newState.isError == true && newState.errorMessage == GeneralErrors.userNotFound) {
          SharedStorageService.remove(PreferenceKey.userId);
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.auth, (route) => false);
        }
      },
      builder: (_, state) {
        bool successLoad = (state.isLoading == false && state.isError == false);

        return Shimmer(
          linearGradient: HelperUtils.getShimmerGradient(),
          child: ShimmerLoading(
            isLoading: !successLoad,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                successLoad
                    ? ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: const BorderRadius.all(Radius.circular(36)),
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: AppDecorations.noAvatar,
                        ),
                      )
                    : Container(
                        height: 36,
                        width: 36,
                        decoration: const BoxDecoration(color: AppColors.primaryDark, borderRadius: BorderRadius.all(Radius.circular(36))),
                      ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 170,
                      height: 20,
                      color: successLoad ? AppColors.transparent : AppColors.primaryDark,
                      child: Text(
                        '${state.user.surname} ${state.user.name} ${state.user.lastName}',
                        style: AppTextStyle.openSans14W500.apply(color: AppColors.primaryDark),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 170,
                      height: 20,
                      color: successLoad ? AppColors.transparent : AppColors.primaryDark,
                      child: Text(
                        state.user.department == '' ? 'Отдел не указан' : state.user.department,
                        style: AppTextStyle.openSans9W400.apply(color: AppColors.secondaryDark),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
