// Flutter imports:
import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';

// Project imports:

class AppDecorations {
  static const BoxDecoration authHeaderDecoration = BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(8),
      bottomLeft: Radius.circular(8),
    ),
    color: AppColors.primaryLight,
    boxShadow: [
      BoxShadow(
        blurRadius: 2,
        offset: Offset(0, 0),
        color: Color.fromRGBO(117, 131, 142, 0.04),
      ),
      BoxShadow(
        blurRadius: 8,
        offset: Offset(0, 4),
        color: Color.fromRGBO(52, 60, 68, 0.16),
      ),
    ],
  );

  static const BoxDecoration boxShadowDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    color: AppColors.primaryLight,
    boxShadow: [
      BoxShadow(
        blurRadius: 2,
        offset: Offset(0, 0),
        color: AppColors.shadow1,
      ),
      BoxShadow(
        blurRadius: 8,
        offset: Offset(0, 4),
        color: AppColors.shadow2,
      ),
    ],
  );

  static BoxDecoration transparentImageCover = BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    color: AppColors.primaryDark.withOpacity(.5),
  );

  static const BoxDecoration darkBoxShadowDecoration = BoxDecoration(
    color: AppColors.primaryDark,
    boxShadow: [
      BoxShadow(
        blurRadius: 2,
        offset: Offset(0, 0),
        color: AppColors.shadow1,
      ),
      BoxShadow(
        blurRadius: 8,
        offset: Offset(0, 4),
        color: AppColors.shadow2,
      ),
    ],
  );

  static const BoxDecoration doneIcon = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(33)),
      color: AppColors.white,
      border: Border(
        top: BorderSide(color: AppColors.green, width: 1.0),
        bottom: BorderSide(color: AppColors.green, width: 1.0),
        left: BorderSide(color: AppColors.green, width: 1.0),
        right: BorderSide(color: AppColors.green, width: 1.0),
      ));

  static const BoxDecoration floatingButton = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(45)),
    color: AppColors.primaryDark,
    border: Border(
      top: BorderSide(color: AppColors.dark400, width: 1.0),
      bottom: BorderSide(color: AppColors.dark400, width: 1.0),
      left: BorderSide(color: AppColors.dark400, width: 1.0),
      right: BorderSide(color: AppColors.dark400, width: 1.0),
    ),
    boxShadow: [
      BoxShadow(
        blurRadius: 2,
        offset: Offset(0, 0),
        color: AppColors.shadow1,
      ),
      BoxShadow(
        blurRadius: 8,
        offset: Offset(0, 4),
        color: AppColors.dark400,
      ),
    ],
  );

  static const BoxDecoration btnShadow = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        blurRadius: 2,
        offset: Offset(0, 0),
        color: AppColors.shadow1,
      ),
      BoxShadow(
        blurRadius: 8,
        offset: Offset(0, 4),
        color: AppColors.shadow2,
      ),
    ],
  );

  static const BoxDecoration roundBtnShadow = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    boxShadow: [
      BoxShadow(
        blurRadius: 2,
        offset: Offset(0, 0),
        color: AppColors.shadow1,
      ),
      BoxShadow(
        blurRadius: 8,
        offset: Offset(0, 4),
        color: AppColors.shadow2,
      ),
    ],
  );

  static const BoxDecoration oddRowDecoration = BoxDecoration(
    color: AppColors.lightBg,
    border: Border(
      top: BorderSide(color: AppColors.dimmedDark, width: 1),
      bottom: BorderSide(color: AppColors.dimmedDark, width: 1),
    ),
  );

  static const BoxDecoration oddObjectCellDecoration = BoxDecoration(
    color: AppColors.oddObjectCell,
  );

  static const BoxDecoration evenRowDecoration = BoxDecoration(
    color: AppColors.transparent,
    border: Border(
      top: BorderSide(color: AppColors.transparent, width: 1),
      bottom: BorderSide(color: AppColors.transparent, width: 1),
    ),
  );

  static const BoxDecoration evenObjectCellDecoration = BoxDecoration(
    color: AppColors.objectCell,
  );

  static const BoxDecoration dueOddRowDecoration = BoxDecoration(
    color: AppColors.redTableBg,
    border: Border(
      top: BorderSide(color: AppColors.dimmedDark, width: 1),
      bottom: BorderSide(color: AppColors.dimmedDark, width: 1),
    ),
  );

  static const BoxDecoration dueEvenRowDecoration = BoxDecoration(
    color: AppColors.redTableBg,
    border: Border(
      top: BorderSide(color: AppColors.transparent, width: 1),
      bottom: BorderSide(color: AppColors.transparent, width: 1),
    ),
  );

  static const BoxDecoration searchBarDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(24)),
    color: AppColors.primaryLight,
    border: Border(
      top: BorderSide(color: AppColors.inputBg, width: 1),
      bottom: BorderSide(color: AppColors.inputBg, width: 1),
      left: BorderSide(color: AppColors.inputBg, width: 1),
      right: BorderSide(color: AppColors.inputBg, width: 1),
    ),
  );

  static const BoxDecoration noAvatar = BoxDecoration(
    color: AppColors.transparent,
    border: Border(
      top: BorderSide(color: AppColors.red, width: 1.5),
      bottom: BorderSide(color: AppColors.red, width: 1.5),
      left: BorderSide(color: AppColors.red, width: 1.5),
      right: BorderSide(color: AppColors.red, width: 1.5),
    ),
    borderRadius: BorderRadius.all(Radius.circular(36.0)),
    boxShadow: [
      BoxShadow(
        blurRadius: 2,
        offset: Offset(0, 0),
        color: AppColors.shadow1,
      ),
      BoxShadow(
        blurRadius: 8,
        offset: Offset(0, 4),
        color: AppColors.shadow2,
      ),
    ],
  );

  static const BoxDecoration imageDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(color: AppColors.dimmedDark, width: 1),
      top: BorderSide(color: AppColors.dimmedDark, width: 1),
      left: BorderSide(color: AppColors.dimmedDark, width: 1),
      right: BorderSide(color: AppColors.dimmedDark, width: 1),
    ),
  );

  static const BoxDecoration input = BoxDecoration(
    color: AppColors.barsBg,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  );

  static const BoxDecoration inputAction = BoxDecoration(
    color: AppColors.barsBg,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    border: Border(
      bottom: BorderSide(color: AppColors.inputBg, width: 1),
      top: BorderSide(color: AppColors.inputBg, width: 1),
      left: BorderSide(color: AppColors.inputBg, width: 1),
      right: BorderSide(color: AppColors.inputBg, width: 1),
    ),
  );

  static const BoxDecoration select = BoxDecoration(
    color: AppColors.primaryLight,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    border: Border(
      bottom: BorderSide(color: AppColors.inputBg, width: 1),
      top: BorderSide(color: AppColors.inputBg, width: 1),
      left: BorderSide(color: AppColors.inputBg, width: 1),
      right: BorderSide(color: AppColors.inputBg, width: 1),
    ),
  );

  static const BoxDecoration selected = BoxDecoration(
    color: AppColors.primaryLight,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    border: Border(
      bottom: BorderSide(color: AppColors.green, width: 1),
      top: BorderSide(color: AppColors.green, width: 1),
      left: BorderSide(color: AppColors.green, width: 1),
      right: BorderSide(color: AppColors.green, width: 1),
    ),
  );

  static const BoxDecoration selectEmpty = BoxDecoration(
    color: AppColors.greyButton,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    border: Border(
      bottom: BorderSide(color: AppColors.inputBg, width: 1),
      top: BorderSide(color: AppColors.inputBg, width: 1),
      left: BorderSide(color: AppColors.inputBg, width: 1),
      right: BorderSide(color: AppColors.inputBg, width: 1),
    ),
  );

  static const BoxDecoration thumbnailPictures = BoxDecoration(
    color: AppColors.greyButton,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    border: Border(
      bottom: BorderSide(color: AppColors.red, width: 1),
      top: BorderSide(color: AppColors.red, width: 1),
      left: BorderSide(color: AppColors.red, width: 1),
      right: BorderSide(color: AppColors.red, width: 1),
    ),
  );

  static const BoxDecoration modalSheet = BoxDecoration(
    color: AppColors.primaryLight,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0),
    ),
    boxShadow: [
      BoxShadow(
        blurRadius: 2,
        offset: Offset(0, 0),
        color: AppColors.shadow1,
      ),
      BoxShadow(
        blurRadius: 8,
        offset: Offset(0, -4),
        color: AppColors.shadow2,
      ),
    ],
  );

  static const BoxDecoration modalSheetActions = BoxDecoration(
    color: AppColors.greyButton,
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
  );
}
