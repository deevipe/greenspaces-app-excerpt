import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_datepicker_input.dart';

class CalendarRowInput extends StatelessWidget {
  final TextEditingController controller;
  final bool hasError;
  const CalendarRowInput({Key? key, required this.controller, required this.hasError}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            AppDictionary.protocolDateLabel,
            style: AppTextStyle.openSans14W500.apply(color: hasError ? AppColors.red : AppColors.dark400),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 3,
          child: CustomDateTimePicker(
            controller: controller,
            label: AppDictionary.pickDate,
            isProcessing: false,
          ),
        )
      ],
    );
  }
}
