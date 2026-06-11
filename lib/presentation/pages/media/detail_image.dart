// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/annotations.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';

// Project imports:


class DetailGalleryImageScreen extends StatelessWidget {
  final String path;
  final String id;
  final String? hashImageCode;
  const DetailGalleryImageScreen(
      {Key? key, @PathParam() required this.path, @PathParam() required this.id, @QueryParam() this.hashImageCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'image_$id',
      child: Container(
        decoration: AppDecorations.darkBoxShadowDecoration,
        child: Image.file(
          File(path),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
