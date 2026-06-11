import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/representatives/other_block_results.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_representatives_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/general_step_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_representatives_view_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_input.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_input_with_action.dart';

class OtherRepresentativeBlock extends StatefulWidget {
  final ProtocolRepresentativesViewModel state;
  final TextEditingController otherController;
  final TextEditingController otherFioController;
  final TextEditingController otherPhoneController;
  final TextEditingController otherPositionController;
  final FocusNode otherFocusNode;
  final FocusNode otherFioFocusNode;
  final FocusNode otherPhoneFocusNode;
  final FocusNode otherPositionFocusNode;
  const OtherRepresentativeBlock({
    Key? key,
    required this.otherController,
    required this.otherFioController,
    required this.otherPhoneController,
    required this.otherPositionController,
    required this.otherFocusNode,
    required this.otherFioFocusNode,
    required this.otherPhoneFocusNode,
    required this.otherPositionFocusNode,
    required this.state,
  }) : super(key: key);

  @override
  State<OtherRepresentativeBlock> createState() => _OtherRepresentativeBlockState();
}

class _OtherRepresentativeBlockState extends State<OtherRepresentativeBlock> {
  TextEditingController get _queryController => widget.otherController;
  TextEditingController get _fioController => widget.otherFioController;
  TextEditingController get _phoneController => widget.otherPhoneController;
  TextEditingController get _positionController => widget.otherPositionController;
  ProtocolRepresentativesViewModel get _state => widget.state;
  bool queryValid = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _queryController.addListener(queryListener);
  }

  @override
  void dispose() {
    _queryController.removeListener(queryListener);
    super.dispose();
  }

  void queryListener() {
    if (_queryController.text != '' && !queryValid && _queryController.text.length >= 3) {
      setState(() {
        queryValid = true;
        errorMessage = '';
      });
    }
  }

  void searchCallback() {
    // Отправим action на поиск подходящей организации
    if (_queryController.text.length >= 3) {
      StoreProvider.of<AppState>(context).dispatch(searchOrgs(query: _queryController.text));
      FocusManager.instance.primaryFocus?.unfocus();
      // Сразу же откроем модальное окно для отображения результатов / ошибки
      showMaterialModalBottomSheet(
        useRootNavigator: true,
        expand: false,
        context: context,
        backgroundColor: AppColors.transparent,
        builder: (context) => const ModalContent(),
      );
    } else {
      setState(() {
        queryValid = false;
        errorMessage = 'Для поиска необходимо ввести минимум 3 символа';
      });
    }
  }

  void deleteCallback() {
    StoreProvider.of<AppState>(context).dispatch(ClearOtherOrg());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          opacity: queryValid ? 0 : 1,
          duration: const Duration(milliseconds: 800),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3.0, left: 5.0),
            child: Text(
              errorMessage,
              style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_state.selectedOtherOrg != null) {
              showMaterialModalBottomSheet(
                useRootNavigator: true,
                expand: false,
                context: context,
                backgroundColor: AppColors.transparent,
                builder: (context) => const ModalContent(),
              );
            }
          },
          child: CustomActionInput(
            label: AppDictionary.searchField,
            maxLines: 2,
            controller: _queryController,
            focusNode: widget.otherFocusNode,
            isInvalid: _state.selectedOtherOrg != null,
            isProcessing: _state.searchingOtherOrgs ?? false,
            callbcak: searchCallback,
            callback2: deleteCallback,
            secondCallback: _state.selectedOtherOrg != null,
          ),
        ),
        const SizedBox(height: 10.0),
        if (widget.state.selectedOtherOrg != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedOpacity(
                opacity: _state.fillFio ? 1 : 0,
                duration: const Duration(milliseconds: 800),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0, left: 5.0),
                  child: Text(
                    AppDictionary.fillInput,
                    style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
                  ),
                ),
              ),
              CustomInput(
                label: SelectHints.fio,
                maxLines: 1,
                controller: _fioController,
                focusNode: widget.otherFioFocusNode,
                isInvalid: false,
                isProcessing: false,
              ),
              const SizedBox(
                height: 5.0,
              ),
              AnimatedOpacity(
                opacity: _state.fillPhone ? 1 : 0,
                duration: const Duration(milliseconds: 800),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0, left: 5.0),
                  child: Text(
                    AppDictionary.fillInput,
                    style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
                  ),
                ),
              ),
              CustomInput(
                label: SelectHints.phone,
                maxLines: 1,
                controller: _phoneController,
                focusNode: widget.otherPhoneFocusNode,
                isInvalid: false,
                isProcessing: false,
              ),
              const SizedBox(
                height: 5.0,
              ),
              AnimatedOpacity(
                opacity: _state.fillPosition ? 1 : 0,
                duration: const Duration(milliseconds: 800),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0, left: 5.0),
                  child: Text(
                    AppDictionary.fillInput,
                    style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
                  ),
                ),
              ),
              CustomInput(
                label: SelectHints.position,
                maxLines: 1,
                controller: _positionController,
                focusNode: widget.otherPositionFocusNode,
                isInvalid: false,
                isProcessing: false,
              ),
            ],
          ),
      ],
    );
  }
}
