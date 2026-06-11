// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';

class TextLink extends StatelessWidget {
  final String label;
  final Function callback;
  final SvgPicture? icon;
  final Offset? offset;
  final Color? color;
  const TextLink({
    super.key,
    required this.label,
    required this.callback,
    this.icon,
    this.offset,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset ?? const Offset(0.0, 0.0),
      child: TextButton(
        onPressed: () => callback(),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  icon!,
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                        fontFamily: 'OpenSans',
                        shadows: [Shadow(color: AppColors.primaryDark, offset: Offset(0, -3))],
                        color: AppColors.transparent,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        decorationColor: AppColors.primaryDark,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.0),
                  )
                ],
              )
            : Text(
                label,
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    shadows: [Shadow(color: color ?? AppColors.primaryDark, offset: const Offset(0, -3))],
                    color: AppColors.transparent,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    decorationColor: color ?? AppColors.primaryDark,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0),
              ),
      ),
    );
  }
}
