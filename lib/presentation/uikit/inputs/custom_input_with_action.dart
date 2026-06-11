// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class CustomActionInput extends StatelessWidget {
  final String label;
  final int maxLines;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isInvalid;
  final bool isProcessing;
  final bool? darkBorder;
  final bool secondCallback;
  final Function? resetError;
  final TextInputType? keyboardType;
  final VoidCallback callbcak;
  final VoidCallback callback2;

  const CustomActionInput({
    Key? key,
    required this.label,
    required this.maxLines,
    required this.controller,
    required this.isInvalid,
    required this.isProcessing,
    this.resetError,
    this.keyboardType,
    this.darkBorder,
    this.focusNode,
    required this.callbcak,
    required this.callback2,
    required this.secondCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: AppDecorations.input,
          child: TextFormField(
            keyboardType: keyboardType,
            textAlignVertical: TextAlignVertical.center,
            enabled: !isProcessing && !isInvalid,
            focusNode: focusNode,
            maxLines: maxLines,
            minLines: maxLines > 1 ? maxLines : null,
            controller: controller,
            showCursor: true,
            cursorColor: AppColors.primaryDark,
            onTap: () => isInvalid
                ? null
                : isProcessing
                    ? null
                    : resetError != null
                        ? resetError!.call()
                        : null,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(21.0, 10.0, 50.0, 10.0),
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
        ),
        Positioned(
          right: 0.0,
          child: Container(
            decoration: AppDecorations.inputAction,
            width: 45.0,
            height: 58,
            child: secondCallback
                ? InkwellButton(
                    function: callback2,
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: SvgPicture.asset(
                        AppIcons.deleteIcon,
                        width: 10,
                        height: 10,
                      ),
                    ),
                  )
                : InkwellButton(
                    function: callbcak,
                    child: const Icon(
                      Icons.search,
                      color: AppColors.primaryDark,
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
