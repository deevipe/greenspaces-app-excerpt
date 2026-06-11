// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';

class AppRoundedButton extends StatelessWidget {
  final Function handler;
  final Color color;
  final TextStyle labelStyle;
  final String label;
  final bool isProcessing;
  final bool? disabled;
  final Color? loaderColor;
  final Widget? icon;
  const AppRoundedButton({
    Key? key,
    required this.color,
    required this.labelStyle,
    required this.label,
    required this.handler,
    required this.isProcessing,
    this.loaderColor,
    this.icon,
    this.disabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.btnShadow,
      height: 44.0,
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: disabled == true
              ? !isProcessing
                  ? AppColors.greyButton
                  : color
              : color,
          side: BorderSide(
            color: disabled == true
                ? !isProcessing
                    ? AppColors.greyButton
                    : AppColors.green
                : AppColors.green,
          ),
        ),
        onPressed: () => disabled == true ? null : handler(),
        child: isProcessing
            ? Loader(
                color: loaderColor ?? AppColors.primaryLight,
              )
            : icon != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        label,
                        style: disabled == true ? labelStyle.copyWith(color: AppColors.primaryLight) : labelStyle,
                      )
                    ],
                  )
                : Text(
                    label,
                    style: disabled == true ? labelStyle.copyWith(color: AppColors.primaryLight) : labelStyle,
                  ),
      ),
    );
  }
}
