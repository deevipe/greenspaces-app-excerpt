import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';

class UploadIcon extends StatelessWidget {
  final Color? background;
  const UploadIcon({Key? key, this.background}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7.0),
      width: 36.0,
      height: 36.0,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(36.0),
          ),
          color: background ?? AppColors.primaryLight),
      child: const Icon(Icons.upload_rounded),
    );
  }
}
