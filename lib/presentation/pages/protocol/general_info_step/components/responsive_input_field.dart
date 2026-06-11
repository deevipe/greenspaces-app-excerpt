import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/requisites_components_entity.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/general_info_step/components/requisites_popup_form.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ResponsiveInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final bool enabled;
  final bool readOnly;
  const ResponsiveInputField({Key? key, required this.controller, required this.label, required this.enabled, this.focusNode, required this.readOnly})
      : super(key: key);

  @override
  State<ResponsiveInputField> createState() => __ResponsiveInputFieldState();
}

class __ResponsiveInputFieldState extends State<ResponsiveInputField> {
  TextEditingController get _controller => widget.controller;
  bool get _enabled => widget.enabled;
  bool get _readOnly => widget.readOnly;

  Future<void> _setNumberAndDate() async {
    await showMaterialModalBottomSheet(
      useRootNavigator: true,
      isDismissible: false,
      expand: false,
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) => RequisitesPopupForm(requisites: _controller.text),
    ).then((value) {
      FocusManager.instance.primaryFocus?.unfocus();
      if (value != null) {
        try {
          final Map<String, dynamic> jsonResult = jsonDecode(value);
          final RequisitesComponents components = RequisitesComponents.fromJson(jsonResult);

          setState(() => _controller.text = '${components.number} / ${components.date}');
        } catch (_) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.top,
      enabled: _enabled,
      focusNode: widget.focusNode,
      controller: widget.controller,
      showCursor: true,
      cursorColor: AppColors.primaryDark,
      readOnly: _readOnly,
      onTap: () async => _readOnly ? _setNumberAndDate() : null,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
        labelText: widget.label,
        labelStyle: AppTextStyle.roboto14W500.apply(color: _enabled ? AppColors.primaryDark : AppColors.dimmedDark),
        alignLabelWithHint: true,
        floatingLabelStyle: AppTextStyle.roboto14W500.apply(color: AppColors.green),
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: _controller.text != '' ? const BorderSide(color: AppColors.green, width: 1) : const BorderSide(color: AppColors.primaryDark, width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(color: _controller.text != '' ? AppColors.green : AppColors.dark, width: 1)),
        focusColor: Theme.of(context).colorScheme.primary,
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(color: _controller.text == '' ? AppColors.green : AppColors.dark, width: 1),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(color: AppColors.red, width: 1),
        ),
      ),
    );
  }
}
