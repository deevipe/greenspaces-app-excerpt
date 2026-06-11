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
import 'package:gisogs_greenspacesapp/domain/enums/allowed_image_types.dart';
import 'package:gisogs_greenspacesapp/domain/enums/protocol_status.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_files_tab.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_photo_tab.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_list_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_save_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';

const double tabHeight = 45.0;

class ProtocolMediaFilesScreen extends StatefulWidget {
  const ProtocolMediaFilesScreen({super.key});

  @override
  State<ProtocolMediaFilesScreen> createState() => _ProtocolMediaFilesScreenState();
}

class _ProtocolMediaFilesScreenState extends State<ProtocolMediaFilesScreen> with TickerProviderStateMixin {
  bool processingProtocolToApproval = false;
  bool processingProtocolToHistory = false;
  final List<Doc> uploadedFiles = [];
  final List<Doc> uploadedPhotos = [];

  late TabController _tabController;
  final List<Widget> _tabs = [
    Container(
      color: AppColors.primaryLight,
      height: tabHeight,
      alignment: Alignment.center,
      child: const Text(
        BtnLabel.generalTab,
      ),
    ),
    Container(
      color: AppColors.primaryLight,
      height: tabHeight,
      alignment: Alignment.center,
      child: const Text(
        BtnLabel.photoTab,
      ),
    )
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _getGeneralDocs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _saveToDraft() {
    context.router.pop();
  }

  void _getGeneralDocs() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final List<Doc> docs = StoreProvider.of<AppState>(context).state.protocolGeneralStepState.docs;
      if (docs.isNotEmpty) {
        for (Doc item in docs) {
          if (item.documentType == '1') {
            final List<String> splitFullName = item.fullName != null ? item.fullName!.split('.') : [];
            if (splitFullName.isNotEmpty) {
              if (AllowedImageTypes.values.map((e) => e.name).toList().cast<String>().contains(splitFullName.last)) {
                uploadedPhotos.add(item);
              } else {
                uploadedFiles.add(item);
              }
            }
          }
        }
      }

      setState(() {});
    });
  }

  Future<void> _goToHistory() async {
    await _saveDraft(status: ProtocolStatus.draft).then((value) {
      if (value != null) {
        setState(() => processingProtocolToHistory = false);
        context.router.popAndPush(const ProtocolHistoryRoute());
      } else {
        HelperUtils.showErrorMessage(context: context, message: GeneralErrors.generalError);
      }
    });
  }

  Future<void> _sendToApproval() async {
    await _saveDraft(status: ProtocolStatus.approval).then((value) {
      if (value != null) {
        StoreProvider.of<AppState>(context).dispatch(resetAllFormSteps());
        setState(() => processingProtocolToApproval = false);
        context.router.popUntilRouteWithName('ProtocolFirstStepRoute');
        StoreProvider.of<AppState>(context)
            .dispatch(getProtocolList(completer: null, revision: StoreProvider.of<AppState>(context).state.protocolListState.revision ?? false, page: 1));
        context.tabsRouter.setActiveIndex(0);
      } else {
        HelperUtils.showErrorMessage(context: context, message: GeneralErrors.generalError);
      }
    });
  }

  Future<int?> _saveDraft({required ProtocolStatus status}) async {
    setState(() => status == ProtocolStatus.approval ? processingProtocolToApproval = true : processingProtocolToHistory = true);
    final Completer<int?> completer = Completer();
    StoreProvider.of<AppState>(context).dispatch(saveDraft(completer: completer, newStatus: status));

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const ProjectScreenHeader(title: ProtocolHeaderTitles.protocolMedia),
              SizedBox(
                height: tabHeight,
                child: TabBar(
                  indicatorColor: AppColors.primaryDark,
                  labelColor: AppColors.primaryDark,
                  labelStyle: AppTextStyle.openSans14W500,
                  unselectedLabelColor: AppColors.secondaryGrey,
                  controller: _tabController,
                  labelPadding: EdgeInsets.zero,
                  tabs: _tabs,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Flexible(
                fit: FlexFit.tight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ProtocolFilesTab(
                      uploadedFiles: uploadedFiles,
                    ),
                    ProtocolPhotoTab(uploadedPhotos: uploadedPhotos),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 20.0),
                  AppRoundedButton(
                    color: AppColors.green,
                    label: BtnLabel.saveDraftAndGoToProject,
                    handler: _saveToDraft,
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
                    label: BtnLabel.saveAndGoToHistory,
                    handler: _goToHistory,
                    isProcessing: processingProtocolToHistory,
                    disabled: processingProtocolToHistory,
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
                    handler: _sendToApproval,
                    isProcessing: processingProtocolToApproval,
                    disabled: processingProtocolToApproval,
                    labelStyle: AppTextStyle.roboto14W500.apply(
                      color: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              )
            ],
          )),
    );
  }
}
