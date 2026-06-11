// Flutter imports:
import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';

// Project imports:


class ScreenHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  const ScreenHeader({Key? key, required this.title, required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 17.0),
      padding: const EdgeInsets.only(bottom: 14.27),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyle.openSans14W500.apply(color: AppColors.primaryDark),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            subTitle,
            style: AppTextStyle.openSans9W400.apply(color: AppColors.secondaryDark),
          ),
        ],
      ),
    );
  }
}
