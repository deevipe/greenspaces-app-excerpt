import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/domain/enums/file_upload_entity_type.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/media_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/delete_button_icon.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/upload_button_icon.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/upload_error_icon.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/upload_success_icon.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MediaCarouselWidget extends StatefulWidget {
  final bool isGeneral; // Флаг по которому определяем загружать фото в общие или к конкретным работам
  final String subTitle;
  final List<UploadingModel> images;
  final bool isProcessing;
  final UploadEntityType entityType;
  final int? entityId; // это может быть id протокола / id элемента из areaList
  const MediaCarouselWidget({
    super.key,
    required this.subTitle,
    required this.images,
    required this.isProcessing,
    this.entityId,
    required this.entityType,
    required this.isGeneral,
  });

  @override
  State<MediaCarouselWidget> createState() => _MediaCarouselWidgetState();
}

class _MediaCarouselWidgetState extends State<MediaCarouselWidget> {
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

  List<UploadingModel> get _images => widget.images;
  bool get _isProcessing => widget.isProcessing;
  int? get _entityId => widget.entityId;
  UploadEntityType get _entityType => widget.entityType;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _images.isEmpty
              ? Center(
                  child: Image.asset(
                    AppImages.noImage,
                    fit: BoxFit.cover,
                    height: 125.0,
                    width: MediaQuery.of(context).size.width,
                  ),
                )
              : _isProcessing
                  ? const Center(
                      child: Loader(
                        color: AppColors.green,
                      ),
                    )
                  : CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                      ),
                      items: List.generate(
                        _images.length,
                        (index) => Stack(
                          children: [
                            Container(
                              decoration: AppDecorations.boxShadowDecoration,
                              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 15.0),
                              clipBehavior: Clip.hardEdge,
                              child: Center(
                                child: AssetEntityImage(
                                  _images[index].file,
                                  width: MediaQuery.of(context).size.width - 10.0,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                            if (_images[index].uploading)
                              Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 15.0),
                                  decoration: AppDecorations.transparentImageCover,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: MediaQuery.of(context).size.width - 140,
                                        child: _images[index].totalBytes == 0
                                            ? const Loader(
                                                color: AppColors.green,
                                              )
                                            : LinearProgressIndicator(
                                                backgroundColor: AppColors.primaryLight,
                                                color: AppColors.green,
                                                semanticsLabel: 'Загрузка',
                                                value: _images[index].totalBytes == 0 ? 0 : (_images[index].uploadedBytes / _images[index].totalBytes),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (!_images[index].uploading)
                              Positioned(
                                top: 12.0,
                                left: 12.0,
                                child: InkwellButton(
                                  function: () {
                                    if (!_images[index].uploadDone && !_images[index].uploadError) {
                                      if (_entityId != null) {
                                        // final AppState appState = StoreProvider.of<AppState>(context).state;
                                        StoreProvider.of<AppState>(context).dispatch(
                                          uploadFile(
                                            elementId: _entityId!,
                                            index: index,
                                            photo: _images[index].file,
                                            entityType: _entityType,
                                            photoForObject: widget.isGeneral ? false : true,
                                            customFileName: widget.subTitle,
                                          ),
                                        );
                                      } else {
                                        HelperUtils.showErrorMessage(context: context, message: GeneralErrors.mediaErrorNoDraftId);
                                      }
                                    }
                                  },
                                  child: _images[index].uploadDone
                                      ? const UploadDoneIcon()
                                      : _images[index].uploadError
                                          ? const UploadErrorIcon()
                                          : const UploadIcon(),
                                ),
                              ),
                            if (!_images[index].uploadDone)
                              Positioned(
                                top: 12.0,
                                right: 12.0,
                                child: InkwellButton(
                                  function: () => StoreProvider.of<AppState>(context).dispatch(removePicture(file: _images[index].file)),
                                  child: const DeleteIcon(),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}
