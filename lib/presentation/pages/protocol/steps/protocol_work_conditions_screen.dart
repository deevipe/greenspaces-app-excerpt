import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_work_condition_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_form_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_work_conditions_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/error_message_text.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_chip_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/input_block.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/string_extensions.dart';

const double textInputHeight = 140.0;

class ProtocolConditionsScreen extends StatefulWidget {
  const ProtocolConditionsScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolConditionsScreen> createState() => _ProtocolConditionsScreenState();
}

class _ProtocolConditionsScreenState extends State<ProtocolConditionsScreen> {
  late ScrollController _scrollController;
  final TextEditingController _otherFieldController = TextEditingController();
  final FocusNode _otherFieldFocusNode = FocusNode();
  bool _otherSelected = false;
  bool _otherFilledError = false;
  double _textInputHeight = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _otherFieldController.addListener(_onOtherFieldChange);
    _otherFieldFocusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _otherFieldController.removeListener(_onOtherFieldChange);
    _otherFieldFocusNode.removeListener(_focusNodeListener);
    _otherFieldController.dispose();
    super.dispose();
  }

  void _focusNodeListener() async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _otherFieldFocusNode.hasFocus) {
        _scrollController.animateTo(150, curve: Curves.easeIn, duration: const Duration(milliseconds: 500));
      }
    });
  }

  void _onOtherFieldChange() {
    final ProtocolWorkConditionViewModel state = StoreProvider.of<AppState>(context).state.protocolConditionStepState;
    StoreProvider.of<AppState>(context).dispatch(UpdateProtocolWorkCondition(condition: state.selectedCondition, otherName: _otherFieldController.text));
  }

  void _nextStepHandler() async {
    final ProtocolWorkConditionViewModel state = StoreProvider.of<AppState>(context).state.protocolConditionStepState;
    if (state.selectedCondition.isEmpty) {
      HelperUtils.showErrorMessage(context: context, message: GeneralErrors.selectOneOrMore);
    } else {
      // Добавим вывод ошибки, если выбрано Иное и не заполнено текстовое поле
      if (state.selectedCondition.contains(617) && _otherFieldController.text == '') {
        setState(() => _otherFilledError = true);
      } else {
        StoreProvider.of<AppState>(context).dispatch(UpdateProtocolWorkCondition(condition: state.selectedCondition, otherName: _otherFieldController.text));
        context.router.push(const ProtocolRepresentativesRoute());
      }
    }
  }

  void _selectHandler(int conditionId) async {
    List<int> selectedConditions = List.from(StoreProvider.of<AppState>(context).state.protocolConditionStepState.selectedCondition);
    if (selectedConditions.contains(conditionId)) {
      selectedConditions.remove(conditionId);
    } else {
      selectedConditions.add(conditionId);
    }

    StoreProvider.of<AppState>(context).dispatch(UpdateProtocolWorkCondition(condition: selectedConditions));

    // Вариант "Иное"
    if (conditionId == 617) {
      if (!selectedConditions.contains(conditionId)) {
        FocusManager.instance.primaryFocus?.unfocus();
      } else {
        _otherFieldController.text = '';
      }
      setState(() {
        _otherSelected = !_otherSelected;
        _textInputHeight = _otherSelected ? textInputHeight : 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: StoreConnector<AppState, ProtocolWorkConditionViewModel>(
        onInit: (store) {
          store.state.protocolConditionStepState.conditions.isNotEmpty ? null : store.dispatch(getWorkConditions());

          // Если выбран пункт "Иное"
          if (store.state.protocolConditionStepState.selectedCondition.contains(617)) {
            _otherSelected = true;
            _textInputHeight = textInputHeight;
            _otherFieldController.text = store.state.protocolConditionStepState.otherName ?? '';
          }
        },
        converter: (store) => store.state.protocolConditionStepState,
        distinct: true,
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              state.isLoading || state.isError == true
                  ? SliverFillRemaining(
                      child: Container(
                        color: AppColors.primaryLight,
                        padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                        child: state.isLoading
                            ? const Center(
                                child: Loader(),
                              )
                            : Center(
                                child: ErrorMessageText(message: state.errorMessage ?? GeneralErrors.generalError),
                              ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          color: AppColors.primaryLight,
                          padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                          child: StoreConnector<AppState, ProtocolWorkConditionViewModel>(
                            onInit: (store) => store.state.protocolConditionStepState.conditions.isNotEmpty ? null : store.dispatch(getWorkConditions()),
                            converter: (store) => store.state.protocolConditionStepState,
                            distinct: true,
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ProjectScreenHeader(title: ProtocolHeaderTitles.protocolFormCondition),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Column(
                                    children: List.generate(
                                      state.conditions.length,
                                      (index) => CustomChipButton(
                                        label: state.conditions[index].title.toCapitalized(),
                                        onTap: () => _selectHandler(state.conditions[index].id),
                                        selected: state.conditions.isEmpty ? false : state.selectedCondition.contains(state.conditions[index].id),
                                      ),
                                    ),
                                  ),
                                  AnimatedSize(
                                    curve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 300),
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: const BoxDecoration(color: AppColors.transparent),
                                      height: _textInputHeight,
                                      child: InputBlock(
                                        controller: _otherFieldController,
                                        resetError: () => setState(() => _otherFilledError = false),
                                        errorMessage: AppDictionary.fillInput,
                                        isError: _otherFilledError,
                                        isPassword: false,
                                        isProcessing: false,
                                        label: AppDictionary.enterText,
                                        maxLines: 5,
                                        focusNode: _otherFieldFocusNode,
                                        errorAlignment: CrossAxisAlignment.start,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  AppRoundedButton(
                                    color: AppColors.green,
                                    label: BtnLabel.continueBtn,
                                    handler: () => _nextStepHandler(),
                                    isProcessing: false,
                                    labelStyle: AppTextStyle.roboto14W500.apply(
                                      color: AppColors.primaryLight,
                                    ),
                                  ),
                                  MediaQuery.of(context).viewInsets.bottom > 0
                                      ? const SizedBox(
                                          height: 250,
                                        )
                                      : const SizedBox.shrink()
                                ],
                              );
                            },
                          ),
                        );
                      }, childCount: 1),
                    ),
            ],
          );
        },
      ),
    );
  }
}
