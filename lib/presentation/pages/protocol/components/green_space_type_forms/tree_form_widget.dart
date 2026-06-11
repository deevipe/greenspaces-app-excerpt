import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/object_form_field_type.dart';
import 'package:gisogs_greenspacesapp/domain/enums/select_type.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_object_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_object_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_checkbox.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_input.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/selects/app_select_button.dart';

class TreeFormWidget extends StatefulWidget {
  final Stream eventStream;
  final ProtocolObjectViewModel state;
  final TextEditingController searchController;
  final TextEditingController otherWorkTypeController;
  final ValueNotifier<String?> kindSelected;
  final ValueNotifier<String?> stemDiameterSelected;
  final ValueNotifier<String?> workTypeSelected;
  final ValueNotifier<String?> workSubTypeSelected;
  final ValueNotifier<String?> objectStateSelected;
  final Function onSelectChangeHandler;
  final Function submitForm;
  final List<Widget> stemWidget;
  final List<SelectObject> diameters;

  const TreeFormWidget({
    Key? key,
    required this.state,
    required this.searchController,
    required this.otherWorkTypeController,
    required this.kindSelected,
    required this.stemDiameterSelected,
    required this.workTypeSelected,
    required this.workSubTypeSelected,
    required this.objectStateSelected,
    required this.onSelectChangeHandler,
    required this.stemWidget,
    required this.eventStream,
    required this.submitForm,
    required this.diameters,
  }) : super(key: key);

  @override
  State<TreeFormWidget> createState() => _TreeFormWidgetState();
}

class _TreeFormWidgetState extends State<TreeFormWidget> {
  StreamSubscription? streamSubscription;
  ProtocolObjectViewModel get _state => widget.state;
  TextEditingController get _searchController => widget.searchController;
  ValueNotifier<String?> get _kindSelected => widget.kindSelected;
  ValueNotifier<String?> get _workTypeSelected => widget.workTypeSelected;
  ValueNotifier<String?> get _workSubTypeSelected => widget.workSubTypeSelected;
  ValueNotifier<String?> get _objectStateSelected => widget.objectStateSelected;
  ValueNotifier<String?> get _stemDiameterSelected => widget.stemDiameterSelected;
  Function get _onSelectChangeHandler => widget.onSelectChangeHandler;
  List<Widget> get _stemWidgets => widget.stemWidget;
  List<SelectObject> get _diameters => widget.diameters;
  Stream get _stream => widget.eventStream;

  final TextEditingController _stemController = TextEditingController();

  bool _kindError = false;
  String _kindErrorText = '';

  bool _diameterError = false;
  String _diameterErrorText = '';

  bool _workTypeError = false;
  String _workTypeErrorText = '';

  @override
  void initState() {
    super.initState();
    streamSubscription = _stream.listen((event) {
      bool formIsValid = _validation();
      if (formIsValid) widget.submitForm(action: event);
    });
  }

  @override
  void dispose() {
    _stemController.dispose();
    if (streamSubscription != null) {
      streamSubscription!.cancel();
    }
    super.dispose();
  }

  bool _validation() {
    bool valid = false;

    bool kindError = false;
    String kindErrorText = '';

    bool diameterError = false;
    String diameterErrorText = '';

    bool workTypeError = false;
    String workTypeErrorText = '';

    if (_kindSelected.value == null) {
      kindError = true;
      kindErrorText = AppDictionary.selectValue;
    } else {
      kindError = false;
      kindErrorText = AppDictionary.selectValue;
    }

    if (_stemDiameterSelected.value == null) {
      diameterError = true;
      diameterErrorText = AppDictionary.selectValue;
    } else {
      diameterError = false;
      diameterErrorText = AppDictionary.selectValue;
    }

    if (_workTypeSelected.value == null) {
      workTypeError = true;
      workTypeErrorText = AppDictionary.selectValue;
    } else {
      workTypeError = false;
      workTypeErrorText = '';
    }

    setState(() {
      _diameterError = diameterError;
      _diameterErrorText = diameterErrorText;

      _kindError = kindError;
      _kindErrorText = kindErrorText;

      _workTypeError = workTypeError;
      _workTypeErrorText = workTypeErrorText;
    });

    if (diameterError == false && _kindError == false && _workTypeError == false) {
      valid = true;
    }

    return valid;
  }

  void _resetError({required ObjectFormField field}) {
    if (field == ObjectFormField.diameter) {
      setState(() {
        _diameterError = false;
        _diameterErrorText = '';
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
        CustomCheckBox(
          callback: () => StoreProvider.of<AppState>(context).dispatch(HandleMultistemCheckbox(value: !_state.multiStem)),
          label: AppDictionary.multiStem,
          checked: _state.multiStem,
        ),
        if (_state.multiStem)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    AppDictionary.stemAount,
                    style: AppTextStyle.openSans14W500,
                  ),
                  Row(children: [
                    InkwellButton(
                        child: Icon(
                          Icons.remove,
                          color: (int.parse(_state.stemAmount ?? '0') > 0 ? AppColors.primaryDark : AppColors.disabled),
                        ),
                        function: () {
                          int stems = _state.stemAmount != null ? int.parse(_state.stemAmount!) : 0;
                          if (stems > 0) {
                            stems--;
                            StoreProvider.of<AppState>(context).dispatch(ChangeStemAmount(newAmount: '$stems'));
                          }
                        }),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      width: 60,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: AppDecorations.select,
                      child: Text(
                        _state.stemAmount ?? '0',
                        style: AppTextStyle.openSans14W500,
                      ),
                    ),
                    InkwellButton(
                        child: const Icon(Icons.add),
                        function: () {
                          int stems = _state.stemAmount != null ? int.parse(_state.stemAmount!) : 0;
                          stems++;
                          StoreProvider.of<AppState>(context).dispatch(ChangeStemAmount(newAmount: '$stems'));
                        })
                  ]),
                  const Text(
                    AppDictionary.toDemolish,
                    style: AppTextStyle.openSans14W700,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              ...List.generate(_stemWidgets.length, (index) => _stemWidgets[index]),
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
                  const ProjectScreenHeader(title: AppDictionary.stemDiameter),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedOpacity(
                        opacity: _diameterError ? 1 : 0,
                        duration: const Duration(milliseconds: 800),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Text(
                            _diameterErrorText,
                            style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
                          ),
                        ),
                      ),
                      AppSelectButton(
                        selectedVal: _stemDiameterSelected,
                        items: _diameters,
                        hint: AppDictionary.sm,
                        type: SelectType.general,
                        searchController: _searchController,
                        processing: false,
                        search: _state.workType.length > 25,
                        resetError: () => _resetError(field: ObjectFormField.diameter),
                        onChange: _onSelectChangeHandler,
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
                  const SizedBox(
                    height: 15.0,
                  ),
                  if (_state.fetchingWorkSubType) const Loader(),
                  if (_state.workSubType.isNotEmpty)
                    AppSelectButton(
                      selectedVal: _workSubTypeSelected,
                      items: _state.workSubType,
                      hint: AppDictionary.fellingType,
                      type: SelectType.general,
                      searchController: _searchController,
                      search: _state.workSubType.length > 25,
                      onChange: _onSelectChangeHandler,
                    ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        AppSelectButton(
          selectedVal: _objectStateSelected,
          items: _state.objectState,
          hint: AppDictionary.objectState,
          type: SelectType.general,
          searchController: _searchController,
          onChange: _onSelectChangeHandler,
        ),
        const SizedBox(
          height: 15.0,
        ),
        if (_state.selectedObjectState == '24_Иное')
          CustomInput(
            label: AppDictionary.otherLabel,
            maxLines: 1,
            controller: widget.otherWorkTypeController,
            isInvalid: false,
            isProcessing: false,
          ),
      ],
    );
  }
}
