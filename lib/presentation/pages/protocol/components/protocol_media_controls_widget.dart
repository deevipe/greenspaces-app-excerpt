import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/media_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class MediaControlsBlock extends StatelessWidget {
  final VoidCallback? mediaHandler;
  const MediaControlsBlock({
    Key? key,
    this.mediaHandler,
  }) : super(key: key);

  bool _anyFileUploaded(List<UploadingModel> files) {
    bool res = false;

    for (UploadingModel element in files) {
      if (element.uploadDone) {
        res = true;
      }
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StoreConnector<AppState, MediaViewModel>(
            converter: (store) => store.state.mediaState,
            distinct: true,
            builder: (_, state) {
              return InkwellButton(
                function: () => mediaHandler != null ? mediaHandler!() : null,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 50.0),
                  width: MediaQuery.of(context).size.width / 2 - 12.0,
                  height: 40.0,
                  child: SvgPicture.asset(
                    AppIcons.cameraIcon,
                    width: 38.0,
                    height: 34.0,
                    color: state.uploadQueue.isNotEmpty && _anyFileUploaded(state.uploadQueue) ? AppColors.green : AppColors.dimmedMedia,
                  ),
                ),
              );
            }),
      ],
    );
  }
}
