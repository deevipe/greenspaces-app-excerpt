// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class CustomPasswordInput extends StatefulWidget {
  final String label;
  final int maxLines;
  final TextEditingController controller;
  final bool isInvalid;
  final bool isProcessing;
  final bool? darkBorder;
  final Function? resetError;

  const CustomPasswordInput({
    Key? key,
    required this.label,
    required this.maxLines,
    required this.controller,
    required this.isInvalid,
    required this.isProcessing,
    this.resetError,
    this.darkBorder,
  }) : super(key: key);

  @override
  State<CustomPasswordInput> createState() => _CustomPasswordInputState();
}

class _CustomPasswordInputState extends State<CustomPasswordInput> {
  bool passwordVisible = false;

  void changeVisibility() {
    setState(() => passwordVisible = !passwordVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          obscureText: !passwordVisible,
          enabled: !widget.isProcessing,
          enableSuggestions: false,
          maxLines: widget.maxLines,
          controller: widget.controller,
          cursorColor: AppColors.primaryDark,
          onTap: () => widget.resetError != null ? widget.resetError!.call() : null,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(left: 21, top: 10, bottom: 10, right: 40),
            labelText: widget.label,
            floatingLabelStyle: AppTextStyle.openSans14W400.apply(color: AppColors.primaryDark),
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                borderSide: widget.isInvalid ? const BorderSide(color: AppColors.red, width: 1) : BorderSide(color: widget.darkBorder == true ? AppColors.primaryDark : AppColors.inputBg, width: 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                borderSide: BorderSide(color: widget.darkBorder == true ? AppColors.primaryDark : AppColors.inputBg, width: 1)),
            focusColor: Theme.of(context).colorScheme.primary,
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(color: widget.darkBorder == true ? AppColors.primaryDark : AppColors.inputBg, width: 2),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(color: AppColors.red, width: 1),
            ),
          ),
        ),
        Positioned(
            right: 12,
            top: 8.5,
            child: GestureDetector(
              onTap: changeVisibility,
              child: SvgPicture.asset(
                passwordVisible ? AppIcons.visibilityOn : AppIcons.visibilityOff,
                width: 24,
                height: 24,
              ),
            ))
      ],
    );
  }
}
