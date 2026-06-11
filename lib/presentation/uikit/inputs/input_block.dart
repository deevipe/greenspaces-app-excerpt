// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_datepicker_input.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_input.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_password_input.dart';

class InputBlock extends StatelessWidget {
  final String label;
  final String errorMessage;
  final bool isPassword;
  final bool isError;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function resetError;
  final bool isProcessing;
  final int? maxLines;
  final bool? datePicker;
  final bool? darkBorder;
  final TextInputType? keyboardType;
  final bool? removeErrorBlock;
  final CrossAxisAlignment? errorAlignment;
  final List<TextInputFormatter>? formatters;

  const InputBlock({
    Key? key,
    required this.label,
    required this.isError,
    required this.isPassword,
    required this.errorMessage,
    required this.controller,
    required this.resetError,
    required this.isProcessing,
    this.maxLines,
    this.keyboardType,
    this.datePicker,
    this.removeErrorBlock,
    this.darkBorder,
    this.errorAlignment,
    this.formatters, this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return removeErrorBlock == true
        ? isPassword
            ? CustomPasswordInput(
                label: label,
                isInvalid: isError,
                resetError: resetError,
                maxLines: 1,
                controller: controller,
                isProcessing: isProcessing,
                darkBorder: darkBorder,
              )
            : datePicker == true
                ? CustomDateTimePicker(
                    controller: controller,
                    isProcessing: isProcessing,
                    label: label,
                  )
                : CustomInput(
                    controller: controller,
                    label: label,
                    maxLines: maxLines ?? 1,
                    keyboardType: keyboardType,
                    isInvalid: isError,
                    resetError: resetError,
                    isProcessing: isProcessing,
                    darkBorder: darkBorder,
                    formatters: formatters,
                    focusNode: focusNode,
                  )
        : Column(
            crossAxisAlignment: errorAlignment ?? CrossAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: isError ? 1 : 0,
                duration: const Duration(milliseconds: 800),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text(
                    errorMessage,
                    style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
                  ),
                ),
              ),
              isPassword
                  ? CustomPasswordInput(
                      label: label,
                      isInvalid: isError,
                      resetError: resetError,
                      maxLines: 1,
                      controller: controller,
                      isProcessing: isProcessing,
                      darkBorder: darkBorder,
                    )
                  : datePicker == true
                      ? CustomDateTimePicker(
                          controller: controller,
                          isProcessing: isProcessing,
                          label: label,
                        )
                      : CustomInput(
                          controller: controller,
                          label: label,
                          maxLines: maxLines ?? 1,
                          keyboardType: keyboardType,
                          isInvalid: isError,
                          resetError: resetError,
                          isProcessing: isProcessing,
                          darkBorder: darkBorder,
                          formatters: formatters,
                          focusNode: focusNode
                        )
            ],
          );
  }
}
