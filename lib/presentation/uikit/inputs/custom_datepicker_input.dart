import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CustomDateTimePicker extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isProcessing;
  final String? dateFormat;
  final VoidCallback? resetError;
  final DateTime? dateRestriction;
  const CustomDateTimePicker({
    Key? key,
    required this.label,
    required this.controller,
    required this.isProcessing,
    this.dateFormat,
    this.resetError,
    this.dateRestriction,
  }) : super(key: key);

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  TextEditingController get _controller => widget.controller;
  String get _label => widget.label;
  bool get _isProcessing => widget.isProcessing;
  String? get _dateFormat => widget.dateFormat;
  VoidCallback? get _resetError => widget.resetError;
  DateTime? get _dateRestriction => widget.dateRestriction;

  String dateText = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: AppDecorations.input,
      child: Stack(
        children: [
          TextFormField(
            textAlignVertical: TextAlignVertical.top,
            enabled: !_isProcessing,
            readOnly: true,
            controller: _controller,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                locale: const Locale("ru", "RU"),
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
                //DateTime.now() - not to allow to choose before today.
                lastDate: _dateRestriction != null
                    ? _dateRestriction!
                    : DateTime.now().add(
                        const Duration(days: 365 * 5),
                      ),
                builder: (BuildContext context, Widget? child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppColors.green,
                        secondary: AppColors.red,
                        onSecondary: AppColors.red,
                        onPrimary: AppColors.primaryLight,
                        surface: AppColors.barsBg,
                        onSurface: AppColors.primaryDark,
                      ),
                      dialogBackgroundColor: AppColors.barsBg,
                      disabledColor: AppColors.disabled,
                    ),
                    child: child!),
              );

              if (pickedDate != null) {
                String formattedDate = DateFormat(_dateFormat ?? 'dd/MM/yyyy').format(pickedDate);
                if (_resetError != null) {
                  _resetError!();
                }
                setState(() {
                  _controller.text = formattedDate;
                });
              } else {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 21, vertical: 14),
              labelText: _label,
              labelStyle: AppTextStyle.roboto14W400.apply(color: AppColors.primaryDark),
              alignLabelWithHint: true,
              floatingLabelStyle: AppTextStyle.roboto14W400.apply(color: AppColors.primaryDark),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  borderSide: BorderSide(color: AppColors.inputBg, width: 1)),
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  borderSide: BorderSide(color: AppColors.inputBg, width: 1)),
              focusColor: Theme.of(context).colorScheme.primary,
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                borderSide: BorderSide(color: AppColors.inputBg, width: 2),
              ),
            ),
          ),
          Positioned(top: 14, right: 19.0, child: SvgPicture.asset(AppIcons.calendarIcon)),
        ],
      ),
    );
  }
}
