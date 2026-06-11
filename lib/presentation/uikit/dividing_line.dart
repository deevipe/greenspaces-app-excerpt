// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';

class AppDividerLine extends StatelessWidget {
  const AppDividerLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - (AppConstraints.screenPadding * 2),
      height: 1,
      color: AppColors.dark100,
    );
  }
}
