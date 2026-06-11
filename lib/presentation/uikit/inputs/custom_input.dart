// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final int maxLines;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isInvalid;
  final bool isProcessing;
  final bool? darkBorder;
  final Function? resetError;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;

  const CustomInput({
    Key? key,
    required this.label,
    required this.maxLines,
    required this.controller,
    required this.isInvalid,
    required this.isProcessing,
    this.resetError,
    this.keyboardType,
    this.darkBorder,
    this.focusNode, this.formatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.input,
      child: TextFormField(
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.top,
        enabled: !isProcessing,
        focusNode: focusNode,
        maxLines: maxLines,
        minLines: maxLines > 1 ? maxLines : null,
        controller: controller,
        showCursor: true,
        cursorColor: AppColors.primaryDark,
        onTap: () => resetError != null ? resetError!.call() : null,
        inputFormatters: formatters,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
          labelText: label,
          labelStyle: AppTextStyle.openSans14W400.apply(color: AppColors.primaryDark),
          alignLabelWithHint: true,
          floatingLabelStyle: AppTextStyle.openSans14W400.apply(color: AppColors.primaryDark),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: isInvalid ? const BorderSide(color: AppColors.red, width: 1) : const BorderSide(color: AppColors.primaryDark, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(color: darkBorder == true ? AppColors.primaryDark : AppColors.inputBg, width: 1)),
          focusColor: Theme.of(context).colorScheme.primary,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(color: darkBorder == true ? AppColors.primaryDark : AppColors.inputBg, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(color: AppColors.red, width: 1),
          ),
        ),
      ),
    );
  }
}
