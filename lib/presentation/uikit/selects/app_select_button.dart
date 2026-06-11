// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/select_type.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/input_block.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class AppSelectButton extends StatelessWidget {
  final ValueNotifier<String?> selectedVal;
  final List<SelectObject> items;
  final String hint;
  final Function? resetError;
  final Function? onChange;
  final bool? search;
  final SelectType type;
  final TextEditingController searchController;
  final bool? processing;
  const AppSelectButton(
      {Key? key,
      required this.selectedVal,
      required this.items,
      required this.hint,
      this.resetError,
      required this.type,
      this.onChange,
      this.search,
      required this.searchController,
      this.processing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Используем Listner для того, чтобы убрать любой фокус с возможных полей
    // В противном случае, происходят накладки в показе drop down элемента с
    // открытой клавиатурой
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).unfocus(),
      child: DropdownButtonHideUnderline(
        child: ValueListenableBuilder(
          valueListenable: selectedVal,
          builder: (BuildContext context, String? selected, Widget? _) {
            return DropdownButton2(
              isExpanded: true,
              dropdownFullScreen: true,
              iconSize: 14,
              buttonHeight: 40,
              buttonWidth: MediaQuery.of(context).size.width - 24.0,
              buttonPadding: const EdgeInsets.only(left: 21, right: 21),
              buttonDecoration: items.isNotEmpty
                  ? selected != null
                      ? AppDecorations.selected
                      : AppDecorations.select
                  : AppDecorations.selectEmpty,
              buttonElevation: 0,
              itemHeight: 75,
              itemPadding: const EdgeInsets.only(left: 14, right: 14),
              dropdownMaxHeight: 400,
              dropdownWidth: MediaQuery.of(context).size.width - 24.0,
              dropdownPadding: null,
              dropdownDecoration: AppDecorations.select,
              dropdownElevation: 2,
              scrollbarRadius: const Radius.circular(3),
              scrollbarThickness: 5,
              scrollbarAlwaysShow: true,
              offset: const Offset(0, -10),
              searchController: (search ?? false) ? searchController : null,
              searchInnerWidget: (search ?? false)
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: InputBlock(
                        isPassword: false,
                        label: AppDictionary.searchHint,
                        controller: searchController,
                        errorMessage: '',
                        isError: false,
                        isProcessing: false,
                        resetError: () {},
                      ))
                  : null,
              searchMatchFn: (search ?? false)
                  ? (item, searchValue) {
                      String searchVal = item.value.toString().split('_').last.toLowerCase();
                      return (searchVal.contains(searchValue.toLowerCase().trimRight()));
                    }
                  : null,
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  searchController.clear();
                }
              },
              hint: Row(
                children: [
                  Expanded(
                    child: processing == true
                        ? Loader(
                            color: items.isEmpty ? AppColors.white : AppColors.primaryDark,
                          )
                        : Text(
                            hint,
                            style: AppTextStyle.openSans14W400.apply(color: AppColors.primaryDark),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                  ),
                ],
              ),
              selectedItemBuilder: (context) {
                return items.map((item) {
                  return Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      ('${item.id}_${item.title}').toLowerCase() == selected?.toLowerCase() ? item.title : hint,
                      style: AppTextStyle.openSans14W400.apply(color: AppColors.green),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: '${item.id}_${item.title}',
                        child: Container(
                          width: MediaQuery.of(context).size.width - 24.0,
                          // padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          decoration: item != items.last ? const BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: AppColors.inputBg))) : null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Transform.translate(
                                      offset: const Offset(0, 3.0),
                                      child: SvgPicture.asset(
                                        item.id == selected?.split('_').first ? AppIcons.checkedBox : AppIcons.uncheckedBox,
                                        width: item.id == selected ? 20 : 16,
                                      )),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 88,
                                    child: Text(
                                      item.title,
                                      style: AppTextStyle.openSans14W400.apply(color: AppColors.primaryDark),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              value: selected,
              onChanged: (value) {
                selectedVal.value = value != null ? value as String : null;
                if (value != null && resetError != null) {
                  resetError!.call();
                }
                if (onChange != null) {
                  onChange!();
                }
              },
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.chevronUp,
                    height: 12.0,
                    color: selected != null ? AppColors.green : AppColors.primaryDark,
                  ),
                  SvgPicture.asset(
                    AppIcons.chevronDown,
                    height: 12.0,
                    color: selected != null ? AppColors.green : AppColors.primaryDark,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
