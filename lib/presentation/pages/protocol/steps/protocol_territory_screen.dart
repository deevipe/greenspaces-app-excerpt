import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_territory_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_form_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_territory_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/custom_refresh_indicator.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/error_message_text.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_chip_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/input_block.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';
import 'package:redux/redux.dart';

class ProtocolTerritoryScreen extends StatefulWidget {
  const ProtocolTerritoryScreen({super.key});

  @override
  State<ProtocolTerritoryScreen> createState() => _ProtocolTerritoryScreenState();
}

class _ProtocolTerritoryScreenState extends State<ProtocolTerritoryScreen> {
  late ScrollController _scrollController;
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _searchTextController = TextEditingController();
  bool _nameFieldOpen = false;
  bool _addressError = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _nameFocusNode.dispose();
    _nameTextController.dispose();
    _searchTextController.dispose();
    super.dispose();
  }

  void _selectHandler({required int value, required String layerUrl}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final ProtocolTerritoryViewModel state = store.state.protocolTerritoryState;
    if (layerUrl.isEmpty) {
      // Предупредим пользователя, что ранее выбранный объект ОГС будет сброшен,
      // если он был выбран
      if (state.ogs != null && state.ogs?.id != null) {
        _dropOgsWarning(continueFunc: () {
          store.dispatch(
            UpdateTerritoryStepAction(selectedType: value, address: _nameTextController.text, ogs: null, typeUrl: layerUrl),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() => _nameFieldOpen = true);
          });
        });
      } else {
        store.dispatch(
          UpdateTerritoryStepAction(selectedType: value, address: _nameTextController.text, ogs: null, typeUrl: layerUrl),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() => _nameFieldOpen = true);
        });
      }
    } else {
      // Сохраняем объект ОГС
      store.dispatch(UpdateTerritoryStepAction(selectedType: value, address: state.address, ogs: state.ogs, typeUrl: layerUrl));
      Future.delayed(const Duration(milliseconds: 10), () {
        setState(() => _nameFieldOpen = false);
      });
    }
  }

  void _nextStepHandler() {
    FocusManager.instance.primaryFocus?.unfocus();
    ProtocolTerritoryViewModel state = StoreProvider.of<AppState>(context).state.protocolTerritoryState;

    if (state.selectedType != null) {
      String address = state.typeUrl.isNotEmpty ? state.address : _nameTextController.text;

      if (address == '') {
        setState(() {
          _addressError = true;
        });
        HelperUtils.showErrorMessage(
            context: context,
            message: (state.typeUrl.isNotEmpty && state.ogs == null || state.ogs?.id != null) ? GeneralErrors.selectOgs : GeneralErrors.fillAddress);
        return;
      }

      StoreProvider.of<AppState>(context)
          .dispatch(UpdateTerritoryStepAction(selectedType: state.selectedType!, address: address, typeUrl: state.typeUrl, ogs: state.ogs));
      context.router.push(ProtocolGreenSpaceRoute(address: address));
    } else {
      HelperUtils.showErrorMessage(context: context, message: GeneralErrors.emptyTerritory);
    }
  }

  dynamic _dropOgsWarning({required VoidCallback continueFunc}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        BtnLabel.cancel,
        style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        BtnLabel.confirm,
        style: AppTextStyle.openSans12W400.apply(color: AppColors.secondaryDark),
      ),
      onPressed: () {
        continueFunc();
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(AppDictionary.confirmTitle),
      content: const Text('Ранее выбранный Огс будет сброшен, продолжить?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<dynamic> _refreshCallback() {
    final Completer completer = Completer();
    StoreProvider.of<AppState>(context).dispatch(getTerritoryStep(completer));

    return completer.future;
  }

  void _openMap({required int? selectedTerritory}) {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final ProtocolTerritoryViewModel state = store.state.protocolTerritoryState;
    if (selectedTerritory != null && state.typeUrl.isNotEmpty) {
      context.router.push(MapRoute(layerUrl: state.typeUrl)).then((value) => ScaffoldMessenger.of(context).hideCurrentSnackBar());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: StoreConnector<AppState, ProtocolTerritoryViewModel>(
        converter: (store) => store.state.protocolTerritoryState,
        onInit: (store) {
          store.state.protocolTerritoryState.list.isNotEmpty ? null : store.dispatch(getTerritoryStep(null));

          if (store.state.protocolTerritoryState.typeUrl.isEmpty) {
            _nameFieldOpen = true;
            _nameTextController.text = store.state.protocolTerritoryState.address;
          }
        },
        onWillChange: (previousViewModel, newViewModel) {
          _nameTextController.text = (newViewModel.ogs != null && newViewModel.ogs?.id != null) ? '' : newViewModel.address;
        },
        distinct: true,
        builder: (_, state) {
          return CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              CupertinoSliverRefreshControl(
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
                onRefresh: () async => _refreshCallback(),
              ),
              state.isLoading
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(color: AppColors.primaryLight, child: const Loader()),
                    )
                  : state.isError == true
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                              color: AppColors.primaryLight, child: Center(child: ErrorMessageText(message: state.errorMessage ?? GeneralErrors.generalError))),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: 1,
                            (context, index) => Container(
                              color: AppColors.primaryLight,
                              padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const ProjectScreenHeader(
                                        title: ProtocolHeaderTitles.protocolFormTerritory,
                                        hasError: false,
                                      ),
                                      InkwellButton(
                                        function: () => _openMap(selectedTerritory: state.selectedType),
                                        child: SvgPicture.asset(
                                          AppIcons.mapIcon,
                                          color: (state.selectedType != null && state.typeUrl.isNotEmpty) ? AppColors.green : AppColors.dimmedDark,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  if (state.list.isNotEmpty)
                                    Column(
                                      children: List.generate(
                                        state.list.length,
                                        (index) => CustomChipButton(
                                          label: state.list[index].title,
                                          onTap: () => _selectHandler(
                                            value: int.parse(
                                              state.list[index].id,
                                            ),
                                            layerUrl: state.list[index].layerUrl,
                                          ),
                                          selected: state.selectedType == int.parse(state.list[index].id),
                                        ),
                                      ),
                                    ),
                                  AnimatedSize(
                                    curve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 500),
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: const BoxDecoration(color: AppColors.transparent),
                                      height: _nameFieldOpen ? null : 0.0,
                                      child: InputBlock(
                                        controller: _nameTextController,
                                        errorMessage: GeneralErrors.fillAddress,
                                        isError: _addressError,
                                        isPassword: false,
                                        isProcessing: false,
                                        label: AppDictionary.address,
                                        resetError: () {
                                          setState(() => _addressError = false);
                                        },
                                        errorAlignment: CrossAxisAlignment.start,
                                      ),
                                    ),
                                  ),
                                  if (state.address.isNotEmpty && state.ogs != null)
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          constraints: const BoxConstraints(minHeight: 37.0),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(5.0),
                                          margin: const EdgeInsets.only(bottom: 10.0),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                            border: Border(
                                              bottom: BorderSide(color: AppColors.green, width: 1),
                                              top: BorderSide(color: AppColors.green, width: 1),
                                              left: BorderSide(color: AppColors.green, width: 1),
                                              right: BorderSide(color: AppColors.green, width: 1),
                                            ),
                                          ),
                                          child: Text(
                                            state.address,
                                            style: AppTextStyle.roboto14W500.apply(
                                              color: AppColors.green,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  AppRoundedButton(
                                    color: AppColors.green,
                                    label: BtnLabel.continueBtn,
                                    handler: _nextStepHandler,
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
                              ),
                            ),
                          ),
                        ),
            ],
          );
        },
      ),
    );
  }
}
