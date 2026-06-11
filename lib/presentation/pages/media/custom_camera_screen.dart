// Flutter imports:
import 'package:auto_route/auto_route.dart';
// Package imports:
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/home/components/app_bar_title.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/media/components/camera/bottom_controls_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/media/components/camera/zoom_control_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/media_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/text_link.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/error_message_text.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/painters/camera_grid_painter.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';
import 'package:open_settings/open_settings.dart';
import 'package:photo_manager/photo_manager.dart';

class CustomCameraScreen extends StatefulWidget {
  const CustomCameraScreen({super.key});

  @override
  State<CustomCameraScreen> createState() => _CustomCameraScreen();
}

class _CustomCameraScreen extends State<CustomCameraScreen> {
  final List<XFile> newPictures = [];
  final List<AssetEntity> _entities = [];
  late CameraController _controller;
  bool _isLoading = true;
  bool _picTaken = false;
  bool _permissionGranted = true;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  String _cameraErrorMessage = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initCamera();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final List<CameraDescription> cameras = await availableCameras();
      final CameraDescription camera = cameras.first;

      _controller = CameraController(
        camera,
        ResolutionPreset.max,
        enableAudio: false,
      );

      // Start initializing media assets
      _initCameraMedia();
      // Next, initialize the controller. This returns a Future.
      await _controller.initialize();

      _controller.getMaxZoomLevel().then((value) => _maxAvailableZoom = value);
      _controller.getMinZoomLevel().then((value) => _minAvailableZoom = value);

      setState(() {
        _isLoading = false;
        _cameraErrorMessage = '';
        _permissionGranted = true;
      });
    } on CameraException catch (_) {
      _cameraErrorMessage = GeneralErrors.cameraAccess;
      setState(() {
        _isLoading = false;
        _permissionGranted = false;
      });
    } catch (e) {
      _cameraErrorMessage = GeneralErrors.loadError;
      setState(() {
        _isLoading = false;
        _permissionGranted = false;
      });
    }
  }

  Future<void> _initCameraMedia() async {
    if (!mounted) {
      return;
    }

    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        containsLivePhotos: false,
        imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
      ),
    );
    if (!mounted) {
      return;
    }

    AssetPathEntity? path;
    if (paths.isNotEmpty) {
      path = paths.first;
      final List<AssetEntity> entities = await path.getAssetListPaged(
        page: 0,
        size: 1,
      );
      setState(() {
        _entities.clear();
        _entities.addAll(entities);
      });
    }
  }

  void _onPicTaken() async {
    try {
      final XFile image = await _controller.takePicture();

      setState(() => _picTaken = true);
      if (mounted) {
        StoreProvider.of<AppState>(context).dispatch(TakingPicture());
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() => _picTaken = false);
        HapticFeedback.heavyImpact();
      });

      bool? saved = await GallerySaver.saveImage(image.path, toDcim: true);

      if (!mounted) return;
      if (saved == true) {
        List<AssetEntity> chosenAsset = await _updateAsset();

        if (mounted) {
          StoreProvider.of<AppState>(context)
              .dispatch(AddSelectedPicture(asset: chosenAsset[0]));
        }
      }
    } catch (e) {
      // If an error occurs, log the error to the console.
      // dispatch redux error action
      debugPrint(e.toString());
    }
  }

  Future<List<AssetEntity>> _updateAsset() async {
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        containsLivePhotos: false,
        imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
      ),
    );
    if (!mounted) {
      return [];
    }

    AssetPathEntity? path;
    List<AssetEntity> entities = [];
    if (paths.isNotEmpty) {
      path = paths.first;
      entities = await path.getAssetListPaged(
        page: 0,
        size: 1,
      );
    }

    return entities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !_permissionGranted
          ? AppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              centerTitle: true,
              title: const AppBarUser(),
              leading: AutoLeadingButton(
                builder: (_, type, callback) {
                  return type == LeadingType.noLeading
                      ? const SizedBox.shrink()
                      : Container(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height),
                          margin: const EdgeInsets.only(left: 12.0),
                          child: IconButton(
                            splashRadius: .1,
                            splashColor: AppColors.transparent,
                            onPressed: () {
                              if (callback != null) {
                                callback();
                              }
                            },
                            icon: SvgPicture.asset(
                              AppIcons.arrowLeft,
                            ),
                          ),
                        );
                },
              ),
              leadingWidth: 46,
              actions: [
                IconButton(
                  splashRadius: .1,
                  splashColor: AppColors.transparent,
                  onPressed: () =>
                      HelperUtils.showLogoutDialog(context: context),
                  icon: SvgPicture.asset(
                    AppIcons.logoutIcon,
                    width: 24.54,
                  ),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: OrientationBuilder(builder: (context, orientation) {
          List<Widget> children = _isLoading
              ? [
                  const Center(
                    child: Loader(),
                  )
                ]
              : !_permissionGranted
                  ? [
                      Expanded(
                        child: Center(
                          child: Transform.translate(
                            offset: const Offset(0.0, -60.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ErrorMessageText(
                                  message: _cameraErrorMessage,
                                ),
                                TextLink(
                                    label: GeneralErrors.settingsPage
                                        .toLowerCase(),
                                    callback: () =>
                                        OpenSettings.openAppSetting())
                              ],
                            ),
                          ),
                        ),
                      )
                    ]
                  : [
                      Expanded(
                        flex: 20,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CameraPreview(_controller),
                            Positioned.fill(
                              child: CustomPaint(
                                painter: CameraGridPaint(),
                                child: Container(
                                  color: AppColors.transparent,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                ),
                              ),
                            ),
                            _ShutterFlash(
                              shutterFlash: _picTaken,
                            ),
                          ],
                        ),
                      ),
                      ZoomControlWidget(
                        orientation: orientation,
                        controller: _controller,
                        minZoom: _minAvailableZoom,
                        maxZoom: _maxAvailableZoom,
                      ),
                      CameraBottomControls(
                        orientation: orientation,
                        entity: _entities,
                        cameraCallback: _onPicTaken,
                        files: newPictures,
                      )
                    ];
          return Container(
            decoration: AppDecorations.boxShadowDecoration,
            child: (orientation == Orientation.landscape)
                ? Row(
                    children: children,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: children,
                  ),
          );
        }),
      ),
    );
  }
}

class _ShutterFlash extends StatelessWidget {
  final bool shutterFlash;
  const _ShutterFlash({Key? key, required this.shutterFlash}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: shutterFlash ? 1 : 0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.primaryDark.withOpacity(.5),
        ),
      ),
    );
  }
}
