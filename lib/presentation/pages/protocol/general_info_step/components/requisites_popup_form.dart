import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/requisites_components_entity.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/custom_bottom_sheet.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_datepicker_input.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/input_block.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/string_extensions.dart';

class RequisitesPopupForm extends StatefulWidget {
  final String requisites;
  const RequisitesPopupForm({Key? key, required this.requisites}) : super(key: key);

  @override
  State<RequisitesPopupForm> createState() => _RequisitesPopupFormState();
}

class _RequisitesPopupFormState extends State<RequisitesPopupForm> {
  String get _requisites => widget.requisites;
  final TextEditingController _controllerNum = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  bool _requisitesNumError = false;
  String _requisitesNumErrorText = '';
  bool _requisitesDateError = false;
  String _requisitesDateErrorText = '';

  @override
  void initState() {
    super.initState();
    if (_requisites != '') {
      final List<String> requisitesSplit = _requisites.split('/');
      _controllerNum.text = requisitesSplit.first;
      _controllerDate.text = requisitesSplit.last;
    }
  }

  @override
  void dispose() {
    _controllerNum.dispose();
    _controllerDate.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    bool numError = false;
    bool dateError = false;
    String numErrorText = '';
    String dateErrorText = '';

    if (_controllerNum.text == '') {
      numError = true;
      numErrorText = 'Укажите номер документа';
    }

    if (_controllerDate.text == '') {
      dateError = true;
      dateErrorText = 'Выберите дату документа';
    }

    if (numError || dateError) {
      valid = false;
      setState(() {
        _requisitesNumError = numError;
        _requisitesNumErrorText = numErrorText;
        _requisitesDateError = dateError;
        _requisitesDateErrorText = dateErrorText;
      });
    }

    return valid;
  }

  void _closeHandler() {
    if (_validate()) {
      final RequisitesComponents results = RequisitesComponents(number: _controllerNum.text, date: _controllerDate.text);
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.of(context, rootNavigator: true).pop(json.encode(results));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: MediaQuery.of(context).viewInsets.bottom > 0 ? 290.0 + (MediaQuery.of(context).viewInsets.bottom / 1.1) : 290.0,
      child: Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const ProjectScreenHeader(
            title: AppDictionary.popupRequisitesForm,
            margin: EdgeInsets.only(bottom: 5.0),
          ),
          InputBlock(
              label: AppDictionary.requisitesNum,
              isError: _requisitesNumError,
              isPassword: false,
              errorMessage: _requisitesNumErrorText,
              controller: _controllerNum,
              resetError: () => setState(() {
                    _requisitesNumError = false;
                    _requisitesNumErrorText = '';
                  }),
              isProcessing: false),
          const SizedBox(
            height: 5.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _requisitesDateError ? 1 : 0,
                duration: const Duration(milliseconds: 800),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text(
                    _requisitesDateErrorText,
                    style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
                  ),
                ),
              ),
              CustomDateTimePicker(
                controller: _controllerDate,
                label: AppDictionary.pickDate,
                isProcessing: false,
                dateFormat: 'dd.MM.yyyy',
                dateRestriction: DateTime.now(),
                resetError: () => setState(() {
                  _requisitesDateError = false;
                  _requisitesDateErrorText = '';
                }),
              ),
            ],
          ),
          const SizedBox(
            height: 18.0,
          ),
          AppRoundedButton(
              color: AppColors.green,
              labelStyle: AppTextStyle.roboto14W500.apply(
                color: AppColors.primaryLight,
              ),
              label: BtnLabel.save.toCapitalized(),
              handler: _closeHandler,
              isProcessing: false),
        ]),
      ),
    );
  }
}
