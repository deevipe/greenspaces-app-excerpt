import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';

class ProjectScreenHeader extends StatelessWidget {
  final String title;
  final bool? hasError;
  final EdgeInsets? margin;
  const ProjectScreenHeader({super.key, required this.title, this.margin, this.hasError});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(top: 21.0, bottom: 10.0),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyle.openSans14W500.apply(color: hasError == true ? AppColors.red : AppColors.primaryDark),
      ),
    );
  }
}
