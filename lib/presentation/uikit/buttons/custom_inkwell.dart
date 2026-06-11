import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';

class InkwellButton extends StatelessWidget {
  final Widget child;
  final Function function;
  const InkwellButton({super.key, required this.child, required this.function});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        splashColor: AppColors.primaryDark.withOpacity(.1),
        onTap: () => function(),
        child: child,
      ),
    );
  }
}
