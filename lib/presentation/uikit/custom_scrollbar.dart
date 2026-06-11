// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flexible_scrollbar/flexible_scrollbar.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';



class AppScrollBar extends StatelessWidget {
  final bool? alwaysVisible;
  final ScrollController controller;
  final Widget child;
  const AppScrollBar({
    Key? key,
    required this.controller,
    required this.child,
    this.alwaysVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleScrollbar(
      alwaysVisible: alwaysVisible ?? false,
      controller: controller,
      scrollThumbBuilder: (ScrollbarInfo? info) {
        return AnimatedContainer(
          width: info?.isDragging ?? false ? 6.0 : 5.0,
          height: info?.thumbMainAxisSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: AppColors.scrollbarColor.withOpacity(info?.isDragging ?? false ? 1 : .8),
          ),
          duration: const Duration(milliseconds: 300),
        );
      },
      scrollLineBuilder: (ScrollbarInfo? info) {
        return info != null
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: AppColors.scrollbarColor.withOpacity(.35),
                ),
              )
            : Container();
      },
      child: child,
    );
  }
}
