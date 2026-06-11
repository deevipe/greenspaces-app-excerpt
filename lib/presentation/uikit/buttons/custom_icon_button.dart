// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';

class AppIconButton extends StatelessWidget {
  final Function handler;
  final Color color;
  final bool? disabled;
  final Color? loaderColor;
  final double? padding;
  final bool? round;
  final Widget icon;
  const AppIconButton({
    Key? key,
    required this.color,
    required this.handler,
    this.loaderColor,
    required this.icon,
    this.disabled,
    this.padding,
    this.round,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          shape: round == true ? const CircleBorder() : null,
          // foregroundColor: disabled == true ? AppColors.greyButton : color,
          backgroundColor: disabled == true ? AppColors.greyButton : color,
          side: const BorderSide(
            color: AppColors.transparent,
          ),
          padding: EdgeInsets.all(padding ?? 12.0)),
      onPressed: () => disabled == true ? null : handler(),
      child: icon,
    );
  }
}
