import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/doc_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/objects_list_screen/object_list_item.dart';

class ObjectInfoBlock extends StatelessWidget {
  final int count;
  final GreenSpaceObject item;
  final List<Doc> docs;
  const ObjectInfoBlock({
    Key? key,
    required this.item,
    required this.count,
    required this.docs,
  }) : super(key: key);

  List<Doc> _getElementDocuments({required int elementId}) {
    List<Doc> filteredDocs = [];

    if (docs.isNotEmpty) {
      for (Doc item in docs) {
        if (item.protocolElementId == elementId) {
          filteredDocs.add(item);
        }
      }
    }

    return filteredDocs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding, vertical: 7.0),
          child: Text(
            'Адрес $count. ${item.address}',
            style: AppTextStyle.roboto14W500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding, vertical: 7.0),
          child: Container(
            height: 1,
            color: AppColors.dark100,
          ),
        ),
        ...List.generate(
            item.items.length,
            (index) => ObjectListItem(
                  item: item.items[index],
                  documents: _getElementDocuments(elementId: item.items[index].id!),
                ))
      ],
    );
  }
}
