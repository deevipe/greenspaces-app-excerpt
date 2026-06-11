import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/media/components/image_item_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/media_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/media_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/text_link.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/shimmer_loading/shimmer_general.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/shimmer_loading/shimmer_loader.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:photo_manager/photo_manager.dart';

class AppMediaGalleryScreen extends StatefulWidget {
  const AppMediaGalleryScreen({Key? key}) : super(key: key);

  @override
  State<AppMediaGalleryScreen> createState() => _AppMediaGalleryScreenState();
}

class _AppMediaGalleryScreenState extends State<AppMediaGalleryScreen> {
  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    containsLivePhotos: false,
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );
  final int _sizePerPage = 25;

  AssetPathEntity? _path;
  int _totalEntitiesCount = 0;

  int _page = 0;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMoreToLoad = true;
  bool _permissionGranted = true;

  List<AssetEntity> _entities = [];
  List<AssetEntity> chosenEntities = [];

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _fetchNewMedia() async {
    // Request permissions.
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!mounted) {
      return;
    }
    // Further requests can be only proceed with authorized or limited.
    if (!ps.hasAccess) {
      setState(() {
        _isLoading = false;
        _permissionGranted = false;
      });
      HelperUtils.showErrorMessage(context: context, message: GeneralErrors.needMediaPermission);
      return;
    }
    // Obtain images using the path entity.
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
      filterOption: _filterOptionGroup,
    );
    if (!mounted) {
      return;
    }
    // Return if not paths found.
    if (paths.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      HelperUtils.showErrorMessage(context: context, message: GeneralErrors.noMediaFound);
      return;
    }
    setState(() {
      _path = paths.first;
    });
    _totalEntitiesCount = await _path!.assetCountAsync;
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _entities = entities;
      _isLoading = false;
      _hasMoreToLoad = _entities.length < _totalEntitiesCount;
    });
  }

  Future<void> _loadMoreAsset() async {
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: _page + 1,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _entities.addAll(entities);
      _page++;
      _hasMoreToLoad = _entities.length < _totalEntitiesCount;
      _isLoadingMore = false;
    });
  }

  void _onImageTap(AssetEntity selectedAsset) {
    // first find if the asset is already on the selected list
    final MediaViewModel mediaState = StoreProvider.of<AppState>(context).state.mediaState;
    final AssetEntity? alreadySelectedAsset = chosenEntities.firstWhereOrNull((element) => element == selectedAsset);

    setState(() {
      if (alreadySelectedAsset == null) {
        chosenEntities.add(selectedAsset);
      } else {
        // Дополнительно проверим, чтобы выбранная картинка уже не была загружена на сервер.
        // В таком случае убрать её из выбранных будет нельзя
        final List<UploadingModel> uploadList = mediaState.uploadQueue;
        bool selectedAssetUploaded = false;

        for (UploadingModel item in uploadList) {
          if (item.file == alreadySelectedAsset && item.uploadDone) {
            selectedAssetUploaded = true;
          }
        }

        if (!selectedAssetUploaded) {
          chosenEntities.removeWhere((element) => element == selectedAsset);
        } else {
          HelperUtils.showErrorMessage(context: context, message: GeneralErrors.assetWasAlreadyUploaded);
        }
      }
    });
  }

  bool _isAssetSelected({required String assetId}) {
    AssetEntity? foundEntity;
    bool res = false;
    if (chosenEntities.isNotEmpty) {
      // trying to find if the asset was selected
      foundEntity = chosenEntities.firstWhereOrNull((element) => element.id == assetId);
      res = foundEntity != null;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      body: SafeArea(
        top: true,
        bottom: false,
        child: StoreConnector<AppState, MediaViewModel>(
          converter: (store) => store.state.mediaState,
          distinct: true,
          onInitialBuild: (state) {
            chosenEntities = List.from(state.uploadQueue.map((element) => element.file).toList().cast<AssetEntity>());
          },
          builder: (_, MediaViewModel state) {
            return Hero(
              tag: HeroTag.imageGallery,
              child: Container(
                decoration: AppDecorations.boxShadowDecoration,
                child: Shimmer(
                  linearGradient: HelperUtils.getShimmerGradient(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 27.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                        child: AppRoundedButton(
                          label: 'Выбрать фото',
                          labelStyle: AppTextStyle.openSans20W700.apply(color: AppColors.primaryLight),
                          isProcessing: false,
                          disabled: chosenEntities.isEmpty,
                          color: AppColors.green,
                          handler: chosenEntities.isNotEmpty
                              ? () {
                                  StoreProvider.of<AppState>(context).dispatch(bulkAddPictures(list: chosenEntities));
                                  context.router.pop();
                                }
                              : () {},
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ShimmerLoading(
                          isLoading: _isLoading,
                          child: !_permissionGranted
                              ? Center(
                                  child: Transform.translate(
                                    offset: const Offset(0.0, -60.0),
                                    child: TextLink(label: GeneralErrors.settingsPage, callback: () => PhotoManager.openSetting()),
                                  ),
                                )
                              : _entities.isEmpty
                                  ? Center(child: Transform.translate(offset: const Offset(0.0, -60.0), child: const Text(GeneralErrors.noMediaFound)))
                                  : GridView.custom(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                      ),
                                      childrenDelegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          if (index == _entities.length - 8 && !_isLoadingMore && _hasMoreToLoad) {
                                            _loadMoreAsset();
                                          }
                                          final AssetEntity entity = _entities[index];
                                          return !_isLoading
                                              ? ImageItemWidget(
                                                  key: ValueKey<int>(index),
                                                  selected: _isAssetSelected(assetId: entity.id),
                                                  entity: entity,
                                                  option: const ThumbnailOption(size: ThumbnailSize.square(200)),
                                                  onTap: _onImageTap,
                                                  rowStart: HelperUtils.isRowStart(index: index),
                                                  rowEnd: HelperUtils.isRowEnd(index: index),
                                                )
                                              : Container(
                                                  margin: const EdgeInsets.all(12.0),
                                                  decoration: AppDecorations.boxShadowDecoration,
                                                );
                                        },
                                        childCount: !_isLoading ? _entities.length : _sizePerPage,
                                        findChildIndexCallback: (Key key) {
                                          // Re-use elements.
                                          if (key is ValueKey<int>) {
                                            return key.value;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
