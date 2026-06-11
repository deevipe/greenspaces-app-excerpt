import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/custom_bottom_sheet.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class GeneralFileModalContent extends StatelessWidget {
  final List<Doc> files;
  const GeneralFileModalContent({Key? key, required this.files}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: 300.0,
      child: Expanded(
        child: SizedBox(
          width: double.infinity,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: files.length,
              itemBuilder: (_, int index) {
                final String fileName = (files[index].fileName != null && files[index].fileName!.isNotEmpty)
                    ? files[index].fileName!
                    : (files[index].fullName != null && files[index].fullName!.isNotEmpty ? files[index].fullName! : 'н / д');

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(bottom: 15.0),
                  decoration:
                      (index != files.length - 1) ? const BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: AppColors.inputBg))) : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (files[index].fullName != null) _DocTypeIcon(docExtension: files[index].fullName!.split('.').last),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Expanded(
                              child: Text(
                                fileName,
                                style: AppTextStyle.roboto14W400,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Размер: ${files[index].fileSize}'),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text('Дата: ${files[index].created}')
                        ],
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class _DocTypeIcon extends StatelessWidget {
  final String docExtension;
  const _DocTypeIcon({Key? key, required this.docExtension}) : super(key: key);

  String _getTypedAsset(String extension) {
    String res = AppIcons.docIcon;

    switch (extension) {
      case 'pdf':
        res = AppIcons.pdfIcon;
        break;
      case 'txt':
        res = AppIcons.txtIcon;
        break;
      default:
        res = AppIcons.docIcon;
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _getTypedAsset(docExtension),
      color: AppColors.green,
      width: 35,
      height: 35,
    );
  }
}
