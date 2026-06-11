// Flutter imports:
import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';

// Package imports:
import 'package:loading_animation_widget/loading_animation_widget.dart';

// Project imports:

// Project imports:

class Loader extends StatelessWidget {
  final Color? color;
  final bool? btn;
  final double size;

  const Loader({
    Key? key,
    this.color,
    this.size = 30,
    this.btn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: btn == true
          ? LoadingAnimationWidget.hexagonDots(color: color ?? AppColors.green, size: size)
          : LoadingAnimationWidget.horizontalRotatingDots(
              color: color ?? AppColors.green,
              size: size,
            ),
    );
  }
}
