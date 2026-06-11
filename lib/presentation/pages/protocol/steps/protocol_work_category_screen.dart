import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_work_category_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_form_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_work_category_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/error_message_text.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_chip_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/string_extensions.dart';

class ProtocolCategoryScreen extends StatelessWidget {
  const ProtocolCategoryScreen({super.key});

  void _nextStepHandler(BuildContext context) {
    ProtocolWorkCategoryViewModel state = StoreProvider.of<AppState>(context).state.protocolCategoryStepState;

    if (state.selectedCategory == null) {
      HelperUtils.showErrorMessage(context: context, message: GeneralErrors.selectWorkCategory);
    } else {
      context.router.push(const ProtocolConditionsRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverFillRemaining(
        child: Container(
          color: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
          child: StoreConnector<AppState, ProtocolWorkCategoryViewModel>(
              onInit: (store) => store.state.protocolCategoryStepState.categories.isNotEmpty ? null : store.dispatch(getWorkCategories()),
              converter: (store) => store.state.protocolCategoryStepState,
              distinct: true,
              builder: (context, state) {
                return state.isLoading
                    ? const Center(
                        child: Loader(),
                      )
                    : state.isError == true
                        ? Center(
                            child: ErrorMessageText(
                              message: state.errorMessage ?? GeneralErrors.generalError,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ProjectScreenHeader(title: ProtocolHeaderTitles.protocolFormCategory),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Column(
                                children: List.generate(
                                  state.categories.length,
                                  (index) => CustomChipButton(
                                    label: state.categories[index].title.toCapitalized(),
                                    onTap: () =>
                                        StoreProvider.of<AppState>(context).dispatch(UpdateProtocolWorkCategory(categoryId: state.categories[index].id)),
                                    selected: state.selectedCategory == state.categories[index].id,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
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
        ),
      ),
    ]);
  }
}
