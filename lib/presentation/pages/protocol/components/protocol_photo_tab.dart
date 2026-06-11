import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/file_upload_entity_type.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/media_carousel_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/objects_list_screen/file_modal_content.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/media_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_icon_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProtocolPhotoTab extends StatefulWidget {
  final List<Doc> uploadedPhotos;
  const ProtocolPhotoTab({Key? key, required this.uploadedPhotos}) : super(key: key);

  @override
  State<ProtocolPhotoTab> createState() => _ProtocolPhotoTabState();
}

class _ProtocolPhotoTabState extends State<ProtocolPhotoTab> {
  void _addPhoto(BuildContext context) {
    context.router.popAndPush(const CustomCameraRoute());
  }

  void _showItemFiles() {
    if (widget.uploadedPhotos.isNotEmpty) {
      showMaterialModalBottomSheet(
        useRootNavigator: true,
        expand: false,
        context: context,
        backgroundColor: AppColors.transparent,
        builder: (context) => FileModalContent(
          photos: widget.uploadedPhotos,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MediaViewModel>(
      converter: (store) => store.state.mediaState,
      distinct: true,
      builder: (context, state) {
        return Container(
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.uploadedPhotos.isNotEmpty)
                InkwellButton(
                  function: _showItemFiles,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${ProtocolHeaderTitles.uploadedPhoto} (${widget.uploadedPhotos.length})'),
                        const Icon(
                          Icons.remove_red_eye,
                          color: AppColors.green,
                        )
                      ],
                    ),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                child: ProjectScreenHeader(title: ProtocolHeaderTitles.photo),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                child: AppIconButton(
                  color: AppColors.green,
                  loaderColor: AppColors.green,
                  handler: () => _addPhoto(context),
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
                        BtnLabel.addPhotos,
                        style: AppTextStyle.roboto14W500.apply(color: AppColors.primaryLight),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              MediaCarouselWidget(
                subTitle: '_',
                entityType: UploadEntityType.protocol,
                entityId: StoreProvider.of<AppState>(context).state.protocolGeneralStepState.draftId,
                images: state.uploadQueue,
                isProcessing: state.isProcessing,
                isGeneral: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
