// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';

class ErrorMessageText extends StatelessWidget {
  final String message;
  const ErrorMessageText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(message, style: AppTextStyle.roboto12W400.apply(color: AppColors.semiDimmedDark),);
  }
}
