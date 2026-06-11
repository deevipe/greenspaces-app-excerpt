import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageItemWidget extends StatelessWidget {
  const ImageItemWidget({
    Key? key,
    required this.entity,
    required this.option,
    required this.selected,
    this.onTap,
    required this.rowStart,
    required this.rowEnd,
  }) : super(key: key);

  final AssetEntity entity;
  final ThumbnailOption option;
  final bool selected;
  final Function? onTap;
  final bool rowStart;
  final bool rowEnd;
  // final bool rowCenter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (onTap != null) {
          onTap!(entity);
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: rowStart ? 12.0 : 6.0, right: rowEnd ? 12.0 : 6.0, top: 6.0, bottom: 6.0),
        decoration: AppDecorations.boxShadowDecoration,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: AssetEntityImage(
                  entity,
                  isOriginal: false,
                  thumbnailSize: option.size,
                  thumbnailFormat: option.format,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (selected)
              PositionedDirectional(
                bottom: -8,
                end: -8,
                child: Container(
                  width: 33.0,
                  height: 33.0,
                  decoration: AppDecorations.doneIcon,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppIcons.doneIcon,
                    width: 23.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
