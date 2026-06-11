import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/dio_settings.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/custom_bottom_sheet.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';

class FileModalContent extends StatelessWidget {
  final List<Doc> photos;
  const FileModalContent({Key? key, required this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: 300.0,
      backgroundColor: AppColors.black,
      child: Expanded(
        child: SizedBox(
          width: double.infinity,
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: false,
              enableInfiniteScroll: false,
              aspectRatio: 16 / 9,
              enlargeCenterPage: true,
              padEnds: false,
            ),
            items: List.generate(
              photos.length,
              (index) => Stack(
                children: [
                  Container(
                      decoration: AppDecorations.boxShadowDecoration,
                      margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 15.0),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const Loader(),
                        imageUrl: '${DioSettings.baseUrl}/Document/View/${photos[index].id}',
                      )
                      // AssetEntityImage(
                      //   _images[index].file,
                      //   width: MediaQuery.of(context).size.width - 10.0,
                      //   fit: BoxFit.cover,
                      // ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
