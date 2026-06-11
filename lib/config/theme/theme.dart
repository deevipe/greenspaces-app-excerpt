// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';


class AppTheme {
  static ThemeData lightTheme() => ThemeData(
      canvasColor: AppColors.white,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryLight,
        onPrimary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        onSecondary: AppColors.primaryLight,
        error: AppColors.red,
        onError: AppColors.primaryLight,
        background: AppColors.white,
        onBackground: AppColors.black,
        surface: AppColors.white,
        onSurface: AppColors.dimmedDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryLight,
        centerTitle: true,
        titleTextStyle: AppTextStyle.openSans14W500.apply(color: AppColors.primaryDark),
        iconTheme: const IconThemeData(color: AppColors.primaryDark, size: 12),
        actionsIconTheme: const IconThemeData(color: AppColors.primaryDark),
        shadowColor: AppColors.primaryDark.withOpacity(.1),
      ),
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: AppTextStyle.openSans14W500,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
      ),
      tabBarTheme: const TabBarTheme(
        unselectedLabelColor: AppColors.primaryDark,
        unselectedLabelStyle: AppTextStyle.openSans14W500,
        labelStyle: AppTextStyle.openSans14W500,
        labelColor: AppColors.primaryBlue,
      ),
      textButtonTheme: TextButtonThemeData(style: ButtonStyle(foregroundColor: MaterialStateProperty.all(AppColors.primaryDark))),
      inputDecorationTheme: const InputDecorationTheme(floatingLabelStyle: TextStyle(color: AppColors.transparent)));

  static ThemeData darkTheme() => ThemeData();
}
