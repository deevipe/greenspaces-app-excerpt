import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/select_type.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/representatives/user_block_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/selects/app_select_button.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class OrganisationWidget extends StatelessWidget {
  final UniqueKey? widgetProcessed;
  final List<Organisation> committeeList;
  final List<Organisation> sppList;
  final Map<UniqueKey, List<OrganisationUser>> usersForSelect;
  final bool isProcessing;
  final OrganizationType type;
  final TextEditingController searchController;
  final ValueNotifier<String?> selectedOrg;
  final ValueNotifier<String?> selectedUser;
  final VoidCallback onSelect;
  final bool? deletable;
  final bool validationFailed;
  final VoidCallback deleteAction;
  const OrganisationWidget({
    Key? key,
    required this.searchController,
    required this.selectedOrg,
    required this.onSelect,
    required this.selectedUser,
    required this.type,
    this.widgetProcessed,
    required this.committeeList,
    required this.sppList,
    required this.isProcessing,
    required this.usersForSelect,
    this.deletable,
    required this.deleteAction,
    required this.validationFailed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<SelectObject> list = type == OrganizationType.committee
        ? committeeList.map((item) => SelectObject(id: item.id.toString(), title: item.name)).toList()
        : sppList.map((item) => SelectObject(id: item.id.toString(), title: item.name)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProjectScreenHeader(
              title: type == OrganizationType.committee ? SelectHints.committie : SelectHints.spp,
              margin: const EdgeInsets.only(top: 10.0, bottom: 0.0),
            ),
            if (deletable == true)
              Container(
                margin: const EdgeInsets.only(right: 5.0),
                padding: const EdgeInsets.all(4.0),
                decoration: const BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.all(Radius.circular(20))),
                width: 20.0,
                height: 20.0,
                child: InkwellButton(
                  function: deleteAction,
                  child: SvgPicture.asset(
                    AppIcons.minusIcon,
                    color: AppColors.primaryLight,
                  ),
                ),
              )
          ],
        ),
        AnimatedOpacity(
          opacity: validationFailed ? 1 : 0,
          duration: const Duration(milliseconds: 800),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 3.0,
            ),
            child: Text(
              selectedOrg.value == null && selectedUser.value == null
                  ? RepresentativesError.fullBlock
                  : selectedUser.value == null
                      ? RepresentativesError.chooseUser
                      : '',
              style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
            ),
          ),
        ),
        AppSelectButton(
          key: UniqueKey(),
          hint: type == OrganizationType.committee ? SelectHints.committie : SelectHints.spp,
          items: list,
          searchController: searchController,
          selectedVal: selectedOrg,
          type: SelectType.general,
          onChange: onSelect,
        ),
        const SizedBox(
          height: 10.0,
        ),
        (isProcessing == true && widgetProcessed == key)
            ? const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Loader(),
              )
            : CommitteeUserBlock(
                searchController: searchController,
                selectedUser: selectedUser,
                list: usersForSelect[key] ?? [],
                onChange: onSelect,
              ),
      ],
    );
  }
}
