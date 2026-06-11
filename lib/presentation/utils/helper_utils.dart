// ignore_for_file: depend_on_referenced_packages

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/routes_const.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/utils/shared_preferences.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/app_navigation_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_save_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/text_link.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';
import 'package:intl/intl.dart';
import 'package:open_settings/open_settings.dart';

class HelperUtils {
  static void showErrorMessage({required BuildContext context, required String message, bool? openSettings}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppIcons.exclamationCircle,
                  color: AppColors.primaryLight,
                  width: 20,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - AppConstraints.screenPadding * 2 - 68,
                  child: Text(
                    message,
                    style: AppTextStyle.openSans12W400,
                  ),
                ),
              ],
            ),
            if (openSettings == true)
              TextLink(
                color: AppColors.primaryLight,
                label: AppDictionary.openSetting,
                callback: () => OpenSettings.openAppSetting(),
              )
          ],
        ),
        duration: const Duration(seconds: 4), // by timeout time?
      ),
    );
  }

  static void showLoadingDataMessage({required BuildContext context, required String message, bool? error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                style: AppTextStyle.openSans12W400,
              ),
              const SizedBox(
                width: 15,
              ),
              (error == true)
                  ? Container()
                  : const Loader(
                      size: 20,
                      color: AppColors.primaryLight,
                    )
            ],
          ),
        ),
        duration: Duration(seconds: (error == true) ? 5 : 90), // by timeout time?
      ),
    );
  }

  static Future<void> needAuthAction({required BuildContext context}) async {
    await SharedStorageService.remove(PreferenceKey.userId);
    await SharedStorageService.remove(PreferenceKey.userTokenId);
    // ignore: use_build_context_synchronously
    StoreProvider.of<AppState>(context).dispatch(UpdateAppNavigation(formIsOpen: false));
    // ignore: use_build_context_synchronously
    context.router.pushAndPopUntil(
      const AuthRoute(),
      predicate: (Route<dynamic> route) {
        return false;
      },
    );
  }

  static dynamic showLogoutDialog({required BuildContext context}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        AppDictionary.cancelLogout,
        style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        AppDictionary.acceptLogout,
        style: AppTextStyle.openSans12W400.apply(color: AppColors.secondaryDark),
      ),
      onPressed: () async {
        // Not awaiting for service to remove data
        SharedStorageService.remove(PreferenceKey.userId);
        SharedStorageService.remove(PreferenceKey.userTokenId);
        StoreProvider.of<AppState>(context).dispatch(UpdateAppNavigation(formIsOpen: false));
        context.router.pushAndPopUntil(
          const AuthRoute(),
          predicate: (Route<dynamic> route) {
            return false;
          },
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(AppDictionary.confirmTitle),
      content: const Text(AppDictionary.confirmText),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static dynamic showWarningDialog({required BuildContext context}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        BtnLabel.cancel,
        style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        BtnLabel.confirm,
        style: AppTextStyle.openSans12W400.apply(color: AppColors.secondaryDark),
      ),
      onPressed: () {
        StoreProvider.of<AppState>(context).dispatch(UpdateAppNavigation(formIsOpen: false));
        StoreProvider.of<AppState>(context).dispatch(resetAllFormSteps());
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(AppDictionary.confirmTitle),
      content: const Text('Все несохранненные данные будут потеряны при закрытии формы. Вы уверены, что хотите продолжить?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static LinearGradient getShimmerGradient() {
    return const LinearGradient(
      colors: [
        Color(0xFFEBEBF4),
        Color(0xFFF4F4F4),
        Color(0xFFEBEBF4),
      ],
      stops: [
        0.1,
        0.3,
        0.4,
      ],
      begin: Alignment(-1.0, -0.3),
      end: Alignment(1.0, 0.3),
      tileMode: TileMode.clamp,
    );
  }

  static String convertToHumanDate(bool fromString, dynamic date) {
    String? formattedDateTo = '';
    DateTime? convertedDate;
    if (fromString) {
      convertedDate = DateTime.tryParse(date);
    }

    formattedDateTo = DateFormat("dd MMMM y", "ru").format(convertedDate ?? date);

    return formattedDateTo;
  }

  static String convertDateToString(DateTime? date) {
    if (date != null) {
      String formattedDate = DateFormat("dd.MM.y", "ru").format(date);
      return formattedDate;
    } else {
      return 'н/д';
    }
  }

  static bool isRowStart({required int index}) {
    bool res = false;

    if (index != 0) {
      res = ((index) % 3 == 0);
    } else {
      res = true;
    }

    return res;
  }

  static bool isRowEnd({required int index}) {
    bool res = false;

    if (index != 2) {
      res = ((index + 1) % 3 == 0);
    } else {
      res = true;
    }

    return res;
  }

  static Map<String, dynamic> convertAdditionalParamValues({required Map<String, dynamic> inputMapValues}) {
    Map<String, dynamic> additionalParams = {};
    inputMapValues.forEach((key, value) {
      if (value is TextEditingController) {
        additionalParams[key] = value.text;
      } else if (value is ValueNotifier) {
        if (value.value is String) {
          additionalParams[key] = value.value.split('_').first;
        } else {
          additionalParams[key] = value.value;
        }
      } else {
        additionalParams[key] = value;
      }
    });
    return additionalParams;
  }

  static String parseSelectedValueId({required ValueNotifier<String?> notifier}) {
    String selectedId = '';
    if (notifier.value != null && notifier.value != '') {
      selectedId = notifier.value!.split('_').first;
    }

    return selectedId;
  }

  static String parseNotifierValueTitle({required String? savedValue}) {
    String selectedId = '';
    if (savedValue != null && savedValue != '') {
      selectedId = savedValue.split('_').last;
    }

    return selectedId;
  }

  static bool hideAppBarBackButton({required String currentPath}) {
    debugPrint('CURRENT  PATH: $currentPath');
    const List<String> exludedPaths = [
      '/${Routes.protocol}/${Routes.protocolForm}/${Routes.protocolFormObjectsList}',
    ];

    return exludedPaths.contains(currentPath);
  }

  static List<SelectObject> generateDiameters() {
    List<SelectObject> diameters = [];

    int diameter = 2;
    while (diameter <= 152) {
      diameters.add(SelectObject(id: diameter.toString(), title: '$diameter'));
      if (diameter < 8) {
        diameter += 2;
      } else {
        diameter += 4;
      }
    }

    return diameters;
  }

  static bool compareQueues(List<UploadingModel> a, List<UploadingModel> b) {
    bool res = true;
    if (a.length != b.length) {
      res = false;
    } else {
      for (int i = 0; i < a.length; i++) {
        if (a[i] != b[i]) {
          res = false;
        }
      }
    }
    return res;
  }
}
