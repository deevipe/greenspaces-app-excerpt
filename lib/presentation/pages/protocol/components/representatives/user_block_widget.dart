import 'package:flutter/material.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/select_type.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/selects/app_select_button.dart';

class CommitteeUserBlock extends StatefulWidget {
  final ValueNotifier<String?> selectedUser;
  final TextEditingController searchController;
  final List<OrganisationUser> list;
  final Function onChange;
  const CommitteeUserBlock({Key? key, required this.selectedUser, required this.searchController, required this.list, required this.onChange})
      : super(key: key);

  @override
  State<CommitteeUserBlock> createState() => _CommitteeUserBlockState();
}

class _CommitteeUserBlockState extends State<CommitteeUserBlock> {
  ValueNotifier<String?> get _user => widget.selectedUser;
  List<OrganisationUser> get _list => widget.list;

  bool _userSelected = false;
  OrganisationUser? _selectedUser;

  void _onSelectChangeHandler(context) {
    widget.onChange();
  }

  @override
  Widget build(BuildContext context) {
    if (_user.value != null && _list.isNotEmpty) {
      _selectedUser = _list.firstWhere((element) => element.id.toString() == _user.value!.split('_').first);
      _userSelected = true;
    }
    return _list.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSelectButton(
                key: UniqueKey(),
                hint: SelectHints.fio,
                items: _list.map((e) => SelectObject(id: e.id.toString(), title: e.fio ?? 'н/д')).toList(),
                searchController: widget.searchController,
                selectedVal: widget.selectedUser,
                type: SelectType.general,
                onChange: () => _onSelectChangeHandler(context),
              ),
              const SizedBox(
                height: 10.0,
              ),
              _userSelected && _user.value != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '',
                              children: [
                                TextSpan(
                                  text: 'Должность: ',
                                  style: AppTextStyle.roboto14W500.apply(
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                TextSpan(
                                  text: '${_selectedUser!.position}',
                                  style: AppTextStyle.openSans14W400.apply(color: AppColors.primaryDark),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          RichText(
                            text: TextSpan(
                              text: '',
                              children: [
                                TextSpan(
                                  text: 'Телефон: ',
                                  style: AppTextStyle.roboto14W500.apply(
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                TextSpan(
                                  text: '${_selectedUser!.tel}',
                                  style: AppTextStyle.openSans14W400.apply(color: AppColors.primaryDark),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          )
        : const SizedBox(
            height: 10.0,
          );
  }
}
