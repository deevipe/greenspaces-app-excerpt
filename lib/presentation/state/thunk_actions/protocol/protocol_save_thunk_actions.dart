import 'dart:async';

import 'package:dio/dio.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/dio_settings.dart';
import 'package:gisogs_greenspacesapp/config/exceptions.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/login/user_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object_item.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/protocol_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';
import 'package:gisogs_greenspacesapp/domain/enums/protocol_status.dart';
import 'package:gisogs_greenspacesapp/domain/enums/save_draft_redirect.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/use_case_module.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/media_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_general_data_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_green_space_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_object_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_representatives_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_territory_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_work_category_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_work_condition_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_form_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_general_data_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_green_space_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_object_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_representatives_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_territory_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_work_conditions_view_model.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Сохранение в стейт подготовленной модели areaList
ThunkAction<AppState> saveGreenSpaceItem({
  required bool newObject,
  required bool draft,
  bool mediaScreen = false,
  bool newElement = false,
}) =>
    (Store<AppState> store) async {
      final ProtocolObjectViewModel objectState = store.state.protocolCreateObjectState;
      final ProtocolGreenSpaceViewModel greenSpaceState = store.state.protocolGreenSpaceState;
      final ProtocolTerritoryViewModel territoryState = store.state.protocolTerritoryState;

      // Конвертируем стейт в модель и обновим redux
      final GreenSpaceObjectItem newGreenSpaceItem = GreenSpaceObjectItem(
        id: store.state.protocolCreateObjectState.elementId,
        typeId: greenSpaceState.selectedGreenSpace!.id,
        type: greenSpaceState.selectedGreenSpace!,
        multiStem: objectState.multiStem,
        selectedKind: objectState.selectedKind,
        selectedWorkType: objectState.selectedWorkType,
        selectedWorkSubType: objectState.selectedWorkSubType,
        selectedObjectState: objectState.selectedObjectState,
        selectedDiameter: objectState.selectedDiameter,
        otherStateValue: objectState.otherStateValue,
        pictures: store.state.mediaState.uploadQueue.map((e) => e.file.id).toList().cast<String?>(),
        selectedAge: objectState.selectedAge,
        areaValue: objectState.areaValue,
        amountValue: objectState.amountValue,
        stemAmount: objectState.stemAmount,
        stemList: objectState.stemList,
      );

      List<GreenSpaceObject> objectsList = [];
      List<GreenSpaceObjectItem> newList = [];
      if (objectState.savedItems.isEmpty) {
        newList.add(newGreenSpaceItem);
        objectsList.add(
          GreenSpaceObject(
            ogs: territoryState.ogs,
            territoryTypeId: store.state.protocolTerritoryState.selectedType!,
            address: store.state.protocolTerritoryState.address,
            items: newList,
          ),
        );
      } else if (objectState.savedItems.length == objectState.objectIndex) {
        objectsList = List.from(objectState.savedItems);
        newList.add(newGreenSpaceItem);
        objectsList.add(
          GreenSpaceObject(
            ogs: territoryState.ogs,
            territoryTypeId: store.state.protocolTerritoryState.selectedType!,
            address: store.state.protocolTerritoryState.address,
            items: newList,
          ),
        );
      } else {
        objectsList = List.from(objectState.savedItems);
        newList = List.from(objectState.savedItems[objectState.objectIndex].items);
        if (newGreenSpaceItem.id != null && newGreenSpaceItem.id != 0) {
          // На всякий случай обновим уже сохраненный элемент
          for (var i = 0; i < newList.length; i++) {
            if (newList[i].id == newGreenSpaceItem.id) {
              newList[i] = newGreenSpaceItem;
            }
          }
        } else {
          newList.add(newGreenSpaceItem);
        }
        objectsList[objectState.objectIndex] = objectsList[objectState.objectIndex].copyWith(newItems: newList);
      }

      store.dispatch(SaveGreenSpaceItem(savedItems: objectsList));

      draft
          ? store.dispatch(saveDraft(
              option: newObject
                  ? DraftRedirect.newTerritory
                  : newElement
                      ? DraftRedirect.newElement
                      : DraftRedirect.objectsList))
          : null;

      if (!mediaScreen) {
        store.dispatch(ResetMediaState());
      }
    };

ThunkAction<AppState> copyLastGreenSpace() => (Store<AppState> store) async {
      store.dispatch(FetchingObjectSelectData());
      ProtocolObjectViewModel state = store.state.protocolCreateObjectState;
      final GreenSpaceObjectItem itemToCopy = state.savedItems[state.objectIndex].items.last;

      /// Обновим данные чекбокса "Многоствольный"
      /// Делаем это до UpdateObjectData чтобы не сбить флаг copy
      store.dispatch(HandleMultistemCheckbox(value: itemToCopy.multiStem));

      store.dispatch(UpdateObjectData(
        selectedKind: itemToCopy.selectedKind,
        selectedObjectState: itemToCopy.selectedObjectState,
        selectedWorkSubType: itemToCopy.selectedWorkSubType,
        selectedWorkType: itemToCopy.selectedWorkType,
        otherStateValue: itemToCopy.otherStateValue,
        selectedDiameter: itemToCopy.selectedDiameter,
        stemAmount: itemToCopy.stemAmount,
        stemList: itemToCopy.stemList,
        copy: true,
      ));

      String selectedWorkTypeId = '';
      if (itemToCopy.selectedWorkType != null && itemToCopy.selectedWorkType != '') {
        selectedWorkTypeId = itemToCopy.selectedWorkType!.split('_').first;
      }
      if (selectedWorkTypeId == '4') store.dispatch(getFellingSubtypes());
    };

ThunkAction<AppState> saveDraft(
        {Completer<int?>? completer, bool? saveFiles, ProtocolStatus newStatus = ProtocolStatus.draft, DraftRedirect option = DraftRedirect.objectsList}) =>
    (Store<AppState> store) async {
      store.dispatch(ToogleSaveProtocolProcess(isProcessing: true, option: DraftRedirect.none));

      final User user = store.state.userAppBarState.user;
      final ProtocolGeneralViewModel generalStepState = store.state.protocolGeneralStepState;
      final ProtocolRepresentativesViewModel representativesState = store.state.protocolRepresentativesState;
      final ProtocolWorkConditionViewModel conditionstState = store.state.protocolConditionStepState;

      int? draftId = generalStepState.draftId;

      // Объединим списки представителей для модели
      final List<Representative> combinedRepreentatives = [...representativesState.committeeRepresentatives, ...representativesState.sppRepresentatives];

      Representative? otherRepresentative;

      if (representativesState.selectedOtherOrg != null && representativesState.selectedOtherOrg!.isNotEmpty) {
        final List<String> splitOrgData = representativesState.selectedOtherOrg!.split('_');
        otherRepresentative = Representative(
          orgId: int.parse(splitOrgData.first),
          orgName: splitOrgData.last,
          typeId: 3,
          userName: representativesState.otherFieldFio,
          userPhone: representativesState.otherFieldPhone,
          userPosition: representativesState.otherFieldPosition,
        );
      }

      final ProtocolEntity protocolDraft = ProtocolEntity(
        id: draftId,
        user: user,
        date: generalStepState.date,
        selectedDistrict: generalStepState.selectedDistrict,
        selectedMunicipality: generalStepState.selectedMunicipality,
        selectedOrg: generalStepState.selectedOrg,
        departmentId: generalStepState.departmentId,
        contract: generalStepState.contract,
        subContract: generalStepState.subContract,
        otherOpt: generalStepState.otherOpt,
        contractRequisites: generalStepState.contractRequisites,
        subContractRequisites: generalStepState.subContractRequisites,
        otherRequisites: generalStepState.otherRequisites,
        workCategory: store.state.protocolCategoryStepState.selectedCategory!,
        selectedWorkConditions: conditionstState.selectedCondition,
        otherConditionName: conditionstState.otherName,
        representatives: combinedRepreentatives,
        otherRepresentative: otherRepresentative,
        objects: store.state.protocolCreateObjectState.savedItems,
        history: [],
        docs: [],
        projectPhotos: [],
        projectFiles: [],
        status: newStatus,
      );

      try {
        // в ответ должен вернуться id нового протокола
        final int? protocolId = await UseCaseModule.protocol().saveProtocol(protocolDraft: protocolDraft, revision: false);
        if (protocolId != null) {
          store.dispatch(SetProtocolDraftId(id: protocolId, revision: false));

          if (newStatus == ProtocolStatus.draft) {
            // Необходимо сохранить areaList
            List<AreaType> territories = UseCaseModule.local().getProtocolTerritory();
            try {
              final bool areaResult = await UseCaseModule.protocol()
                  .saveProtocolAreaList(protocolDraft: protocolDraft, protocolId: protocolId, territories: territories, revision: false);

              if (!areaResult) {
                store.dispatch(store.dispatch(ProtocolObjectError(errorMessage: 'Не удалось сохранить список территорий')));

                // удалим последний элемент, который был добавлен с экрана
                deleteLastProtocolElement();
                completer?.complete(null);
                return;
              } else {
                // Запросим список areaList чтобы обновить данные в state (прописать все необходимые id);
                final List<GreenSpaceObject> apiList = await UseCaseModule.protocol().getAreaList(protocolId: protocolId);
                if (apiList.isNotEmpty) {
                  store.dispatch(SaveGreenSpaceItem(savedItems: apiList));
                  final GreenSpaceObjectItem lastSavedItem = apiList[store.state.protocolCreateObjectState.objectIndex].items.last;

                  // установим elementId текущего элемента после сохранения. Если это переход на новый элемент
                  // необходимо это значение сбросить
                  store.dispatch(
                      SetAreaAndElementId(elementId: lastSavedItem.id ?? 0, areaId: apiList[store.state.protocolCreateObjectState.objectIndex].id ?? 0));
                  completer?.complete(lastSavedItem.id);
                }
              }
            } catch (_) {
              store.dispatch(store.dispatch(ProtocolObjectError(errorMessage: 'Не удалось сохранить список территорий')));
              deleteLastProtocolElement();
              completer?.complete(null);
              return;
            }

            store.dispatch(ToogleSaveProtocolProcess(isProcessing: false, option: option));
          } else {
            // send not null completer to finish waiting process;
            completer?.complete(0);
          }
        } else {
          completer?.complete(null);
          store.dispatch(ProtocolObjectError(errorMessage: GeneralErrors.saveFail));
        }
      } on AuthorizationException {
        store.dispatch(ProtocolObjectError(errorMessage: GeneralErrors.unAuthorized));
        completer?.complete(null);
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        completer?.complete(null);
        store.dispatch(ProtocolObjectError(errorMessage: errorMessage));
      }
    };

ThunkAction<AppState> resetAllFormSteps() => (Store<AppState> store) async {
      store.dispatch(ResetGeneralProtocolData());
      store.dispatch(ResetProtocolWorkCategory());
      store.dispatch(ResetProtocolWorkCondition());
      store.dispatch(ResetRepresentativesStep());
      store.dispatch(DropSelectedTerritory());
      store.dispatch(ResetGreenSpace());
      store.dispatch(ResetGreenSpaceItems());
      store.dispatch(ResetMediaState());
    };

ThunkAction<AppState> deleteLastProtocolElement() => (Store<AppState> store) {
      final ProtocolObjectViewModel objectState = store.state.protocolCreateObjectState;

      List<GreenSpaceObject> objectsList = List.from(objectState.savedItems);

      // Выберем последнюю рабочую территорию
      List<GreenSpaceObjectItem> newList = List.from(objectState.savedItems[objectState.objectIndex].items);

      newList.removeLast();

      objectsList[objectState.objectIndex] = objectsList[objectState.objectIndex].copyWith(newItems: newList);

      store.dispatch(SaveGreenSpaceItem(savedItems: objectsList));
    };
