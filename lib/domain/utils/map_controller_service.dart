// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/domain/enums/zoom_actions.dart';
import 'package:latlong2/latlong.dart';

// Project imports:

class AppMapService {
  late MapController _controller;
  final LatLng _cityCenter;
  final double _maxZoom;
  final double _minZoom;
  final ValueNotifier<double> _currentZoom;
  AppMapService()
      : _cityCenter = LatLng(59.937500, 30.308611),
        _maxZoom = 18.0,
        _minZoom = 10.0,
        _currentZoom = ValueNotifier<double>(15.0);

  MapController get controller => _controller;
  ValueNotifier<double> get currentZoom => _currentZoom;
  LatLng get center => _cityCenter;
  double get minZoom => _minZoom;
  double get maxZoom => _maxZoom;

  CurrentLocationLayer getLocationMarker() => CurrentLocationLayer(
        style: LocationMarkerStyle(
          marker: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                border: Border.all(color: AppColors.primaryLight, width: 2.0)),
          ),
          markerSize: const Size(20, 20),
          accuracyCircleColor: AppColors.primaryBlue.withOpacity(.2),
          showHeadingSector: false,
        ),
        moveAnimationDuration: Duration.zero,
      );

  void init() {
    _controller = MapController();
  }

  void dispose() {
    _controller.dispose();
  }

  // returns current zoom to update map zoom in one line
  void zoom({required Zoom zoomAction}) {
    _currentZoom.value = (zoomAction == Zoom.zoomIn)
        ? ((_currentZoom.value + .5) > _maxZoom ? _maxZoom : (_currentZoom.value + .5))
        : ((_currentZoom.value - .5) < _minZoom ? _minZoom : (_currentZoom.value - .5));

    debugPrint(_currentZoom.value.toString());

    _controller.move(_controller.center, _currentZoom.value);
  }

  void onPositionChanged(MapPosition position, bool val) {
    double zoomToUpdate = _controller.zoom;

    if (zoomToUpdate < _minZoom) {
      zoomToUpdate = _minZoom;
    } else if (zoomToUpdate > _maxZoom) {
      zoomToUpdate = _maxZoom;
    }

    _currentZoom.value = zoomToUpdate;
    _controller.move(_controller.center, _currentZoom.value);
  }

  Future<LatLng> getUserPosition() async {
    Position userPostion = await determinePosition();
    return LatLng(userPostion.latitude, userPostion.longitude);
  }

  Future<bool> centerMap({LatLng? target, required AnimationController animationController}) async {
    try {
      Position? userPostion;
      if (target == null) {
        userPostion = await determinePosition();
      }

      if (target == null && userPostion == null) {
        return false;
      }

      // Create some tweens. These serve to split up the transition from one location to another.
      // In our case, we want to split the transition be<tween> our current map center and the destination.
      final latTween = Tween<double>(begin: _controller.center.latitude, end: target?.latitude ?? userPostion!.latitude);
      final lngTween = Tween<double>(begin: _controller.center.longitude, end: target?.longitude ?? userPostion!.longitude);
      final zoomTween = Tween<double>(begin: _controller.zoom, end: target != null ? _controller.zoom : _maxZoom);

      // The animation determines what path the animation will take. You can try different Curves values, although I found
      // fastOutSlowIn to be my favorite.
      final Animation<double> animation = CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);

      animationController.addListener(() {
        _currentZoom.value = _controller.zoom;
        _controller.move(LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)), zoomTween.evaluate(animation));
      });

      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.dispose();
        } else if (status == AnimationStatus.dismissed) {
          animationController.dispose();
        }
      });

      animationController.forward();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Сервис геолокации отключен.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Необходимо разрешение на получение вашей текущей позиции');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        return Future.error('Разрешение на получение вашей текущей позиции отклонено. Геолокацию необходимо включить в настройках');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
