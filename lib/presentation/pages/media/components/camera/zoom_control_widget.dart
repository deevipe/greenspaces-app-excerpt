import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';

class ZoomControlWidget extends StatefulWidget {
  final CameraController controller;
  final double maxZoom;
  final double minZoom;
  final Orientation orientation;
  const ZoomControlWidget(
      {Key? key,
      required this.controller,
      required this.maxZoom,
      required this.minZoom,
      required this.orientation})
      : super(key: key);

  @override
  State<ZoomControlWidget> createState() => _ZoomControlWidgetState();
}

class _ZoomControlWidgetState extends State<ZoomControlWidget> {
  double _currentZoomLevel = 1.0;

  CameraController get _camControl => widget.controller;
  double get _minZoom => widget.minZoom;
  double get _maxZoom => widget.maxZoom;
  Orientation get _orientation => widget.orientation;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Expanded(
        child: RotatedBox(
          quarterTurns: _orientation == Orientation.portrait ? 0 : 3,
          child: Slider(
            value: _currentZoomLevel,
            min: _minZoom,
            max: _maxZoom,
            activeColor: AppColors.white,
            inactiveColor: AppColors.greyButton,
            onChanged: (value) async {
              setState(() {
                _currentZoomLevel = value;
              });
              await _camControl.setZoomLevel(value);
            },
          ),
        ),
      ),
      Container(
        width: _orientation == Orientation.portrait ? null : 30.0,
        height: _orientation == Orientation.portrait ? null : 30.0,
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: _orientation == Orientation.portrait
              ? const EdgeInsets.all(8.0)
              : EdgeInsets.zero,
          child: Center(
            child: Text(
              '${_currentZoomLevel.toStringAsFixed(1)}x',
              style: _orientation == Orientation.portrait
                  ? AppTextStyle.openSans14W400
                      .apply(color: AppColors.primaryLight)
                  : AppTextStyle.openSans10W500
                      .apply(color: AppColors.primaryLight),
            ),
          ),
        ),
      )
    ];

    return _orientation == Orientation.portrait
        ? Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstraints.screenPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          )
        : Container(
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: children.reversed.toList(),
            ),
          );
  }
}
