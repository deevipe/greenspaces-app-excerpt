// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';

class CustomCheckBox extends StatelessWidget {
  final bool checked;
  final Function callback;
  final String label;
  final double? width;
  final bool? noLabel;

  const CustomCheckBox({
    Key? key,
    required this.callback,
    required this.checked,
    required this.label,
    this.width,
    this.noLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checkboxTheme = theme.checkboxTheme;
    final newCheckBoxTheme = checkboxTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );

    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width / 2,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: AppColors.checkboxBorder, checkboxTheme: newCheckBoxTheme),
        child: noLabel == true
            ? Checkbox(
                value: checked,
                onChanged: (value) => callback(),
                activeColor: AppColors.green,
                checkColor: AppColors.primaryLight,
              )
            : CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) => callback(),
                title: Transform.translate(
                  offset: const Offset(-15.0, 0),
                  child: Text(
                    label,
                    style: AppTextStyle.openSans14W500.apply(color: AppColors.primaryDark),
                  ),
                ),
                value: checked,
                activeColor: AppColors.green,
                checkColor: AppColors.primaryLight,
              ),
      ),
    );
  }
}
