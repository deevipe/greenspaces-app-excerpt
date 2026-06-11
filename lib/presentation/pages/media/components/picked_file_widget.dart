import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/enums/file_upload_entity_type.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/media_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_icon_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/upload_button_icon.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/upload_error_icon.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/upload_success_icon.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class PickedFileWidget extends StatelessWidget {
  final UploadingModel fileData;
  final int? protocolId;
  final int index;
  const PickedFileWidget({Key? key, required this.fileData, this.protocolId, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: AppDecorations.boxShadowDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.file_open_outlined),
              const SizedBox(height: 15.0),
              Text(
                fileData.file.name,
                style: AppTextStyle.openSans14W500,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5.0),
              AppIconButton(
                color: AppColors.green,
                loaderColor: AppColors.green,
                handler: () => StoreProvider.of<AppState>(context).dispatch(removeFile(file: fileData.file)),
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
                      BtnLabel.delete,
                      style: AppTextStyle.roboto14W500.apply(color: AppColors.primaryLight),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        if (fileData.uploading)
          Positioned.fill(
            child: Container(
              decoration: AppDecorations.transparentImageCover,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.0,
                    width: MediaQuery.of(context).size.width - 140,
                    child: fileData.totalBytes == 0
                        ? const Loader(
                            color: AppColors.green,
                          )
                        : LinearProgressIndicator(
                            backgroundColor: AppColors.primaryLight,
                            color: AppColors.green,
                            semanticsLabel: 'Загрузка',
                            value: fileData.totalBytes == 0 ? 0 : (fileData.uploadedBytes / fileData.totalBytes),
                          ),
                  ),
                ],
              ),
            ),
          ),
        if (!fileData.uploading)
          Positioned(
            top: 0.0,
            left: 0.0,
            child: InkwellButton(
              function: () {
                if (!fileData.uploadDone && !fileData.uploadError) {
                  if (protocolId != null) {
                    StoreProvider.of<AppState>(context).dispatch(
                      uploadFile(
                        elementId: protocolId!,
                        index: index,
                        pFile: fileData.file,
                        entityType: UploadEntityType.protocol,
                        photoForObject: false,
                      ),
                    );
                  } else {
                    HelperUtils.showErrorMessage(context: context, message: GeneralErrors.mediaErrorNoDraftId);
                  }
                }
              },
              child: fileData.uploadDone
                  ? const UploadDoneIcon()
                  : fileData.uploadError
                      ? const UploadErrorIcon()
                      : const UploadIcon(),
            ),
          ),
      ],
    );
  }
}
