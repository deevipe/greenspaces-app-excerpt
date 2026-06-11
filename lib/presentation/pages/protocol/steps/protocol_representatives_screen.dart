import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/representatives/organisation_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/representatives/other_block_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_representatives_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_representatives_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_representatives_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/custom_bottom_sheet.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/custom_refresh_indicator.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/error_message_text.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProtocolRepresentativesScreen extends StatefulWidget {
  const ProtocolRepresentativesScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolRepresentativesScreen> createState() => _ProtocolRepresentativesScreenState();
}

class _ProtocolRepresentativesScreenState extends State<ProtocolRepresentativesScreen> {
  late ScrollController _scrollController;
  final ScrollController _committeeScroll = ScrollController();
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _otherFioController = TextEditingController();
  final TextEditingController _otherPhoneController = TextEditingController();
  final TextEditingController _otherPositionController = TextEditingController();
  final FocusNode _otherFocusNode = FocusNode();
  final FocusNode _otherFioFocusNode = FocusNode();
  final FocusNode _otherPhoneFocusNode = FocusNode();
  final FocusNode _otherPositionFocusNode = FocusNode();

  final Map<String, TextEditingController> _generatedControllers = {};
  final Map<String, ValueNotifier> _generatedNotifiers = {};
  final Map<UniqueKey, Widget> _committeeWidgets = {};
  final Map<UniqueKey, Widget> _sppWidgets = {};
  final List<Widget> _committeeWidgetsList = [];
  final List<Widget> _sppWidgetsList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _otherFioController.addListener(_otherBlockInputsListener);
    _otherPhoneController.addListener(_otherBlockInputsListener);
    _otherPositionController.addListener(_otherBlockInputsListener);
    _otherFocusNode.addListener(_focusNodeListener);
    _otherFioFocusNode.addListener(_focusNodeListener);
    _otherPhoneFocusNode.addListener(_focusNodeListener);
    _otherPositionFocusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    _otherFocusNode.removeListener(_focusNodeListener);
    _otherFioFocusNode.removeListener(_focusNodeListener);
    _otherPhoneFocusNode.removeListener(_focusNodeListener);
    _otherPositionFocusNode.removeListener(_focusNodeListener);

    _otherFioController.removeListener(_otherBlockInputsListener);
    _otherPhoneController.removeListener(_otherBlockInputsListener);
    _otherPositionController.removeListener(_otherBlockInputsListener);

    _scrollController.dispose();
    _committeeScroll.dispose();
    _otherController.dispose();
    _otherPhoneController.dispose();
    _otherPositionController.dispose();
    _otherFocusNode.dispose();
    _otherFioController.dispose();
    _otherPhoneFocusNode.dispose();
    _otherPositionFocusNode.dispose();
    _otherFioFocusNode.dispose();
    if (_generatedControllers.isNotEmpty) {
      _generatedControllers.forEach((_, controller) {
        controller.dispose();
      });
    }
    super.dispose();
  }

  void _focusNodeListener() async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && (_otherFocusNode.hasFocus)) {
        _scrollController.animateTo(150, curve: Curves.easeIn, duration: const Duration(milliseconds: 500));
      }
      if (mounted && (_otherFioFocusNode.hasFocus || _otherPhoneFocusNode.hasFocus || _otherPositionFocusNode.hasFocus)) {
        _scrollController.animateTo(250, curve: Curves.easeIn, duration: const Duration(milliseconds: 500));
      }
    });
  }

  void _otherBlockInputsListener() {
    final ProtocolRepresentativesViewModel state = StoreProvider.of<AppState>(context).state.protocolRepresentativesState;
    StoreProvider.of<AppState>(context).dispatch(
      ToggleStepValidationError(
          validationFailed: state.validationFailed,
          fillFio: state.selectedOtherOrg != null && _otherFioController.text.isEmpty,
          fillPhone: state.selectedOtherOrg != null && _otherPhoneController.text.isEmpty,
          fillPosition: state.selectedOtherOrg != null && _otherPositionController.text.isEmpty),
    );
  }

  Future<dynamic> refreshCallback() {
    final Completer completer = Completer();
    StoreProvider.of<AppState>(context).dispatch(getRepresentativeSelects(completer));

    return completer.future;
  }

  void _nextStepHandler() async {
    bool isValid = true;
    final ProtocolRepresentativesViewModel state = StoreProvider.of<AppState>(context).state.protocolRepresentativesState;

    // Пробежим поочередно по спискам Representative. Если где-то один из объектов
    // имеет пустой org_id или user_id, то выдадим ошибку
    for (Representative element in state.committeeRepresentatives) {
      if (element.representativeId == null || element.userId == null) {
        isValid = false;
      }
    }
    for (Representative element in state.sppRepresentatives) {
      if (element.representativeId == null || element.userId == null) {
        isValid = false;
      }
    }

    // Если выбрана иная организация, то ждём заполнения всех доп.полей
    if (state.selectedOtherOrg != null && state.selectedOtherOrg!.isNotEmpty) {
      if (_otherFioController.text.isEmpty || _otherPhoneController.text.isEmpty || _otherPositionController.text.isEmpty) {
        isValid = false;
      }
    }

    if (isValid) {
      // сохраним еще раз в стейт значения полей Иное
      StoreProvider.of<AppState>(context).dispatch(
        UpdateSelectChoice(
          widgetKey: null,
          otherFieldFio: _otherFioController.text,
          otherFieldPhone: _otherPhoneController.text,
          otherFieldPosition: _otherPositionController.text,
        ),
      );

      if (StoreProvider.of<AppState>(context).state.protocolGeneralStepState.revision == true) {
        context.router.push(const ProtocolObjectsListRoute());
      } else {
        context.router.push(const ProtocolTerritoryRoute());
      }
    } else {
      StoreProvider.of<AppState>(context).dispatch(
        ToggleStepValidationError(
            validationFailed: true,
            fillFio: _otherFioController.text.isEmpty,
            fillPhone: _otherPhoneController.text.isEmpty,
            fillPosition: _otherPositionController.text.isEmpty),
      );
    }
  }

  void deleteAdditionalBlock({required int index, required OrganizationType type, required UniqueKey widgetKey}) {
    StoreProvider.of<AppState>(context).dispatch(
      removeRepresentativeBlock(orgType: type, index: index, widgetKey: widgetKey),
    );
  }

  void onSelectChangeHandler({required UniqueKey widgetKey, required int index, required OrganizationType orgType}) {
    ProtocolRepresentativesViewModel state = StoreProvider.of<AppState>(context).state.protocolRepresentativesState;

    final List<Representative> currentListByType =
        orgType == OrganizationType.committee ? List.from(state.committeeRepresentatives) : List.from(state.sppRepresentatives);

    final String? selectedOrgValue = _generatedNotifiers['${widgetKey}_${index}_org']?.value;
    final String? selectedUserValue = _generatedNotifiers['${widgetKey}_${index}_user']?.value;

    // Если меняется значение выбранной организации
    if (selectedOrgValue != null && currentListByType[index].representativeId.toString() != selectedOrgValue.split('_').first) {
      // Сбросим выбранного юзера для заданного блока
      if (_generatedNotifiers['${widgetKey}_${index}_user']?.value != null) {
        _generatedNotifiers['${widgetKey}_${index}_user']?.value = null;
      }
      // Обновим данные представителей текущих, чтобы обновить их в redux state

      final int? orgId = selectedUserValue != null
          ? state.usersForSelects[widgetKey]!.firstWhere((element) => element.id == int.parse(selectedUserValue.split('_').first)).orgId
          : null;

      final int representativeId = int.parse(selectedOrgValue.split('_').first);

      currentListByType[index] = currentListByType[index].copyWith(
        orgId: orgId,
        representativeId: representativeId,
        orgName: selectedOrgValue.split('_').last,
      );

      StoreProvider.of<AppState>(context)
          .dispatch(getCommitteeUsers(committeeId: selectedOrgValue, widgetKey: widgetKey, spp: orgType == OrganizationType.spp));
    }

    // Если выбирается представитель организации
    if (selectedUserValue != null && currentListByType[index].userId.toString() != selectedUserValue.split('_').first) {
      final OrganisationUser? selectedUser = state.usersForSelects[widgetKey]?.firstWhereOrNull((element) {
        return element.id.toString() == selectedUserValue.split('_').first;
      });

      final int orgId = state.usersForSelects[widgetKey]!.firstWhere((element) => element.id == int.parse(selectedUserValue.split('_').first)).orgId;

      final int? representativeId = selectedOrgValue != null ? int.parse(selectedOrgValue.split('_').first) : null;

      currentListByType[index] = currentListByType[index].copyWith(
        userId: selectedUser?.id,
        orgId: orgId,
        representativeId: representativeId,
        userName: selectedUser?.fio,
        userPhone: selectedUser?.tel,
        userPosition: selectedUser?.position,
      );
    }

    StoreProvider.of<AppState>(context).dispatch(
      UpdateSelectChoice(
        widgetKey: widgetKey,
        committeeRepresentatives: orgType == OrganizationType.committee ? currentListByType : null,
        sppRepresentatives: orgType == OrganizationType.spp ? currentListByType : null,
        otherFieldFio: _otherFioController.text,
        otherFieldPhone: _otherPhoneController.text,
        otherFieldPosition: _otherPositionController.text,
      ),
    );
  }

  void _processRepresentatives({required List<Representative> list, required OrganizationType type}) {
    final ProtocolRepresentativesViewModel state = StoreProvider.of<AppState>(context).state.protocolRepresentativesState;

    bool updateAllWidgets = state.validationFailed;

    final List<Representative> currentList = (type == OrganizationType.committee) ? state.committeeRepresentatives : state.sppRepresentatives;
    final Map<UniqueKey, Widget> currentWidgetMap = (type == OrganizationType.committee) ? _committeeWidgets : _sppWidgets;
    final List<Widget> currentWidgetList = (type == OrganizationType.committee) ? _committeeWidgetsList : _sppWidgetsList;

    if (currentList.length == currentWidgetMap.length) {
      if (state.widgetKey != null) {
        Widget? processedWidget = currentWidgetMap[state.widgetKey];
        int? widgetListIndex;

        currentWidgetList.forEachIndexed((index, element) {
          if (element.key == state.widgetKey) {
            widgetListIndex = index;
          }
        });

        if (processedWidget != null) {
          processedWidget = OrganisationWidget(
            key: state.widgetKey,
            searchController: _generatedControllers['${state.widgetKey}']!,
            selectedOrg: _generatedNotifiers['${state.widgetKey}_${widgetListIndex}_org'] as ValueNotifier<String?>,
            onSelect: () {
              onSelectChangeHandler(widgetKey: state.widgetKey!, index: widgetListIndex!, orgType: type);
            },
            selectedUser: _generatedNotifiers['${state.widgetKey}_${widgetListIndex}_user'] as ValueNotifier<String?>,
            type: type,
            committeeList: state.committeeList,
            isProcessing: (type == OrganizationType.committee) ? state.fetchingDependencies ?? false : state.fetchingSppDependencies ?? false,
            sppList: state.sppList,
            usersForSelect: state.usersForSelects,
            deleteAction: () => deleteAdditionalBlock(index: widgetListIndex!, type: type, widgetKey: state.widgetKey!),
            deletable: widgetListIndex != 0 && widgetListIndex != null,
            validationFailed: state.validationFailed,
          );
          updateOrgWidget(index: widgetListIndex!, type: type, widget: processedWidget);
          return;
        } else {
          return;
        }
      }
    }

    // В случае, если у нас есть widgetKey, происходит удаление элемента
    // Можно так же сравнивать с currentWidgetsMap
    if (state.widgetKey != null && currentList.length < currentWidgetList.length) {
      // Удалим сначала данные из соответветсвующих Map и List
      updateAllWidgets = true;
      currentWidgetMap.removeWhere((key, value) => key == state.widgetKey);
      currentWidgetList.removeWhere((element) => element.key == state.widgetKey);
    }

    for (int i = 0; i < currentList.length; i++) {
      if (currentWidgetList.isNotEmpty && i < currentWidgetList.length && !updateAllWidgets) {
        continue;
      }

      String? orgSelected =
          (currentList[i].representativeId != null && currentList[i].orgName != null) ? '${currentList[i].representativeId}_${currentList[i].orgName}' : null;
      String? userSelected = (currentList[i].userId != null && currentList[i].userName != null) ? '${currentList[i].userId}_${currentList[i].userName}' : null;

      final UniqueKey key = updateAllWidgets ? currentWidgetList[i].key! as UniqueKey : UniqueKey();
      final TextEditingController searchController = TextEditingController();
      final ValueNotifier<String?> orgNotifier = ValueNotifier(orgSelected);
      final ValueNotifier<String?> userNotifier = ValueNotifier(userSelected);

      Map<UniqueKey, List<OrganisationUser>> preparedUsers = {};

      if (type == OrganizationType.committee) {
        _committeeWidgets[key] = OrganisationWidget(
          key: key,
          searchController: searchController,
          selectedOrg: orgNotifier,
          onSelect: () {
            onSelectChangeHandler(widgetKey: key, index: i, orgType: type);
          },
          selectedUser: userNotifier,
          type: type,
          committeeList: state.committeeList,
          isProcessing: false,
          sppList: state.sppList,
          // Используем функцию для заполнения списка пользователей для выбора
          // при редактировании внутри данного экрана, так как этот список привязан к
          // ключам виджетов
          usersForSelect: _prepareUsersForSelects(
            preparedList: preparedUsers,
            widgetKey: key,
            selectedOrg: orgSelected,
            type: type,
          ),
          deleteAction: () => deleteAdditionalBlock(index: i, type: type, widgetKey: key),
          deletable: i > 0,
          validationFailed: state.validationFailed,
        );
      } else {
        _sppWidgets[key] = OrganisationWidget(
          key: key,
          searchController: searchController,
          selectedOrg: orgNotifier,
          onSelect: () {
            onSelectChangeHandler(widgetKey: key, index: i, orgType: type);
          },
          selectedUser: userNotifier,
          type: type,
          committeeList: state.committeeList,
          isProcessing: false,
          sppList: state.sppList,
          // Используем функцию для заполнения списка пользователей для выбора
          // при редактировании внутри данного экрана, так как этот список привязан к
          // ключам виджетов
          usersForSelect: _prepareUsersForSelects(
            preparedList: preparedUsers,
            widgetKey: key,
            selectedOrg: orgSelected,
            type: type,
          ),
          deleteAction: () => deleteAdditionalBlock(index: i, type: type, widgetKey: key),
          deletable: i > 0,
          validationFailed: state.validationFailed,
        );
      }

      _generatedControllers['$key'] = searchController;
      // Ключ состоит из уникального ключа виджета и индекса представителя,
      // чтобы в дальнейшем можно было легко определить какие изменения необходимо
      // сделать и где
      _generatedNotifiers['${key}_${i}_org'] = orgNotifier;
      _generatedNotifiers['${key}_${i}_user'] = userNotifier;

      // Здесь нужно учесть момент, когда данный экран предзаполняется данными
      // при редактировании проекта / доработках протокола
      if (state.usersForSelects.isEmpty && orgSelected != null) {
        StoreProvider.of<AppState>(context)
            .dispatch(getCommitteeUsers(committeeId: orgSelected.split('_').first, widgetKey: key, spp: type == OrganizationType.spp));
      }
    }
    _convertMapToList(update: updateAllWidgets);
  }

  Map<UniqueKey, List<OrganisationUser>> _prepareUsersForSelects(
      {required UniqueKey widgetKey,
      required String? selectedOrg,
      required OrganizationType type,
      required Map<UniqueKey, List<OrganisationUser>> preparedList}) {
    ProtocolRepresentativesViewModel state = StoreProvider.of<AppState>(context).state.protocolRepresentativesState;

    if (selectedOrg != null && state.usersForSelects[widgetKey] != null) {
      return state.usersForSelects;
    } else {
      final List<Organisation> orgs = type == OrganizationType.committee ? state.committeeList : state.sppList;

      if (selectedOrg != null) {
        for (var org in orgs) {
          if (org.id.toString() == selectedOrg.split('_').first) {
            preparedList[widgetKey] = org.members;
          }
        }
      }
      return preparedList;
    }
  }

  void _addAdditionalBlocks({required OrganizationType type}) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    StoreProvider.of<AppState>(context).dispatch(addRepresentativeBlock(orgType: type));
  }

  void _convertMapToList({required bool update}) {
    if (update) {
      // Переопределим значение функции в мапе и списке виджетов
      _committeeWidgetsList.clear();
      _sppWidgetsList.clear();
    }
    if (_committeeWidgets.isNotEmpty) {
      _committeeWidgets.forEach((_, item) {
        final Widget? containedWidget = _committeeWidgetsList.firstWhereOrNull((element) => element.key == item.key);
        if (containedWidget == null) {
          _committeeWidgetsList.add(item);
        }
      });
    }
    if (_sppWidgets.isNotEmpty) {
      _sppWidgets.forEach((_, item) {
        final Widget? containedWidget = _sppWidgetsList.firstWhereOrNull((element) => element.key == item.key);
        if (containedWidget == null) {
          _sppWidgetsList.add(item);
        }
      });
    }
    setState(() {});
  }

  void updateOrgWidget({required int index, required OrganizationType type, required Widget widget}) {
    if (type == OrganizationType.committee) {
      _committeeWidgetsList[index] = widget;
    } else {
      _sppWidgetsList[index] = widget;
    }

    setState(() {});
  }

  void _updateOtherBlock({required ProtocolRepresentativesViewModel state}) {
    if (state.selectedOtherOrg != null && state.selectedOtherOrg != '') {
      _otherController.text = state.selectedOtherOrg!.split('_').last;
      if (state.otherFieldFio != null && state.otherFieldFio!.isNotEmpty) {
        _otherFioController.text = state.otherFieldFio!;
      }

      if (state.otherFieldPhone != null && state.otherFieldPhone!.isNotEmpty) {
        _otherPhoneController.text = state.otherFieldPhone!;
      }

      if (state.otherFieldPosition != null && state.otherFieldPosition!.isNotEmpty) {
        _otherPositionController.text = state.otherFieldPosition!;
      }
    } else {
      _otherController.text = '';
      _otherFioController.text = '';
      _otherPhoneController.text = '';
      _otherPositionController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtocolRepresentativesViewModel>(
      converter: (store) => store.state.protocolRepresentativesState,
      distinct: true,
      onInitialBuild: (state) {
        _processRepresentatives(list: state.committeeRepresentatives, type: OrganizationType.committee);
        _processRepresentatives(list: state.sppRepresentatives, type: OrganizationType.spp);
      },
      onInit: (store) {
        final ProtocolRepresentativesViewModel state = store.state.protocolRepresentativesState;
        if (state.committeeList.isEmpty && state.sppList.isEmpty) {
          store.dispatch(getRepresentativeSelects(null));
        }
        _updateOtherBlock(state: state);
      },
      onWillChange: (_, state) {
        _processRepresentatives(list: state.committeeRepresentatives, type: OrganizationType.committee);
        _processRepresentatives(list: state.sppRepresentatives, type: OrganizationType.spp);
        _updateOtherBlock(state: state);
      },
      onDispose: (store) => store.dispatch(
        UpdateSelectChoice(
          widgetKey: null,
          otherFieldFio: _otherFioController.text,
          otherFieldPhone: _otherPhoneController.text,
          otherFieldPosition: _otherPositionController.text,
        ),
      ),
      builder: (_, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  CupertinoSliverRefreshControl(
                    key: UniqueKey(),
                    refreshTriggerPullDistance: 150,
                    builder: (
                      BuildContext context,
                      RefreshIndicatorMode refreshState,
                      double pulledExtent,
                      double refreshTriggerPullDistance,
                      double refreshIndicatorExtent,
                    ) {
                      return CustomRefreshIndicator(
                        refreshState: refreshState,
                        pulledExtent: pulledExtent,
                        refreshTriggerPullDistance: refreshTriggerPullDistance,
                        refreshIndicatorExtent: refreshIndicatorExtent,
                      );
                    },
                    onRefresh: () async => refreshCallback(),
                  ),
                  (state.isLoading || state.isError == true)
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            color: AppColors.primaryLight,
                            padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ProjectScreenHeader(title: ProtocolHeaderTitles.protocolFormRepresentatives),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                if (state.isLoading)
                                  const Expanded(
                                    child: Center(
                                      child: Loader(),
                                    ),
                                  ),
                                if (state.isError == true)
                                  Expanded(
                                    child: Center(
                                      child: ErrorMessageText(message: state.errorMessage ?? GeneralErrors.generalError),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Container(
                              color: AppColors.primaryLight,
                              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ProjectScreenHeader(title: ProtocolHeaderTitles.protocolFormRepresentatives),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  ..._committeeWidgetsList,
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Divider(
                                      height: 20,
                                    ),
                                  ),
                                  ..._sppWidgetsList,
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 0.0, top: 10.0),
                                    child: Divider(
                                      height: 20,
                                    ),
                                  ),
                                  const ProjectScreenHeader(
                                    title: AppDictionary.otherLabel,
                                    margin: EdgeInsets.only(top: 10, bottom: 0.0),
                                  ),
                                  OtherRepresentativeBlock(
                                    state: state,
                                    otherController: _otherController,
                                    otherFioController: _otherFioController,
                                    otherPhoneController: _otherPhoneController,
                                    otherPositionController: _otherPositionController,
                                    otherFocusNode: _otherFocusNode,
                                    otherPhoneFocusNode: _otherPhoneFocusNode,
                                    otherPositionFocusNode: _otherPositionFocusNode,
                                    otherFioFocusNode: _otherFioFocusNode,
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
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  MediaQuery.of(context).viewInsets.bottom > 0
                                      ? const SizedBox(
                                          height: 250,
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                            childCount: 1,
                          ),
                        ),
                ],
              ),
              Positioned(
                bottom: 25.0,
                right: 15.0,
                child: Container(
                  width: 45.0,
                  height: 45.0,
                  clipBehavior: Clip.hardEdge,
                  decoration: AppDecorations.floatingButton,
                  child: InkwellButton(
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                    ),
                    function: () {
                      showMaterialModalBottomSheet(
                        useRootNavigator: true,
                        expand: false,
                        context: context,
                        backgroundColor: AppColors.transparent,
                        builder: (context) => _AddRepresentativeBlock(
                          addCommittee: () => _addAdditionalBlocks(type: OrganizationType.committee),
                          addSpp: () => _addAdditionalBlocks(type: OrganizationType.spp),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _AddRepresentativeBlock extends StatelessWidget {
  final VoidCallback addCommittee;
  final VoidCallback addSpp;
  const _AddRepresentativeBlock({Key? key, required this.addCommittee, required this.addSpp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: 170.0,
      child: Expanded(
        child: Column(children: [
          AppRoundedButton(
            color: AppColors.green,
            labelStyle: AppTextStyle.openSans14W700,
            label: AppDictionary.addCommittee,
            handler: addCommittee,
            isProcessing: false,
          ),
          const SizedBox(
            height: 10.0,
          ),
          AppRoundedButton(
            color: AppColors.green,
            labelStyle: AppTextStyle.openSans14W700,
            label: AppDictionary.addSpp,
            handler: addSpp,
            isProcessing: false,
          ),
        ]),
      ),
    );
  }
}
