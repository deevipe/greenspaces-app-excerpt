// Flutter imports:
import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';

// Project imports:

class MapControlButton extends StatefulWidget {
  final Widget child;
  final Function? handler;
  final bool disabled;
  final bool processing;
  const MapControlButton({
    Key? key,
    required this.child,
    this.handler,
    required this.disabled,
    required this.processing,
  }) : super(key: key);

  @override
  State<MapControlButton> createState() => MapControlButtonState();
}

class MapControlButtonState extends State<MapControlButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
      lowerBound: 0.0,
      upperBound: 0.4,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _pressUp() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value * 1.2;
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onLongPressUp: _pressUp,
      onTap: () {
        if (!widget.disabled) {
          widget.handler != null ? widget.handler!() : null;
        }
      },
      child: Transform.scale(
        scale: _scale,
        child: Container(
          alignment: Alignment.center,
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: widget.disabled ? AppColors.dimmedDark : AppColors.green, borderRadius: const BorderRadius.all(Radius.circular(40))),
          child: widget.processing
              ? const Loader(
                  btn: true,
                  size: 14,
                  color: AppColors.primaryLight,
                )
              : widget.child,
        ),
      ),
    );
  }
}
