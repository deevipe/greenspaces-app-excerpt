import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/enums/object_form_field_type.dart';
import 'package:gisogs_greenspacesapp/domain/enums/select_type.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';

import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_object_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/input_block.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/selects/app_select_button.dart';

class DefaultFormWidget extends StatefulWidget {
  final Stream eventStream;
  final ProtocolObjectViewModel state;
  final TextEditingController searchController;
  final TextEditingController areaController;
  final TextEditingController amountController;
  final ValueNotifier<String?> workTypeSelected;
  final Function onSelectChangeHandler;
  final Function submitForm;
  const DefaultFormWidget({
    super.key,
    required this.state,
    required this.areaController,
    required this.workTypeSelected,
    required this.onSelectChangeHandler,
    required this.amountController,
    required this.searchController,
    required this.eventStream,
    required this.submitForm,
  });

  @override
  State<DefaultFormWidget> createState() => _DefaultFormWidgetState();
}

class _DefaultFormWidgetState extends State<DefaultFormWidget> {
  ProtocolObjectViewModel get _state => widget.state;
  TextEditingController get _searchController => widget.searchController;
  TextEditingController get _areaController => widget.areaController;
  TextEditingController get _amountController => widget.amountController;
  ValueNotifier<String?> get _typeSelected => widget.workTypeSelected;
  StreamSubscription? streamSubscription;
  Stream get _stream => widget.eventStream;

  bool _amountError = false;
  String _amountErrorText = '';

  bool _areaError = false;
  String _areaErrorText = '';

  bool _workTypeError = false;
  String _workTypeErrorText = '';

  @override
  void initState() {
    super.initState();
    streamSubscription = _stream.listen((event) {
      debugPrint('DEFAULT FORM. ACTION ADDED: ${event.toString()}');
      bool formIsValid = _validation();
      if (formIsValid) widget.submitForm(action: event);
    });
  }

  @override
  void dispose() {
    if (streamSubscription != null) {
      streamSubscription!.cancel();
    }
    super.dispose();
  }

  bool _validation() {
    bool valid = false;

    bool amountFilledError = false;
    String amountFilledErrorText = '';
    bool areaFilledError = false;
    String areaFilledErrorText = '';
    bool workTypeSelectedError = false;
    String workTypeSelectedErrorText = '';
    // Проверяем поле количество, в противном случае смотрим на площадь
    if (_state.type!.id == 6) {
      if (_amountController.text == '') {
        amountFilledError = true;
        amountFilledErrorText = AppDictionary.fillInput;
      } else {
        amountFilledError = false;
        amountFilledErrorText = '';
      }
    } else {
      if (_areaController.text == '') {
        areaFilledError = true;
        areaFilledErrorText = AppDictionary.fillInput;
      } else {
        areaFilledError = false;
        areaFilledErrorText = '';
      }
    }

    if (_typeSelected.value == null) {
      workTypeSelectedError = true;
      workTypeSelectedErrorText = AppDictionary.selectValue;
    } else {
      workTypeSelectedError = false;
      workTypeSelectedErrorText = '';
    }

    setState(() {
      _amountError = amountFilledError;
      _amountErrorText = amountFilledErrorText;

      _areaError = areaFilledError;
      _areaErrorText = areaFilledErrorText;

      _workTypeError = workTypeSelectedError;
      _workTypeErrorText = workTypeSelectedErrorText;
    });

    if ((_state.type!.id == 6 ? amountFilledError == false : areaFilledError == false) && workTypeSelectedError == false) {
      valid = true;
    }

    return valid;
  }

  void _resetError({required ObjectFormField field}) {
    if (field == ObjectFormField.amount) {
      setState(() {
        _amountError = false;
        _amountErrorText = '';
      });
    }

    if (field == ObjectFormField.area) {
      setState(() {
        _areaError = false;
        _areaErrorText = '';
      });
    }

    if (field == ObjectFormField.workType) {
      setState(() {
        _workTypeError = false;
        _workTypeErrorText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProjectScreenHeader(
                    title: _state.type!.id == 6 ? AppDictionary.amountHint : AppDictionary.areaHint,
                    margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                  ),
                  _state.type!.id == 6
                      ? InputBlock(
                          label: '',
                          maxLines: 1,
                          isError: _amountError,
                          isPassword: false,
                          errorMessage: _amountErrorText,
                          controller: _amountController,
                          resetError: () => _resetError(field: ObjectFormField.amount),
                          isProcessing: false,
                          keyboardType: TextInputType.number,
                          errorAlignment: CrossAxisAlignment.start,
                          formatters: [
                            FilteringTextInputFormatter.deny(
                              RegExp(r'^0+'),
                            ),
                          ],
                        )
                      : InputBlock(
                          label: '',
                          maxLines: 1,
                          isError: _areaError,
                          isPassword: false,
                          errorMessage: _areaErrorText,
                          controller: _areaController,
                          resetError: () => _resetError(field: ObjectFormField.area),
                          isProcessing: false,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          errorAlignment: CrossAxisAlignment.start,
                          formatters: [
                            FilteringTextInputFormatter.deny(
                              RegExp(r'^0+'),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(
              width: 25.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProjectScreenHeader(
                    title: AppDictionary.workType,
                    margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  ),
                  if (_state.workType.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedOpacity(
                          opacity: _workTypeError ? 1 : 0,
                          duration: const Duration(milliseconds: 800),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Text(
                              _workTypeErrorText,
                              style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
                            ),
                          ),
                        ),
                        AppSelectButton(
                          selectedVal: _typeSelected,
                          items: _state.workType,
                          hint: AppDictionary.workType,
                          type: SelectType.general,
                          searchController: _searchController,
                          processing: false,
                          search: _state.workType.length > 25,
                          resetError: () => _resetError(field: ObjectFormField.workType),
                          onChange: widget.onSelectChangeHandler,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
