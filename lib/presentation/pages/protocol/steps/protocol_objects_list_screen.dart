import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/enums/protocol_status.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/objects_list_screen/object_info_block.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_object_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_territory_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_list_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_save_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';

class ProtocolObjectsListScreen extends StatefulWidget {
  const ProtocolObjectsListScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolObjectsListScreen> createState() => _ProtocolObjectsListScreenState();
}

class _ProtocolObjectsListScreenState extends State<ProtocolObjectsListScreen> {
  bool processingProtocol = false;

  /// Промежуточное сохранение данных по проекту (сохранение текущего объекта с данными ЗН)
  /// Переход на этап выбора территории
  void _proceedToNextObject() {
    StoreProvider.of<AppState>(context).dispatch(IncrementObjectIndex());
    StoreProvider.of<AppState>(context).dispatch(DropSelectedTerritory());
    if (StoreProvider.of<AppState>(context).state.protocolGeneralStepState.revision == true) {
      context.router.push(const ProtocolTerritoryRoute());
    } else {
      context.router.popUntilRouteWithName('ProtocolTerritoryRoute');
    }
  }

  void _toProtocolMediaFiles() {
    context.router.push(const ProtocolMediaFilesRoute());
  }

  Future<int?> _saveAndSendToApproval() async {
    setState(() => processingProtocol = true);
    final Completer<int?> completer = Completer();
    StoreProvider.of<AppState>(context).dispatch(saveDraft(completer: completer, newStatus: ProtocolStatus.approval));

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final List<GreenSpaceObject> objects = StoreProvider.of<AppState>(context).state.protocolCreateObjectState.savedItems;
    final List<Doc> docs = StoreProvider.of<AppState>(context).state.protocolGeneralStepState.docs;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverFillRemaining(
          child: Container(
            color: AppColors.white,
            // padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 370 > 0 ? MediaQuery.of(context).size.height - 370 : 0,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    // controller: widget.scrollController,
                    itemCount: objects.length,
                    itemBuilder: (_, int index) => ObjectInfoBlock(
                      count: (index + 1),
                      item: objects[index],
                      docs: docs,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                  child: Wrap(
                    runSpacing: 15.0,
                    children: [
                      AppRoundedButton(
                        color: AppColors.primaryLight,
                        label: BtnLabel.addNextObjectTerritory,
                        handler: _proceedToNextObject,
                        isProcessing: false,
                        labelStyle: AppTextStyle.roboto14W500.apply(
                          color: AppColors.green,
                        ),
                        loaderColor: AppColors.green,
                      ),
                      AppRoundedButton(
                        color: AppColors.green,
                        label: BtnLabel.saveAndAddFiles,
                        handler: _toProtocolMediaFiles,
                        isProcessing: false,
                        labelStyle: AppTextStyle.roboto14W500.apply(
                          color: AppColors.primaryLight,
                        ),
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
                                  completer: null, revision: StoreProvider.of<AppState>(context).state.protocolListState.revision ?? false, page: 1));
                              context.tabsRouter.setActiveIndex(0);
                            } else {
                              HelperUtils.showErrorMessage(context: context, message: GeneralErrors.generalError);
                            }
                            setState(() => processingProtocol = false);
                          });
                        },
                        isProcessing: processingProtocol,
                        disabled: processingProtocol,
                        labelStyle: AppTextStyle.roboto14W500.apply(
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
