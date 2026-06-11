import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';

class CustomChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Function onTap;
  const CustomChipButton({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkwellButton(
      function: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 37.0),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border(
            bottom: BorderSide(color: selected ? AppColors.green : AppColors.primaryDark, width: 1),
            top: BorderSide(color: selected ? AppColors.green : AppColors.primaryDark, width: 1),
            left: BorderSide(color: selected ? AppColors.green : AppColors.primaryDark, width: 1),
            right: BorderSide(color: selected ? AppColors.green : AppColors.primaryDark, width: 1),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.roboto14W500.apply(
            color: selected ? AppColors.green : AppColors.primaryDark,
          ),
          // overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
