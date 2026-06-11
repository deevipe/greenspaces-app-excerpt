// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';

class CustomSelectRow extends StatelessWidget {
  final int index;
  final String? checkedId;
  final SelectObject item;
  final bool last;
  final Function callback;

  const CustomSelectRow({
    Key? key,
    required this.item,
    required this.last,
    required this.callback,
    required this.index,
    this.checkedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checkboxTheme = theme.checkboxTheme;
    final newCheckBoxTheme = checkboxTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: AppColors.dark100,
          ),
        ),
      ),
      child: Theme(
        data: ThemeData(unselectedWidgetColor: AppColors.checkboxBorder, checkboxTheme: newCheckBoxTheme),
        child: CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (value) => callback(index, value),
          title: Transform.translate(
            offset: const Offset(-15.0, 0),
            child: Text(
              item.title,
              style: AppTextStyle.openSans14W500.apply(color: AppColors.primaryDark),
            ),
          ),
          value: checkedId != null ? (item.id == checkedId) : false,
          activeColor: AppColors.green,
          checkColor: AppColors.primaryLight,
        ),
      ),
    );
  }
}
