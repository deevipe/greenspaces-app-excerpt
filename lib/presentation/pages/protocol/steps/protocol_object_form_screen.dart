import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_constraints.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/stem_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/protocol_object_form_action.dart';
import 'package:gisogs_greenspacesapp/domain/enums/save_draft_redirect.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/green_space_type_forms/bush_form_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/green_space_type_forms/default_form_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/green_space_type_forms/tree_form_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_media_controls_widget.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/protocol/components/protocol_screen_header.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_green_space_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_object_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_territory_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_form_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_save_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/media_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/media/uploading_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_object_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/custom_inkwell.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/dividing_line.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/error_message_text.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_checkbox.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_input.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/loader.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class ProtocolTerritoryObjectDetailScreen extends StatefulWidget {
  final String? objectTitle;
  final String? address;
  const ProtocolTerritoryObjectDetailScreen({super.key, @QueryParam() required this.objectTitle, @QueryParam() this.address});

  @override
  State<ProtocolTerritoryObjectDetailScreen> createState() => _ProtocolTerritoryObjectDetailScreenState();
}

class _ProtocolTerritoryObjectDetailScreenState extends State<ProtocolTerritoryObjectDetailScreen> {
  StreamController<ObjectFormAction> eventController = StreamController<ObjectFormAction>();
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _otherWorkTypeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final ValueNotifier<String?> _kindSelected = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _objectStateSelected = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _workTypeSelected = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _workSubTypeSelected = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _stemDiameterSelected = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _ageSelected = ValueNotifier<String?>(null);

  final Map<String, TextEditingController> _inputControls = {};
  final Map<String, ValueNotifier> _inputNotifierValues = {};
  final Map<String, Widget> _inputWidgets = {};
  final List<Widget> _widgetsList = [];

  bool goToListProcessing = false;
  bool saveAndAddNewTerritory = false;
  bool saveAndAddNewElement = false;
  bool processingProtocol = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _otherWorkTypeController.dispose();
    _amountController.dispose();
    _areaController.dispose();

    _inputControls.forEach((_, controller) {
      controller.dispose();
    });

    if (!eventController.isClosed) {
      eventController.close();
    }

    super.dispose();
  }

  void _mediaCallBack({required int areaId}) {
    String subTitle = '${widget.objectTitle?.toLowerCase()}';
    if (_kindSelected.value != null) {
      final String kind = _kindSelected.value!.split('_')[1];
      subTitle += ', $kind';
    }

    if (_stemDiameterSelected.value != null) {
      final String diameter = _stemDiameterSelected.value!.split('_')[1];
      subTitle += '($diameter)';
    }

    if (_workTypeSelected.value != null) {
      final String type = _workTypeSelected.value!.split('_')[1];
      subTitle += ', ${type.toLowerCase()}';
    }

    context.router.push(ProtocolMediaStepRoute(subTitle: subTitle, areaId: areaId));
  }

  void _onSelectChangeHandler() {
    ProtocolObjectViewModel state = StoreProvider.of<AppState>(context).state.protocolCreateObjectState;

    String selectedWorkTypeId = HelperUtils.parseSelectedValueId(notifier: _workTypeSelected);
    if (selectedWorkTypeId == '4' && state.selectedWorkType != '4') StoreProvider.of<AppState>(context).dispatch(getFellingSubtypes());
    // Обновляем данные в redux
    _updateFormState();

    if (selectedWorkTypeId != '4') StoreProvider.of<AppState>(context).dispatch(DropWorkSubTypes());
  }

  void _updateValueNotifiers() {
    ProtocolObjectViewModel state = StoreProvider.of<AppState>(context).state.protocolCreateObjectState;
    if (state.selectedKind != _kindSelected.value) {
      _kindSelected.value = state.selectedKind;
    }

    if (state.selectedWorkType != _workTypeSelected.value) {
      _workTypeSelected.value = state.selectedWorkType;
    }

    if (state.selectedWorkSubType != _workSubTypeSelected.value) {
      _workSubTypeSelected.value = state.selectedWorkSubType;
    }

    if (state.selectedObjectState != _objectStateSelected.value) {
      _objectStateSelected.value = state.selectedObjectState;
    }

    if (state.selectedDiameter != _stemDiameterSelected.value) {
      _stemDiameterSelected.value = state.selectedDiameter;
    }
  }

  /// добавление следующего ЗН. Сохранение текущего ЗН в redux
  /// обновление данного этапа и медиа
  void _addNextElement() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //  При вызове этого метода у нас уже есть сохраненный проект-протокол с текущей территорией и данным ЗН
    setState(() => saveAndAddNewElement = true);
    StoreProvider.of<AppState>(context).dispatch(saveGreenSpaceItem(newObject: false, draft: true, newElement: true));
  }

  /// Промежуточное сохранение данных по проекту (созранение текущего объекта с данными ЗН)
  /// Переход на этап выбора территории
  void _proceedToNextArea() {
    // Сохраняем объект
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => saveAndAddNewTerritory = true);
    StoreProvider.of<AppState>(context).dispatch(saveGreenSpaceItem(newObject: true, draft: true));
  }

  /// Сохранение протокола в статусе, в котором он попадет в реестр протоколов
  /// Переход на экран "список по адресу"
  void _saveToDraft({bool mediaScreen = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    // Нужно добавить флаг, по которому при изменении стейта будет понятно, что нужен переход
    // на экран ProtocolObjectsListRoute
    if (!mediaScreen) {
      setState(() => goToListProcessing = true);
    }

    StoreProvider.of<AppState>(context).dispatch(saveGreenSpaceItem(newObject: false, draft: true));
  }

  Future<int?> _preSaveDraft() async {
    setState(() => processingProtocol = true);
    final Completer<int?> completer = Completer();
    // Сохраним area в состоянии приложения
    StoreProvider.of<AppState>(context).dispatch(saveGreenSpaceItem(newObject: false, draft: false, mediaScreen: true));
    StoreProvider.of<AppState>(context).dispatch(saveDraft(completer: completer, option: DraftRedirect.none));

    return completer.future;
  }

  Future<void> _preProcessDraft() async {
    await _preSaveDraft().then((value) {
      if (value != null) {
        _mediaCallBack(areaId: value);
      } else {
        HelperUtils.showErrorMessage(context: context, message: GeneralErrors.generalError);
      }
      setState(() => processingProtocol = false);
    });
  }

  void _buildStemField({required bool copy, required int oldVal, required int newVal}) {
    /// При копировании объекта полностью очистим все старые значения,
    /// если они были и заполним значениями из стейта
    if (copy) {
      _inputWidgets.clear();
      _inputControls.clear();
      _inputNotifierValues.clear();

      ProtocolObjectViewModel state = StoreProvider.of<AppState>(context).state.protocolCreateObjectState;

      for (var el in state.stemList) {
        final String name = el.name;
        final TextEditingController controller = TextEditingController();
        // Передадим в контроллер значение диаметра
        controller.text = el.diameter ?? '';
        final ValueNotifier<bool> notifier = ValueNotifier(el.demolish);

        _inputWidgets[name] = _StemRowWidget(
          name: name,
          controller: controller,
          notifier: notifier,
        );

        _inputControls[name] = controller;
        _inputNotifierValues[name] = notifier;
      }
    } else {
      if (newVal != 0 && newVal > oldVal) {
        final String name = 'Диаметр, см $newVal ствола';
        final TextEditingController controller = TextEditingController();
        final ValueNotifier<bool> notifier = ValueNotifier(false);

        _inputWidgets[name] = _StemRowWidget(
          name: name,
          controller: controller,
          notifier: notifier,
        );

        _inputControls[name] = controller;
        _inputNotifierValues[name] = notifier;
      } else if (newVal < oldVal) {
        final String name = 'Диаметр, см $oldVal ствола';
        _removeStemWidget(key: name);
      }
    }

    _convertMapToList();
  }

  void _removeStemWidget({required String key}) {
    _inputWidgets.remove(key);
    TextEditingController? removedController = _inputControls.remove(key);
    if (removedController != null) {
      removedController.dispose();
    }
    _inputNotifierValues.remove(key);
  }

  void _convertMapToList() {
    _widgetsList.clear();
    if (_inputWidgets.isNotEmpty) {
      _inputWidgets.forEach((_, widget) {
        if (!_widgetsList.contains(widget)) {
          _widgetsList.add(widget);
        }
      });
    }
  }

  void _submitForm({required ObjectFormAction action}) {
    _updateFormState();

    switch (action) {
      case ObjectFormAction.addTerritory:
        if (_checkMediaState()) {
          _proceedToNextArea();
        }
        break;
      case ObjectFormAction.nextObject:
        if (_checkMediaState()) {
          _addNextElement();
        }

        break;
      case ObjectFormAction.goToProject:
        if (_checkMediaState()) {
          _saveToDraft();
        }

        break;
      case ObjectFormAction.openMediaScreen:
        _preProcessDraft();
        break;
    }
  }

  bool _checkMediaState() {
    MediaViewModel mediaState = StoreProvider.of<AppState>(context).state.mediaState;
    if (mediaState.uploadQueue.isNotEmpty) {
      // Дополнительно проверить, чтобы был загружен хотя бы 1 элемент из фото
      bool noPhotosUploaded = true;
      for (UploadingModel element in mediaState.uploadQueue) {
        if (element.uploadDone) {
          noPhotosUploaded = false;
        }
      }
      if (noPhotosUploaded) {
        HelperUtils.showErrorMessage(context: context, message: GeneralErrors.needToUploadAtLeastAPhoto);
        return false;
      } else {
        return true;
      }
    } else {
      HelperUtils.showErrorMessage(context: context, message: GeneralErrors.needToTakePhotos);
      return false;
    }
  }

  void _updateFormState() {
    ProtocolObjectViewModel state = StoreProvider.of<AppState>(context).state.protocolCreateObjectState;

    List<Stem> stems = [];
    // ключи _inputNotifierValues & _inputControls идентичны
    for (var key in _inputNotifierValues.keys) {
      stems.add(
        Stem(name: key, diameter: _inputControls[key]?.text, demolish: _inputNotifierValues[key]?.value ?? false),
      );
    }

    // Обновляем данные в redux
    StoreProvider.of<AppState>(context).dispatch(UpdateObjectData(
      selectedKind: _kindSelected.value,
      selectedObjectState: _objectStateSelected.value,
      selectedWorkSubType: _workSubTypeSelected.value,
      selectedWorkType: _workTypeSelected.value,
      otherStateValue: '',
      selectedAge: _ageSelected.value,
      stemAmount: state.stemAmount,
      selectedDiameter: _stemDiameterSelected.value,
      stemList: stems,
      areaValue: _areaController.text,
      amountValue: _amountController.text,
      copy: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProtocolObjectViewModel>(
        converter: (store) => store.state.protocolCreateObjectState,
        distinct: true,
        onInit: (store) {
          final ProtocolObjectViewModel state = store.state.protocolCreateObjectState;

          if (state.kind.isEmpty || state.objectState.isEmpty || state.workType.isEmpty || state.workSubType.isEmpty) {
            store.dispatch(getObjectSelects());
          }
        },
        onWillChange: (oldState, state) async {
          if (state.stemAmount != null) {
            _buildStemField(
              copy: state.copy,
              oldVal: int.parse(oldState?.stemAmount ?? '0'),
              newVal: int.parse(state.stemAmount!),
            );
          }

          if (oldState?.processingDraft == true && state.processingDraft == false && state.isError == false) {
            saveAndAddNewTerritory = false;
            saveAndAddNewElement = false;
            goToListProcessing = false;

            switch (state.redirectOption) {
              case DraftRedirect.objectsList:
                StoreProvider.of<AppState>(context).dispatch(ResetGreenSpace());
                context.router.popAndPush(const ProtocolObjectsListRoute());
                break;
              case DraftRedirect.newElement:
                StoreProvider.of<AppState>(context).dispatch(ResetGreenSpace());
                context.router.pop();
                break;
              case DraftRedirect.newTerritory:
                StoreProvider.of<AppState>(context).dispatch(ResetGreenSpace());
                StoreProvider.of<AppState>(context).dispatch(IncrementObjectIndex());
                StoreProvider.of<AppState>(context).dispatch(DropSelectedTerritory());
                context.router.popUntilRouteWithName('ProtocolTerritoryRoute');
                break;
              default:
                break;
            }
          }

          if (state.isError == true) {
            saveAndAddNewTerritory = false;
            saveAndAddNewElement = false;
            goToListProcessing = false;

            HelperUtils.showErrorMessage(context: context, message: state.errorMessage ?? GeneralErrors.saveFail);
          }
        },
        builder: (_, state) {
          _updateValueNotifiers();
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                (state.isLoading == true)
                    ? SliverFillRemaining(
                        child: Container(
                            color: AppColors.primaryLight,
                            padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  widget.address!,
                                  style: AppTextStyle.roboto14W500,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                const AppDividerLine(),
                                const ProjectScreenHeader(title: ProtocolHeaderTitles.protocolFormObject),
                                ProjectScreenHeader(
                                  title: widget.objectTitle ?? '',
                                  margin: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Expanded(
                                  child: Center(
                                    child: state.isLoading ? const Loader() : ErrorMessageText(message: state.errorMessage ?? GeneralErrors.generalError),
                                  ),
                                )
                              ],
                            )))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Container(
                            color: AppColors.primaryLight,
                            padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  widget.address!,
                                  style: AppTextStyle.roboto14W500,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                const AppDividerLine(),
                                const ProjectScreenHeader(title: ProtocolHeaderTitles.protocolFormObject),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ProjectScreenHeader(
                                      title: widget.objectTitle ?? '',
                                      margin: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                                    ),
                                    if (state.savedItems.isNotEmpty &&
                                        state.savedItems.length != state.objectIndex &&
                                        state.savedItems[state.objectIndex].items.isNotEmpty &&
                                        StoreProvider.of<AppState>(context).state.protocolGreenSpaceState.selectedGreenSpace ==
                                            state.savedItems[state.objectIndex].items.last.type)
                                      InkwellButton(
                                          child: SvgPicture.asset(AppIcons.copyIcon),
                                          function: () => StoreProvider.of<AppState>(context).dispatch(copyLastGreenSpace()))
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    state.type?.id == 1
                                        ? TreeFormWidget(
                                            eventStream: eventController.stream,
                                            state: state,
                                            searchController: _searchController,
                                            otherWorkTypeController: _otherWorkTypeController,
                                            kindSelected: _kindSelected,
                                            stemDiameterSelected: _stemDiameterSelected,
                                            workTypeSelected: _workTypeSelected,
                                            workSubTypeSelected: _workSubTypeSelected,
                                            objectStateSelected: _objectStateSelected,
                                            onSelectChangeHandler: _onSelectChangeHandler,
                                            submitForm: _submitForm,
                                            stemWidget: _widgetsList,
                                            diameters: state.diameters,
                                          )
                                        : state.type?.id == 2
                                            ? BushFormWidget(
                                                eventStream: eventController.stream,
                                                state: state,
                                                searchController: _searchController,
                                                amountController: _amountController,
                                                kindSelected: _kindSelected,
                                                ageSelected: _ageSelected,
                                                onSelectChangeHandler: _onSelectChangeHandler,
                                                workTypeSelected: _workTypeSelected,
                                                submitForm: _submitForm,
                                                ages: state.ages,
                                              )
                                            : DefaultFormWidget(
                                                eventStream: eventController.stream,
                                                state: state,
                                                areaController: _areaController,
                                                workTypeSelected: _workTypeSelected,
                                                onSelectChangeHandler: _onSelectChangeHandler,
                                                amountController: _amountController,
                                                searchController: _searchController,
                                                submitForm: _submitForm,
                                              ),
                                    MediaControlsBlock(
                                      mediaHandler: () => eventController.add(ObjectFormAction.openMediaScreen),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    AppRoundedButton(
                                      color: AppColors.primaryLight,
                                      label: BtnLabel.addNextObject,
                                      handler: () => eventController.add(ObjectFormAction.nextObject),
                                      isProcessing: saveAndAddNewElement,
                                      disabled: state.processingDraft,
                                      labelStyle: AppTextStyle.roboto14W500.apply(
                                        color: AppColors.green,
                                      ),
                                      loaderColor: AppColors.green,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    AppRoundedButton(
                                      color: AppColors.green,
                                      label: BtnLabel.saveAndProceed,
                                      handler: () => eventController.add(ObjectFormAction.addTerritory),
                                      isProcessing: saveAndAddNewTerritory,
                                      disabled: state.processingDraft,
                                      labelStyle: AppTextStyle.roboto14W500.apply(
                                        color: AppColors.primaryLight,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    AppRoundedButton(
                                      color: AppColors.green,
                                      label: BtnLabel.saveAndGoToProject,
                                      handler: () => eventController.add(ObjectFormAction.goToProject),
                                      isProcessing: goToListProcessing,
                                      disabled: state.processingDraft,
                                      labelStyle: AppTextStyle.roboto14W500.apply(
                                        color: AppColors.primaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }, childCount: 1),
                      ),
              ],
            ),
          );
        });
  }
}

class _StemRowWidget extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final ValueNotifier<bool> notifier;
  const _StemRowWidget({Key? key, required this.name, required this.controller, required this.notifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                name,
                style: AppTextStyle.openSans14W500,
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 80.0),
                child: CustomInput(
                  label: '',
                  maxLines: 1,
                  controller: controller,
                  isInvalid: false,
                  isProcessing: false,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: ValueListenableBuilder(
                  valueListenable: notifier,
                  builder: (BuildContext context, bool val, Widget? child) {
                    return CustomCheckBox(
                      callback: () => notifier.value = !notifier.value,
                      label: '',
                      checked: notifier.value,
                      noLabel: true,
                      width: 30,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }
}
