import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_general_data_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_general_data_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/custom_bottom_sheet.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/error_message_text.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_select_row.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';

class OrganisationSearchModalContent extends StatefulWidget {
  const OrganisationSearchModalContent({Key? key}) : super(key: key);

  @override
  State<OrganisationSearchModalContent> createState() => _OrganisationSearchModalContentState();
}

class _OrganisationSearchModalContentState extends State<OrganisationSearchModalContent> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: 500.0,
      child: Expanded(
        child: StoreConnector<AppState, ProtocolGeneralViewModel>(
          converter: (store) => store.state.protocolGeneralStepState,
          distinct: true,
          builder: (_, state) {
            return state.searchingOrgs == true
                ? const Center(
                    child: Loader(color: AppColors.green),
                  )
                : state.searchError == true
                    ? Center(
                        child: ErrorMessageText(
                          message: state.searchErrorMessage ?? GeneralErrors.generalError,
                        ),
                      )
                    : state.orgsList.isNotEmpty
                        ? Scrollbar(
                            controller: _scrollController,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                controller: _scrollController,
                                itemCount: state.orgsList.length,
                                itemBuilder: (_, int index) {
                                  return CustomSelectRow(
                                    index: index,
                                    item: SelectObject(id: state.orgsList[index].id.toString(), title: state.orgsList[index].name),
                                    last: index == (state.orgsList.length - 1),
                                    checkedId: (state.selectedOrg != null) ? state.selectedOrg!.id.toString() : null,
                                    callback: (__, _) {
                                      StoreProvider.of<AppState>(context).dispatch(
                                        UpdateGeneralProtocolData(
                                            selectedorg: state.orgsList[index],
                                            selectedDistrict: state.selectedDistrict,
                                            selectedMunicpality: state.selectedMunicipality),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }),
                          )
                        : Center(
                            child: Text(
                              (state.errorMessage != null && state.errorMessage != '') ? state.errorMessage! : GeneralErrors.emptyData,
                              style: AppTextStyle.roboto14W400.apply(color: AppColors.primaryDark),
                            ),
                          );
          },
        ),
      ),
    );
  }
}
