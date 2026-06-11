import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object_item.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/objects_list_screen/file_modal_content.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/string_extensions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ObjectListItem extends StatefulWidget {
  final GreenSpaceObjectItem item;
  final List<Doc> documents;

  const ObjectListItem({
    Key? key,
    required this.item,
    required this.documents,
  }) : super(key: key);

  @override
  State<ObjectListItem> createState() => _ObjectListItemState();
}

class _ObjectListItemState extends State<ObjectListItem> {
  void _showItemFiles() {
    if (widget.documents.isNotEmpty) {
      showMaterialModalBottomSheet(
        useRootNavigator: true,
        expand: false,
        context: context,
        backgroundColor: AppColors.transparent,
        builder: (context) => FileModalContent(
          photos: widget.documents,
        ),
      );
    }
  }

  String _generateObjectSummary() {
    final List<String> paramsList = [];
    String res = '';

    switch (widget.item.type?.id) {
      // Дерево
      case 1:
      // Кустарник
      case 2:
        if (widget.item.selectedKind?.isNotEmpty ?? false) {
          paramsList.add('Итого: ${HelperUtils.parseNotifierValueTitle(savedValue: widget.item.selectedKind)}');
        } else {
          paramsList.add('Итого: ${widget.item.type?.title.toCapitalized() ?? ''}');
        }
        if (widget.item.selectedAge?.isNotEmpty ?? false) {
          paramsList.add(HelperUtils.parseNotifierValueTitle(savedValue: widget.item.selectedAge!));
        }
        if (widget.item.multiStem) {
          paramsList.add('многоствольное');
        }
        if (widget.item.selectedDiameter?.isNotEmpty ?? false) {
          paramsList.add('диаметр: ${HelperUtils.parseNotifierValueTitle(savedValue: widget.item.selectedDiameter)} см');
        }
        if (widget.item.amountValue?.isNotEmpty ?? false) {
          paramsList.add('${widget.item.amountValue} шт.');
        }
        if (widget.item.selectedWorkType?.isNotEmpty ?? false) {
          paramsList.add(HelperUtils.parseNotifierValueTitle(savedValue: widget.item.selectedWorkType));
        }
        break;

      // зн естественного происхождения (шт)
      case 6:
        paramsList.add('Итого: ${widget.item.type?.title.toCapitalized() ?? ''}');
        if (widget.item.amountValue?.isNotEmpty ?? false) {
          paramsList.add('${widget.item.amountValue} шт.');
        }
        if (widget.item.selectedWorkType?.isNotEmpty ?? false) {
          paramsList.add(HelperUtils.parseNotifierValueTitle(savedValue: widget.item.selectedWorkType));
        }
        break;
      default:
        paramsList.add('Итого: ${widget.item.type?.title.toCapitalized() ?? ''}');
        if (widget.item.areaValue?.isNotEmpty ?? false) {
          paramsList.add('${widget.item.areaValue} кв.м');
        }
        if (widget.item.selectedWorkType?.isNotEmpty ?? false) {
          paramsList.add(HelperUtils.parseNotifierValueTitle(savedValue: widget.item.selectedWorkType));
        }
        break;
    }

    res = paramsList.isNotEmpty ? paramsList.join(', ') : '';

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return InkwellButton(
      function: _showItemFiles,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColors.green,
        margin: const EdgeInsets.symmetric(vertical: 3.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _generateObjectSummary(),
                style: AppTextStyle.openSans14W500.apply(
                  color: AppColors.primaryLight,
                ),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            if (widget.documents.isNotEmpty)
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Icon(
                  Icons.file_present_sharp,
                  color: AppColors.green,
                ),
              )
          ],
        ),
      ),
    );
  }
}
