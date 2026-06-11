// Flutter imports:
import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';

class CustomBottomSheet extends StatelessWidget {
  final double? height;
  final Color? backgroundColor;
  final Widget child;
  const CustomBottomSheet({Key? key, required this.child, this.height, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 200.0,
        decoration: backgroundColor != null ? AppDecorations.modalSheet.copyWith(color: backgroundColor) : AppDecorations.modalSheet,
        padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding, vertical: 10.0),
        child: Column(
          children: [
            const _ModalNotch(),
            child,
          ],
        ));
  }
}

class _ModalNotch extends StatelessWidget {
  const _ModalNotch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 2.0,
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: const BoxDecoration(color: AppColors.dimmedDark, borderRadius: BorderRadius.all(Radius.circular(8.0))),
    );
  }
}
