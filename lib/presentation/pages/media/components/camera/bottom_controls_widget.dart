import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/media_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_icon_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';
import 'package:photo_manager/photo_manager.dart';

const double _previewBoxSize = 50.0;

class CameraBottomControls extends StatelessWidget {
  final Orientation orientation;
  final List<AssetEntity> entity;
  final Function cameraCallback;
  final List<XFile> files;

  const CameraBottomControls({
    Key? key,
    required this.cameraCallback,
    required this.files,
    required this.entity,
    required this.orientation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MediaViewModel>(
      converter: (store) => store.state.mediaState,
      distinct: true,
      builder: (_, state) {
        List<Widget> children = [
          SizedBox(
            width: orientation == Orientation.portrait ? _previewBoxSize : 25.0,
            height:
                orientation == Orientation.portrait ? _previewBoxSize : 25.0,
            child: AppIconButton(
              round: true,
              color: AppColors.green,
              handler: () {
                context.router.pop();
              },
              icon: SvgPicture.asset(
                AppIcons.arrowLeft,
                color: AppColors.primaryLight,
                width: orientation == Orientation.portrait ? 23 : 12,
                height: orientation == Orientation.portrait ? 23 : 12,
              ),
              padding: orientation == Orientation.portrait ? null : 0,
            ),
          ),
          SizedBox(
            width: orientation == Orientation.portrait ? _previewBoxSize : 25.0,
            height:
                orientation == Orientation.portrait ? _previewBoxSize : 25.0,
            child: AppIconButton(
              round: true,
              color: AppColors.green,
              handler: cameraCallback,
              icon: Icon(
                Icons.camera_alt,
                size: orientation == Orientation.portrait ? 30 : 15,
              ),
              padding: 0,
            ),
          ),
          AnimatedOpacity(
            opacity: entity.isNotEmpty ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width:
                  orientation == Orientation.portrait ? _previewBoxSize : 25.0,
              height:
                  orientation == Orientation.portrait ? _previewBoxSize : 25.0,
              decoration: AppDecorations.thumbnailPictures,
              child: state.uploadQueue.isNotEmpty
                  ? Stack(
                      children: [
                        GestureDetector(
                          onTap: () => state.isProcessing
                              ? null
                              : context.router
                                  .popAndPush(const AppMediaGalleryRoute()),
                          child: SizedBox(
                            width: orientation == Orientation.portrait
                                ? _previewBoxSize
                                : 25.0,
                            height: orientation == Orientation.portrait
                                ? _previewBoxSize
                                : 25.0,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              child: AssetEntityImage(
                                state.uploadQueue.last.file,
                                isOriginal: false,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 3.0,
                          right: 3.0,
                          child: Text(
                            state.uploadQueue.length.toString(),
                            style: AppTextStyle.roboto14W500
                                .apply(color: AppColors.primaryLight),
                          ),
                        ),
                        if (state.isProcessing)
                          Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(7.0)),
                                color: AppColors.dark.withOpacity(.5),
                              ),
                              child: const Loader(
                                color: AppColors.green,
                                btn: true,
                              ),
                            ),
                          )
                      ],
                    )
                  : entity.isNotEmpty
                      ? Stack(
                          children: [
                            GestureDetector(
                              onTap: () => state.isProcessing
                                  ? null
                                  : context.router
                                      .popAndPush(const AppMediaGalleryRoute()),
                              child: SizedBox(
                                width: orientation == Orientation.portrait
                                    ? _previewBoxSize
                                    : 25.0,
                                height: orientation == Orientation.portrait
                                    ? _previewBoxSize
                                    : 25.0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  child: AssetEntityImage(
                                    entity[0],
                                    isOriginal: false,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            if (state.isProcessing)
                              Positioned(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(7.0)),
                                    color: AppColors.dark.withOpacity(.5),
                                  ),
                                  child: const Loader(
                                    color: AppColors.green,
                                    btn: true,
                                  ),
                                ),
                              ),
                          ],
                        )
                      : null,
            ),
          )
        ];
        return orientation == Orientation.portrait
            ? Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstraints.screenPadding),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: children,
                  ),
                ),
              )
            : Expanded(
                flex: 2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: children.reversed.toList(),
                  ),
                ),
              );
      },
    );
  }
}
