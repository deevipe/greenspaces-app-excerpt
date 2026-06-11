import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_green_space_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_object_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_form_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_green_space_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/dividing_line.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_chip_button.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/string_extensions.dart';

class ProtocolGreenSpaceScreen extends StatelessWidget {
  final String? address;
  const ProtocolGreenSpaceScreen({Key? key, @QueryParam() required this.address}) : super(key: key);

  void _nextStepHandler(BuildContext context) {
    ProtocolGreenSpaceViewModel state = StoreProvider.of<AppState>(context).state.protocolGreenSpaceState;

    if (state.selectedGreenSpace == null) {
      HelperUtils.showErrorMessage(context: context, message: GeneralErrors.selectGreenSpace);
    } else {
      // Запушим новый тип ЗН для след. экрана
      StoreProvider.of<AppState>(context).dispatch(SetObjectGreenSpaceType(type: state.selectedGreenSpace!));

      context.router.push(ProtocolTerritoryObjectDetailRoute(objectTitle: state.selectedGreenSpace!.title.toCapitalized(), address: address));
    }
  }

  void _selectHandler(context, ElementType element) async {
    ProtocolGreenSpaceViewModel state = StoreProvider.of<AppState>(context).state.protocolGreenSpaceState;

    if (state.selectedGreenSpace != element) {
      StoreProvider.of<AppState>(context).dispatch(UpdateGSAction(selected: element));
      StoreProvider.of<AppState>(context).dispatch(UpdateObjectData(stemList: [], copy: false));
      // Ресет чекбокса "Многоствольный"
      StoreProvider.of<AppState>(context).dispatch(HandleMultistemCheckbox(value: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                color: AppColors.primaryLight,
                padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                child: StoreConnector<AppState, ProtocolGreenSpaceViewModel>(
                    converter: (store) => store.state.protocolGreenSpaceState,
                    onInit: (store) => store.dispatch(getAvailableGreenSpaces()),
                    distinct: true,
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            address ?? '',
                            style: AppTextStyle.roboto14W500,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const AppDividerLine(),
                          const ProjectScreenHeader(title: ProtocolHeaderTitles.protocolFormObject),
                          const ProjectScreenHeader(
                            title: ProtocolHeaderTitles.protocolFormObjectSub,
                            margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Column(
                            children: List.generate(
                              state.availableList.length,
                              (index) => CustomChipButton(
                                label: state.availableList[index].title.toCapitalized(),
                                onTap: () => _selectHandler(context, state.availableList[index]),
                                selected: state.selectedGreenSpace == state.availableList[index],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          AppRoundedButton(
                            color: AppColors.green,
                            label: BtnLabel.continueBtn,
                            handler: () => _nextStepHandler(context),
                            isProcessing: false,
                            labelStyle: AppTextStyle.roboto14W500.apply(
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      );
                    }),
              );
            },
            childCount: 1,
          ),
        ),
        SliverFillRemaining(
          child: Container(
            color: AppColors.primaryLight,
          ),
        )
      ],
    );
  }
}
