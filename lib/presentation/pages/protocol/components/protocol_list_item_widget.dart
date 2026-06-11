import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';

class ProtocolListItemWidget extends StatelessWidget {
  final String id;
  final String address;
  final String date;
  final bool last;

  const ProtocolListItemWidget({
    super.key,
    required this.id,
    required this.address,
    required this.date,
    required this.last,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: last
          ? const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.dark100, width: 1),
                bottom: BorderSide(color: AppColors.dark100, width: 1),
              ),
            )
          : const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.dark100, width: 1),
              ),
            ),
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          _ItemRow(label: AppDictionary.protocolIdlabel, value: id),
          const SizedBox(
            height: 10.0,
          ),
          _ItemRow(label: AppDictionary.protocolDistrictLabe, value: address),
          const SizedBox(
            height: 10.0,
          ),
          _ItemRow(label: AppDictionary.protocolDateLabel, value: date),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String label;
  final String value;
  const _ItemRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
          label,
          style: AppTextStyle.openSans14W500.apply(color: AppColors.dark400),
        )),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.openSans14W500.apply(color: AppColors.primaryDark),
          ),
        )
      ],
    );
  }
}
