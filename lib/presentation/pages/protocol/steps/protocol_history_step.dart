import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/enums/protocol_status.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/app_navigation_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_list_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_save_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_history.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_form_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_history_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/error_message_text.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';

class ProtocolHistoryScreen extends StatefulWidget {
  const ProtocolHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolHistoryScreen> createState() => _ProtocolHistoryScreenState();
}

class _ProtocolHistoryScreenState extends State<ProtocolHistoryScreen> {
  bool processingProtocol = false;

  void _goToObjectList() {
    context.router.pop();
  }

  void _goHome() {
    StoreProvider.of<AppState>(context).dispatch(resetAllFormSteps());
    StoreProvider.of<AppState>(context).dispatch(UpdateAppNavigation(formIsOpen: false));
    context.router.popUntilRouteWithName('ProtocolFirstStepRoute');
    StoreProvider.of<AppState>(context)
        .dispatch(getProtocolList(completer: null, revision: StoreProvider.of<AppState>(context).state.protocolListState.revision ?? false, page: 1));
    context.tabsRouter.setActiveIndex(0);
  }

  Future<int?> _saveAndSendToApproval() async {
    setState(() => processingProtocol = true);
    final Completer<int?> completer = Completer();
    // Очистим пока что тут состояния всех экранов формы
    StoreProvider.of<AppState>(context).dispatch(saveDraft(completer: completer, newStatus: ProtocolStatus.approval));

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtocolHistoryViewModel>(
      converter: (store) => store.state.protocolHistoryState,
      onInit: (store) => store.dispatch(getCurrentDraftHistory()),
      distinct: true,
      builder: (_, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverFillRemaining(
              child: Container(
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                      child: ProjectScreenHeader(title: ProtocolHeaderTitles.changesHistory),
                    ),
                    state.isLoading
                        ? const Expanded(
                            child: Center(
                              child: Loader(),
                            ),
                          )
                        : state.isError == true
                            ? Expanded(
                                child: Center(
                                  child: ErrorMessageText(message: state.errorMessage ?? GeneralErrors.generalError),
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height - 435,
                                    child: state.history.isNotEmpty
                                        ? ListView.builder(
                                            itemBuilder: (context, index) => _HistoryBlock(
                                              item: state.history[index],
                                            ),
                                            itemCount: state.history.length,
                                          )
                                        : const Center(
                                            child: ErrorMessageText(message: GeneralErrors.emptyProtocolDraft),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding, vertical: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AppRoundedButton(
                                          color: AppColors.green,
                                          label: BtnLabel.goBackTobjectList,
                                          handler: _goToObjectList,
                                          isProcessing: false,
                                          labelStyle: AppTextStyle.roboto14W500.apply(
                                            color: AppColors.primaryLight,
                                          ),
                                          loaderColor: AppColors.green,
                                        ),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                        AppRoundedButton(
                                          color: AppColors.green,
                                          label: BtnLabel.goToHomePage,
                                          handler: _goHome,
                                          isProcessing: false,
                                          labelStyle: AppTextStyle.roboto14W500.apply(
                                            color: AppColors.primaryLight,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                        AppRoundedButton(
                                          color: AppColors.green,
                                          label: BtnLabel.saveAndSend,
                                          handler: () async {
                                            await _saveAndSendToApproval().then((value) {
                                              if (value != null) {
                                                StoreProvider.of<AppState>(context).dispatch(resetAllFormSteps());
                                                context.router.popUntilRouteWithName('ProtocolFirstStepRoute');
                                                StoreProvider.of<AppState>(context).dispatch(getProtocolList(
                                                    completer: null,
                                                    revision: StoreProvider.of<AppState>(context).state.protocolListState.revision ?? false,
                                                    page: 1));
                                                context.tabsRouter.setActiveIndex(0);
                                              } else {
                                                HelperUtils.showErrorMessage(context: context, message: GeneralErrors.generalError);
                                              }
                                              setState(() => processingProtocol = false);
                                            });
                                          },
                                          isProcessing: false,
                                          labelStyle: AppTextStyle.roboto14W500.apply(
                                            color: AppColors.primaryLight,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HistoryBlock extends StatelessWidget {
  final ProtocolHistory item;
  const _HistoryBlock({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3.0),
      color: AppColors.green,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 13.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Дата: ${item.date}',
            style: AppTextStyle.openSans14W500.apply(color: AppColors.primaryLight),
          ),
          const SizedBox(height: 3.0),
          Text(
            'Пользователь: ${item.userName}',
            style: AppTextStyle.openSans14W400.apply(color: AppColors.primaryLight),
          ),
          const SizedBox(height: 3.0),
          Text(
            'Действие: ${item.actionType}',
            style: AppTextStyle.openSans14W400.apply(color: AppColors.primaryLight),
          ),
          const SizedBox(height: 3.0),
        ],
      ),
    );
  }
}
