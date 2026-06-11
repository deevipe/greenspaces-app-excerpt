import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/domain/entity/map/toris_layer_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/ogs_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/geometry_type.dart';
import 'package:gisogs_greenspacesapp/domain/enums/zoom_actions.dart';
import 'package:gisogs_greenspacesapp/domain/utils/map_controller_service.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/map/popup_info.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/map_control_btn.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_territory_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_territory_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/arcgis_map/arcgis_layer.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/cached_network_tile_provider.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final String layerUrl;
  const MapScreen({super.key, @QueryParam() this.layerUrl = 'https://gis.toris.gov.spb.ru/arccod1031/rest/services/KB/14_ZNOP_WGS/MapServer'});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final AppMapService _mapService = AppMapService();
  bool _centeringProcess = false;
  bool detailInfoOpen = false;
  TorisLayerEntity detailInfo = TorisLayerEntity.initial();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _mapService.init();
    // _centerMap();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _mapService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _centerMap({LatLng? target}) async {
    final controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    try {
      bool result = await _mapService.centerMap(target: target, animationController: controller);
      return result;
    } catch (e) {
      HelperUtils.showErrorMessage(context: context, message: e.toString(), openSettings: true);
      return false;
    }
  }

  Future<void> _centerUser() async {
    setState(() => _centeringProcess = true);
    try {
      await _centerMap();
    } catch (e) {
      HelperUtils.showErrorMessage(context: context, message: e.toString());
    }
    setState(() => _centeringProcess = false);
  }

  void _objectHandler(dynamic attributes, LatLng location) {
    if (attributes != null) {
      debugPrint(attributes.toString());
      setState(() {
        detailInfo = TorisLayerEntity.fromJson(attributes);
        detailInfoOpen = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapService.controller,
          options: MapOptions(
            keepAlive: false,
            enableScrollWheel: false,
            center: _mapService.center,
            zoom: _mapService.currentZoom.value,
            minZoom: _mapService.minZoom,
            maxZoom: _mapService.maxZoom,
            onPositionChanged: _mapService.onPositionChanged,
            // onTap: (tapPosition, point) => _closeHintPopup(),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              tileProvider: CachedNetworkTileProvider(),
              userAgentPackageName: 'com.example.gis_ogs',
              errorImage: const NetworkImage('https://tile.openstreetmap.org/18/0/0.png'),
            ),
            ArcGisLayerWrapper(
              stream: _mapService.controller.mapEventStream,
              url: '${widget.layerUrl}/0',
              geometry: EsriGeometryType.polygon,
              borderColor: const Color.fromRGBO(28, 152, 55, 1),
              color: null,
              borderStrokeWidth: 2,
              onTap: _objectHandler,
            )
          ],
        ),
        Positioned(
          right: 12.0,
          bottom: 115.0, // margin between bottom button and bottomNavBar + NavBar height
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ValueListenableBuilder(
                valueListenable: _mapService.currentZoom,
                builder: (BuildContext context, double val, Widget? child) {
                  return MapControlButton(
                    handler: () => _mapService.zoom(zoomAction: Zoom.zoomIn),
                    disabled: val == _mapService.maxZoom,
                    processing: false,
                    child: const Icon(
                      Icons.add,
                      color: AppColors.primaryLight,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppConstraints.mapButtonMargin),
              ValueListenableBuilder(
                valueListenable: _mapService.currentZoom,
                builder: (BuildContext context, double val, Widget? child) {
                  return MapControlButton(
                    handler: () => _mapService.zoom(zoomAction: Zoom.zoomOut),
                    disabled: val == _mapService.minZoom,
                    processing: false,
                    child: const Icon(
                      Icons.remove,
                      color: AppColors.primaryLight,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppConstraints.mapButtonMargin),
              MapControlButton(
                handler: _centerUser,
                disabled: false,
                processing: _centeringProcess,
                child: SvgPicture.asset(
                  AppIcons.compasIcon,
                  width: 25,
                  height: 25,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
        ),
        PopupInfoCard(
          key: const ValueKey('popup_info_card'),
          toggled: detailInfoOpen,
          data: detailInfo,
          label: BtnLabel.choose,
          callback: () {
            ProtocolTerritoryViewModel state = StoreProvider.of<AppState>(context).state.protocolTerritoryState;
            // На данном этапе state.selectedType не должен быть null
            StoreProvider.of<AppState>(context).dispatch(
              UpdateTerritoryStepAction(
                address: detailInfo.address ?? '',
                selectedType: state.selectedType!,
                typeUrl: state.typeUrl,
                ogs: detailInfo.oid != null
                    ? Ogs(
                        id: detailInfo.oid,
                        name: detailInfo.name,
                        address: detailInfo.address,
                      )
                    : null,
              ),
            );
            if (detailInfo.oid != null) {
              HelperUtils.showErrorMessage(context: context, message: 'Адрес объекта скопирован');
              setState(() {
                detailInfoOpen = false;
                // detailInfo = TorisLayerEntity.initial();
              });
              context.router.pop();
            }
          },
          routingFunction: () {},
          closeHandler: () {
            setState(() {
              detailInfoOpen = false;
              detailInfo = TorisLayerEntity.initial();
            });
          },
        )
      ],
    );
  }
}
