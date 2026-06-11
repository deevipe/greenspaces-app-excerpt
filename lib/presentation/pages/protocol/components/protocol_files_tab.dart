// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/media/components/picked_file_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_file_tab/general_file_modal_content.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/media_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/files_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_icon_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProtocolFilesTab extends StatefulWidget {
  final List<Doc> uploadedFiles;
  const ProtocolFilesTab({Key? key, required this.uploadedFiles}) : super(key: key);

  @override
  State<ProtocolFilesTab> createState() => _ProtocolFilesTabState();
}

class _ProtocolFilesTabState extends State<ProtocolFilesTab> {
  void _addFiles(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<PlatformFile> platformFiles = result.files;
      StoreProvider.of<AppState>(context).dispatch(bulkAddFiles(list: platformFiles));
    } else {
      if (kDebugMode) {
        print('FILE PICKING CANCELLED');
      }
      // User canceled the picker
    }
  }

  void _showItemFiles() {
    if (widget.uploadedFiles.isNotEmpty) {
      showMaterialModalBottomSheet(
        useRootNavigator: true,
        expand: false,
        context: context,
        backgroundColor: AppColors.transparent,
        builder: (context) => GeneralFileModalContent(
          files: widget.uploadedFiles,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FilesViewModel>(
      converter: (store) => store.state.mediaFileState,
      distinct: true,
      builder: (context, state) {
        return Container(
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.uploadedFiles.isNotEmpty)
                InkwellButton(
                  function: _showItemFiles,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${ProtocolHeaderTitles.uploadedDocs} (${widget.uploadedFiles.length})'),
                        const Icon(
                          Icons.remove_red_eye,
                          color: AppColors.green,
                        )
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ProjectScreenHeader(title: ProtocolHeaderTitles.docs),
                    if (state.uploadQueue.isNotEmpty) Text('Выбрано: ${state.uploadQueue.length}')
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                child: AppIconButton(
                  color: AppColors.green,
                  loaderColor: AppColors.green,
                  handler: () => _addFiles(context),
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppIcons.plusIcon,
                        width: 18.0,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        BtnLabel.addPFiles,
                        style: AppTextStyle.roboto14W500.apply(color: AppColors.primaryLight),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              if (state.uploadQueue.isNotEmpty)
                SizedBox(
                  height: 290,
                  child: GridView.builder(
                    itemCount: state.uploadQueue.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemBuilder: (context, index) => PickedFileWidget(
                      protocolId: StoreProvider.of<AppState>(context).state.protocolGeneralStepState.draftId,
                      fileData: state.uploadQueue[index],
                      index: index,
                    ),
                  ),
                ),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        );
      },
    );
  }
}
