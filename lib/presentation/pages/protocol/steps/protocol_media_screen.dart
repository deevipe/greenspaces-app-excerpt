import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/enums/file_upload_entity_type.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/media_carousel_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/media_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_icon_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class ProtocolMediaStepScreen extends StatefulWidget {
  final String? subTitle;
  final int? areaId;
  const ProtocolMediaStepScreen({super.key, @QueryParam() this.subTitle, @QueryParam() this.areaId});

  @override
  State<ProtocolMediaStepScreen> createState() => _ProtocolMediaStepScreenState();
}

class _ProtocolMediaStepScreenState extends State<ProtocolMediaStepScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addPhoto() {
    context.router.popAndPush(const CustomCameraRoute());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MediaViewModel>(
      converter: (store) => store.state.mediaState,
      distinct: true,
      builder: (context, state) {
        return CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Container(
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                      child: ProjectScreenHeader(title: ProtocolHeaderTitles.photo),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                      child: Text(
                        widget.subTitle ?? '',
                        style: AppTextStyle.roboto14W500,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    MediaCarouselWidget(
                      subTitle: widget.subTitle ?? '_',
                      entityType: UploadEntityType.work,
                      entityId: widget.areaId,
                      images: state.uploadQueue,
                      isProcessing: state.isProcessing,
                      isGeneral: false,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                      child: AppIconButton(
                        color: AppColors.green,
                        loaderColor: AppColors.green,
                        handler: _addPhoto,
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
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                      child: AppRoundedButton(
                        color: AppColors.green,
                        label: BtnLabel.continueBtn,
                        handler: () => context.router.pop(),
                        isProcessing: false,
                        labelStyle: AppTextStyle.roboto14W500.apply(
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
