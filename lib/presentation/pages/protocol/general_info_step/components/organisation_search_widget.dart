import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/general_info_step/components/organisation_search_modal.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_general_data_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/general_step_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_general_data_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_input_with_action.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OrganisationSearchWidget extends StatefulWidget {
  final ProtocolGeneralViewModel state;
  final TextEditingController otherController;
  final FocusNode otherFocusNode;
  const OrganisationSearchWidget({Key? key, required this.otherController, required this.otherFocusNode, required this.state}) : super(key: key);

  @override
  State<OrganisationSearchWidget> createState() => _OrganisationSearchWidgetState();
}

class _OrganisationSearchWidgetState extends State<OrganisationSearchWidget> {
  TextEditingController get _queryController => widget.otherController;
  ProtocolGeneralViewModel get _state => widget.state;
  bool queryValid = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _queryController.addListener(_queryListener);
  }

  @override
  void dispose() {
    _queryController.removeListener(_queryListener);
    super.dispose();
  }

  void _queryListener() {
    if (_queryController.text != '' && !queryValid && _queryController.text.length >= 3) {
      setState(() {
        queryValid = true;
        errorMessage = '';
      });
    }
  }

  void _searchCallback() {
    // Отправим action на поиск подходящей организации
    if (_queryController.text.length >= 3) {
      StoreProvider.of<AppState>(context).dispatch(searchOrgs(query: _queryController.text, generalStep: true));
      FocusManager.instance.primaryFocus?.unfocus();
      // Сразу же откроем модальное окно для отображения результатов / ошибки
      showMaterialModalBottomSheet(
        useRootNavigator: true,
        expand: false,
        context: context,
        backgroundColor: AppColors.transparent,
        builder: (context) => const OrganisationSearchModalContent(),
      ).then((value) {
        StoreProvider.of<AppState>(context).dispatch(SearchOrgsSuccess(list: StoreProvider.of<AppState>(context).state.protocolGeneralStepState.orgsList));
      });
    } else {
      setState(() {
        queryValid = false;
        errorMessage = 'Для поиска необходимо ввести минимум 3 символа';
      });
    }
  }

  void _deleteCallback() {
    StoreProvider.of<AppState>(context).dispatch(ClearOrg());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          opacity: queryValid ? 0 : 1,
          duration: const Duration(milliseconds: 800),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3.0, left: 5.0),
            child: Text(
              errorMessage,
              style: AppTextStyle.openSans12W400.apply(color: AppColors.red),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_state.selectedOrg != null) {
              showMaterialModalBottomSheet(
                useRootNavigator: true,
                expand: false,
                context: context,
                backgroundColor: AppColors.transparent,
                builder: (context) => const OrganisationSearchModalContent(),
              );
            }
          },
          child: CustomActionInput(
            label: AppDictionary.searchField,
            maxLines: 2,
            controller: _queryController,
            focusNode: widget.otherFocusNode,
            isInvalid: _state.selectedOrg != null,
            isProcessing: _state.searchingOrgs,
            callbcak: _searchCallback,
            callback2: _deleteCallback,
            secondCallback: _state.selectedOrg != null,
          ),
        ),
      ],
    );
  }
}
