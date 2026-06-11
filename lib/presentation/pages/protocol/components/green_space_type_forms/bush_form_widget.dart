import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/object_form_field_type.dart';
import 'package:gisogs_greenspacesapp/domain/enums/select_type.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_object_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/input_block.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/selects/app_select_button.dart';

class BushFormWidget extends StatefulWidget {
  final Stream eventStream;
  final ProtocolObjectViewModel state;
  final TextEditingController searchController;
  final TextEditingController amountController;
  final ValueNotifier<String?> kindSelected;
  final ValueNotifier<String?> ageSelected;
  final ValueNotifier<String?> workTypeSelected;
  final Function onSelectChangeHandler;
  final Function submitForm;
  final List<SelectObject> ages;
  const BushFormWidget({
    Key? key,
    required this.state,
    required this.searchController,
    required this.amountController,
    required this.kindSelected,
    required this.ageSelected,
    required this.onSelectChangeHandler,
    required this.workTypeSelected,
    required this.eventStream,
    required this.submitForm,
    required this.ages,
  }) : super(key: key);

  @override
  State<BushFormWidget> createState() => _BushFormWidgetState();
}

class _BushFormWidgetState extends State<BushFormWidget> {
  ProtocolObjectViewModel get _state => widget.state;
  TextEditingController get _searchController => widget.searchController;
  TextEditingController get _amountController => widget.amountController;
  ValueNotifier<String?> get _kindSelected => widget.kindSelected;
  ValueNotifier<String?> get _ageSelected => widget.ageSelected;
  ValueNotifier<String?> get _workTypeSelected => widget.workTypeSelected;
  Function get _onSelectChangeHandler => widget.onSelectChangeHandler;
  StreamSubscription? streamSubscription;
  Stream get _stream => widget.eventStream;
  List<SelectObject> get _ages => widget.ages;

  bool _amountError = false;
  String _amountErrorText = '';

  bool _kindError = false;
  String _kindErrorText = '';

  bool _ageError = false;
  String _ageErrorText = '';

  bool _workTypeError = false;
  String _workTypeErrorText = '';

  @override
  void initState() {
    super.initState();
    streamSubscription = _stream.listen((event) {
      debugPrint('BUSH FORM. ACTION ADDED: ${event.toString()}');
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

    bool amountError = false;
    String amountErrorText = '';

    bool kindError = false;
    String kindErrorText = '';

    bool ageError = false;
    String ageErrorText = '';

    bool workTypeError = false;
    String workTypeErrorText = '';

    if (_amountController.text == '') {
      amountError = true;
      amountErrorText = AppDictionary.fillInput;
    } else {
      amountError = false;
      amountErrorText = '';
    }

    if (_kindSelected.value == null) {
      kindError = true;
      kindErrorText = AppDictionary.selectValue;
    } else {
      kindError = false;
      kindErrorText = '';
    }

    if (_ageSelected.value == null) {
      ageError = true;
      ageErrorText = AppDictionary.selectValue;
    } else {
      ageError = false;
      ageErrorText = '';
    }

    if (_workTypeSelected.value == null) {
      workTypeError = true;
      workTypeErrorText = AppDictionary.selectValue;
    } else {
      workTypeError = false;
      workTypeErrorText = '';
    }

    setState(() {
      _amountError = amountError;
      _amountErrorText = amountErrorText;

      _kindError = kindError;
      _kindErrorText = kindErrorText;

      _ageError = ageError;
      _ageErrorText = ageErrorText;

      _workTypeError = workTypeError;
      _workTypeErrorText = workTypeErrorText;
    });

    if (amountError == false && _kindError == false && ageError == false && _workTypeError == false) {
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

    if (field == ObjectFormField.age) {
      setState(() {
        _ageError = false;
        _ageErrorText = '';
      });
    }

    if (field == ObjectFormField.kind) {
      setState(() {
        _kindError = false;
        _kindErrorText = '';
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              opacity: _kindError ? 1 : 0,
              duration: const Duration(milliseconds: 800),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Text(
                  _kindErrorText,
                  style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
                ),
              ),
            ),
            AppSelectButton(
              selectedVal: _kindSelected,
              items: _state.kind,
              hint: SelectHints.kind,
              type: SelectType.general,
              searchController: _searchController,
              processing: false,
              search: _state.workType.length > 25,
              resetError: () => _resetError(field: ObjectFormField.kind),
              onChange: _onSelectChangeHandler,
            ),
          ],
        ),
        const ProjectScreenHeader(
          title: AppDictionary.ageHint,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              opacity: _ageError ? 1 : 0,
              duration: const Duration(milliseconds: 800),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Text(
                  _ageErrorText,
                  style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
                ),
              ),
            ),
            AppSelectButton(
              selectedVal: _ageSelected,
              items: _ages,
              hint: AppDictionary.ageHint,
              type: SelectType.general,
              searchController: _searchController,
              processing: false,
              search: _state.workType.length > 25,
              resetError: () => _resetError(field: ObjectFormField.age),
              onChange: _onSelectChangeHandler,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProjectScreenHeader(title: AppDictionary.amountHint),
                  InputBlock(
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
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 25.0,
            ),
            Expanded(
              // flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProjectScreenHeader(title: AppDictionary.workType),
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
                          selectedVal: _workTypeSelected,
                          items: _state.workType,
                          hint: AppDictionary.workType,
                          type: SelectType.general,
                          searchController: _searchController,
                          processing: false,
                          search: _state.workType.length > 25,
                          resetError: () => _resetError(field: ObjectFormField.workType),
                          onChange: _onSelectChangeHandler,
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
