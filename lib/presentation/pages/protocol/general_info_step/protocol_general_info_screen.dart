// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/select_type.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/general_info_step/components/calendar_row_input.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/general_info_step/components/organisation_search_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/general_info_step/components/responsive_input_field.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/app_navigation_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_general_data_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/general_step_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_save_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_general_data_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_chip_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/selects/app_select_button.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';

class ProtocolFirstStepScreen extends StatefulWidget {
  const ProtocolFirstStepScreen({super.key});

  @override
  State<ProtocolFirstStepScreen> createState() => _ProtocolFirstStepScreenState();
}

class _ProtocolFirstStepScreenState extends State<ProtocolFirstStepScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _otherField = TextEditingController();
  final TextEditingController _contractRequisites = TextEditingController();
  final TextEditingController _subContractRequisites = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _orgField = TextEditingController();

  final ValueNotifier<String?> _selectedMunicipality = ValueNotifier(null);
  final ValueNotifier<String?> _selectedDistrict = ValueNotifier(null);

  final FocusNode _otherFocusNode = FocusNode();
  final FocusNode _orgSearchNode = FocusNode();

  int? selectedDepartment;
  bool contractSelected = false;
  bool subContractSelected = false;
  bool otherSelected = false;
  bool _processingStep = false;

  /// Маркеры для выделения разделов, необходимых для заполнения
  bool _dateError = false;
  bool _departmentError = false;
  bool _contractError = false;
  bool _requisitesError = false;
  bool _districtError = false;
  bool _municipalityError = false;
  bool _orgError = false;

  @override
  void initState() {
    super.initState();
    _otherFocusNode.addListener(_focusNodeListener);
    _otherField.addListener(_textInputListener);
    _subContractRequisites.addListener(_textInputListener);
    _contractRequisites.addListener(_textInputListener);
    _date.addListener(_textInputListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _date.dispose();
    _contractRequisites.dispose();
    _subContractRequisites.dispose();
    _otherField.dispose();
    _searchController.dispose();
    _orgField.dispose();
    _orgSearchNode.dispose();
    _otherFocusNode.removeListener(_focusNodeListener);
    _otherField.removeListener(_textInputListener);
    _date.removeListener(_textInputListener);
    super.dispose();
  }

  void _focusNodeListener() async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _otherFocusNode.hasFocus) {
        _scrollController.animateTo(150, curve: Curves.easeIn, duration: const Duration(milliseconds: 500));
      }
    });
  }

  void _textInputListener() {
    if (otherSelected) {
      if (_otherField.text != '' && _requisitesError) {
        setState(() => _requisitesError = false);
      }
    }

    if (contractSelected || subContractSelected) {
      if (((contractSelected && _contractRequisites.text != '') || (subContractSelected && _subContractRequisites.text != '')) && _requisitesError) {
        setState(() => _requisitesError = false);
      }
    }

    if (_dateError && _date.text != '') {
      setState(() => _dateError = false);
    }
  }

  void _onSelectChangeHandler() {
    final ProtocolGeneralViewModel state = StoreProvider.of<AppState>(context).state.protocolGeneralStepState;

    Municipality? selectedMunicipality;
    SelectObject? selectedDistrict;

    if (_selectedMunicipality.value != null && state.municipalitiesList.isNotEmpty) {
      final String selectedId = _selectedMunicipality.value!.split('_').first;

      selectedMunicipality = state.municipalitiesList.firstWhere((element) => '${element.id}' == selectedId);
      if (_municipalityError) {
        setState(() => _municipalityError = false);
      }
    }

    if (_selectedDistrict.value != null && state.districtsList.isNotEmpty) {
      final String selectedId = _selectedDistrict.value!.split('_').first;

      if (_districtError) {
        setState(() => _districtError = false);
      }

      selectedDistrict = state.districtsList.firstWhere((element) => element.id == selectedId);

      // Если район изменяют, запросим новый список муниципалитетов и сбросим выбранное значение
      if (selectedDistrict != state.selectedDistrict) {
        selectedMunicipality = null;
        _selectedMunicipality.value = null;
        StoreProvider.of<AppState>(context).dispatch(getMunicipalities(districtId: int.parse(selectedDistrict.id)));
      }
    }

    StoreProvider.of<AppState>(context).dispatch(UpdateGeneralProtocolData(
      selectedDistrict: selectedDistrict,
      selectedMunicpality: selectedMunicipality,
      selectedorg: state.selectedOrg,
    ));
  }

  void _nextStepHandler() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final ProtocolGeneralViewModel state = StoreProvider.of<AppState>(context).state.protocolGeneralStepState;

    setState(() => _processingStep = true);

    bool dateErr = false;
    bool departmentErr = false;
    bool contractErr = false;
    bool requisitesErr = false;
    bool municipalityErr = false;
    bool districtErr = false;
    bool orgErr = false;

    dateErr = _date.text == '';
    departmentErr = selectedDepartment == null;
    contractErr = !contractSelected && !subContractSelected && !otherSelected;
    requisitesErr = (_contractRequisites.text == '' && _subContractRequisites.text == '' && _otherField.text == '');
    municipalityErr = _selectedMunicipality.value == null;
    districtErr = _selectedDistrict.value == null;
    orgErr = state.selectedOrg == null;

    if (!dateErr && !departmentErr && !contractErr && !requisitesErr && !municipalityErr && !districtErr && !orgErr) {
      // Сохраним данные в redux state
      StoreProvider.of<AppState>(context).dispatch(UpdateGeneralProtocolData(
        date: _date.text,
        departmentId: selectedDepartment!,
        contract: contractSelected,
        subContract: subContractSelected,
        otherOpt: otherSelected,
        contractRequisites: _contractRequisites.text,
        subContractRequisites: _subContractRequisites.text,
        otherRequisites: _otherField.text,
        selectedDistrict: state.selectedDistrict,
        selectedMunicpality: state.selectedMunicipality,
        selectedorg: state.selectedOrg,
      ));

      context.router.push(const ProtocolCategoryRoute());

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _processingStep = false);
        }
      });
    } else {
      // Обновим стейт экрана
      setState(() {
        _dateError = dateErr;
        _departmentError = departmentErr;
        _contractError = contractErr;
        _requisitesError = requisitesErr;
        _municipalityError = municipalityErr;
        _districtError = districtErr;
        _orgError = orgErr;
        _processingStep = false;
      });

      HelperUtils.showErrorMessage(context: context, message: GeneralErrors.formFieldsMustBeFilled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: StoreConnector<AppState, ProtocolGeneralViewModel>(
          converter: (store) => store.state.protocolGeneralStepState,
          distinct: true,
          onInit: (store) {
            ProtocolGeneralViewModel state = store.state.protocolGeneralStepState;

            if (state.districtsList.isEmpty || state.municipalitiesList.isEmpty) {
              store.dispatch(getGeneralStepDictionaries());
            }

            _date.text = state.date;
            _otherField.text = state.otherRequisites ?? '';
            _contractRequisites.text = state.contractRequisites ?? '';
            if (state.selectedDistrict != null) {
              _selectedDistrict.value = '${state.selectedDistrict!.id}_${state.selectedDistrict!.title}';
            }
            if (state.selectedMunicipality != null) {
              _selectedMunicipality.value = '${state.selectedMunicipality!.id}_${state.selectedMunicipality!.title}';
            }
            if (state.selectedOrg != null) {
              _orgField.text = state.selectedOrg!.name;
            }
            _subContractRequisites.text = state.subContractRequisites ?? '';
            selectedDepartment = state.departmentId;
            contractSelected = state.contract;
            subContractSelected = state.subContract;
            otherSelected = state.otherOpt;
          },
          onWillChange: (pVm, nVm) async {
            if (nVm.isError == true && nVm.needAuth == true) {
              await HelperUtils.needAuthAction(context: context);
            }

            if (nVm.isError == true && nVm.preparingForRevision == true) {
              StoreProvider.of<AppState>(context).dispatch(UpdateAppNavigation(formIsOpen: false));
              StoreProvider.of<AppState>(context).dispatch(resetAllFormSteps());
              HelperUtils.showErrorMessage(context: context, message: nVm.errorMessage ?? GeneralErrors.parseError);
            }

            if (pVm?.preparingForRevision != null && pVm!.preparingForRevision == true && nVm.preparingForRevision == false) {
              // Запушить новые экраны
              context.tabsRouter.root.pushAll(
                  [const ProtocolCategoryRoute(), const ProtocolConditionsRoute(), const ProtocolRepresentativesRoute(), const ProtocolObjectsListRoute()]);
            }

            if (pVm?.selectedOrg != nVm.selectedOrg) {
              if (nVm.selectedOrg != null) {
                _orgField.text = nVm.selectedOrg!.name;
              } else {
                _orgField.text = '';
              }
              _orgError = false;
            }
          },
          builder: (context, state) {
            return CustomScrollView(controller: _scrollController, physics: const BouncingScrollPhysics(), slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: state.preparingForRevision || state.processing
                    ? const Center(
                        child: Loader(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ProjectScreenHeader(title: ProtocolHeaderTitles.protocolFormCreate),
                            const SizedBox(
                              height: 10.0,
                            ),
                            CalendarRowInput(controller: _date, hasError: _dateError),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ProjectScreenHeader(title: AppDictionary.protocolDistrictLabe, hasError: _districtError),
                            AppSelectButton(
                              selectedVal: _selectedDistrict,
                              items: state.districtsList,
                              hint: AppDictionary.protocolDistrictLabe,
                              type: SelectType.general,
                              searchController: _searchController,
                              processing: false,
                              search: state.districtsList.length > 25,
                              resetError: () {},
                              onChange: _onSelectChangeHandler,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ProjectScreenHeader(title: AppDictionary.municipalityLabel, hasError: _municipalityError),
                            AppSelectButton(
                              selectedVal: _selectedMunicipality,
                              items: state.municipalitiesList.map((el) => SelectObject(id: '${el.id}', title: el.title)).toList(),
                              hint: AppDictionary.municipalityLabel,
                              type: SelectType.general,
                              searchController: _searchController,
                              processing: false,
                              search: state.municipalitiesList.length > 25,
                              resetError: () {},
                              onChange: _onSelectChangeHandler,
                            ),
                            ProjectScreenHeader(
                              title: AppDictionary.orgLabel,
                              hasError: _orgError,
                              margin: const EdgeInsets.only(bottom: 0, top: 25.0),
                            ),
                            OrganisationSearchWidget(otherController: _orgField, otherFocusNode: _orgSearchNode, state: state),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ProjectScreenHeader(title: AppDictionary.departmentLabel, hasError: _departmentError),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: CustomChipButton(
                                      label: AppDictionary.otdelSoderzhaniya,
                                      onTap: () => setState(() {
                                        selectedDepartment = 637;
                                        _departmentError = false;
                                      }),
                                      selected: selectedDepartment == 637,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                      child: CustomChipButton(
                                    label: AppDictionary.otdelKoordinacii,
                                    onTap: () => setState(() {
                                      selectedDepartment = 636;
                                      _departmentError = false;
                                    }),
                                    selected: selectedDepartment == 636,
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: ProjectScreenHeader(
                                  title: AppDictionary.reasonLabel,
                                  hasError: _contractError,
                                )),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                    child: ProjectScreenHeader(
                                  title: AppDictionary.requisitesLabel,
                                  hasError: _requisitesError,
                                )),
                              ],
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: CustomChipButton(
                                    label: AppDictionary.gosContractLabel,
                                    onTap: () => setState(() {
                                      contractSelected = !contractSelected;
                                      _contractError = false;
                                    }),
                                    selected: contractSelected,
                                  )),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: ResponsiveInputField(
                                      label: AppDictionary.dateIdLabel,
                                      controller: _contractRequisites,
                                      focusNode: null,
                                      enabled: contractSelected,
                                      readOnly: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: CustomChipButton(
                                    label: AppDictionary.subContractLabel,
                                    onTap: () => setState(() {
                                      subContractSelected = !subContractSelected;
                                      _contractError = false;
                                    }),
                                    selected: subContractSelected,
                                  )),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: ResponsiveInputField(
                                      label: AppDictionary.dateIdLabel,
                                      controller: _subContractRequisites,
                                      focusNode: null,
                                      enabled: subContractSelected,
                                      readOnly: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: CustomChipButton(
                                    label: AppDictionary.otherLabel,
                                    onTap: () => setState(() {
                                      otherSelected = !otherSelected;
                                      _contractError = false;
                                    }),
                                    selected: otherSelected,
                                  )),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: ResponsiveInputField(
                                      label: AppDictionary.textFieldLabel,
                                      controller: _otherField,
                                      focusNode: _otherFocusNode,
                                      enabled: otherSelected,
                                      readOnly: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            AppRoundedButton(
                              color: AppColors.green,
                              label: BtnLabel.continueBtn,
                              handler: () => _nextStepHandler(),
                              isProcessing: _processingStep,
                              labelStyle: AppTextStyle.roboto14W500.apply(
                                color: AppColors.primaryLight,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // Workaround
                            MediaQuery.of(context).viewInsets.bottom > 0
                                ? const SizedBox(
                                    height: 250,
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
              )
            ]);
          }),
    );
  }
}
