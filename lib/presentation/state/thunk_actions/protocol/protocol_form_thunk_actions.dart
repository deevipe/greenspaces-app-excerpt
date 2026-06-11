import 'dart:async';

import 'package:dio/dio.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/dio_settings.dart';
import 'package:gisogs_greenspacesapp/config/exceptions.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/protocol_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_history.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_category.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/work_condition.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/use_case_module.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_general_data_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_green_space_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_history_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_object_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_representatives_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_territory_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_work_category_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_work_condition_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/general_step_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/protocol/protocol_representatives_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_green_space_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_object_view_model.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> getWorkCategories() => (Store<AppState> store) async {
      store.dispatch(FetchWorkCategories());
      try {
        final List<WorkCategory> categories = await UseCaseModule.protocol().getWorkCategories();

        store.dispatch(FetchWorkCategoriesSuccess(categories: categories));
      } on ParseException catch (e) {
        store.dispatch(WorkCategoryError(errorMessage: e.toString()));
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(WorkCategoryError(errorMessage: errorMessage));
      }
    };

ThunkAction<AppState> getWorkConditions() => (Store<AppState> store) async {
      // store.dispatch(FetchWorkCategories());
      try {
        final List<WorkCondition> conditions = await UseCaseModule.protocol().getWorkConditions();

        store.dispatch(FetchWorkConditionsSuccess(conditions: conditions));
      } on ParseException catch (e) {
        store.dispatch(WorkConditionsError(errorMessage: e.toString()));
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(WorkConditionsError(errorMessage: errorMessage));
      }
    };

ThunkAction<AppState> getObjectSelects() => (Store<AppState> store) async {
      store.dispatch(FetchingObjectSelectData());
      ProtocolGreenSpaceViewModel greenSpaceState = store.state.protocolGreenSpaceState;
      try {
        final List<SelectObject> kindList = UseCaseModule.local().getObjectKindSelect(gsType: greenSpaceState.selectedGreenSpace!.id);
        final List<SelectObject> objectStateList = UseCaseModule.local()
            .getObjectStateSelect(gsType: greenSpaceState.selectedGreenSpace!.id, workCategory: store.state.protocolCategoryStepState.selectedCategory!);
        final List<SelectObject> workTypeList = UseCaseModule.local().getWorkTypeSelect(gsType: greenSpaceState.selectedGreenSpace!.id);

        final List<SelectObject> diameters = UseCaseModule.local().getDiameters();
        final List<SelectObject> ages = UseCaseModule.local().getAges();

        store.dispatch(FetchObjectSelectDataSuccess(
            kind: kindList, objectState: objectStateList, workType: workTypeList, workSubType: [], diameters: diameters, ages: ages));
      } on ParseException catch (e) {
        store.dispatch(ProtocolObjectError(errorMessage: e.toString()));
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(ProtocolObjectError(errorMessage: errorMessage));
      }
    };

ThunkAction<AppState> getFellingSubtypes() => (Store<AppState> store) async {
      store.dispatch(FetchingWorkSubType());
      final List<SelectObject> fellingTypes = UseCaseModule.local().getFellingTypes();
      final ProtocolObjectViewModel state = store.state.protocolCreateObjectState;
      store.dispatch(FetchObjectSelectDataSuccess(
        kind: state.kind,
        objectState: state.objectState,
        workType: state.workType,
        workSubType: fellingTypes,
        ages: state.ages,
        diameters: state.diameters,
      ));
    };

ThunkAction<AppState> getTerritoryStep(Completer? completer) => (Store<AppState> store) async {
      store.dispatch(FetchingTerritoryData());
      try {
        final List<AreaType> list = UseCaseModule.local().getProtocolTerritory();

        store.dispatch(FetchingTerritoryDataSuccess(list: list));
      } on ParseException catch (e) {
        store.dispatch(ProtocolTerritoryError(errorMessage: e.toString()));
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(ProtocolTerritoryError(errorMessage: errorMessage));
      } finally {
        completer?.complete();
      }
    };

ThunkAction<AppState> getAvailableGreenSpaces() => (Store<AppState> store) async {
      store.dispatch(FetchingAvailableGSList());
      List<ElementType> availableList = [];

      // к этому шагу категория работ обязаны быть выбрана
      final int selectedWorkCategory = store.state.protocolCategoryStepState.selectedCategory!;
      availableList = UseCaseModule.local().getElementTypes(selectedWorkCat: selectedWorkCategory);

      store.dispatch(FetchingAvailableGSListSuccess(list: availableList));
    };

ThunkAction<AppState> getCurrentDraftHistory() => (Store<AppState> store) async {
      store.dispatch(FetchingProtocolHistory());
      List<ProtocolHistory> historyList = [];
      try {
        historyList = await UseCaseModule.protocol().getProtocolActionLog(protocolId: store.state.protocolGeneralStepState.draftId!);

        store.dispatch(FetchingProtocolHistorySuccess(list: historyList.reversed.toList().cast<ProtocolHistory>()));
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(ProtocolTerritoryError(errorMessage: errorMessage));
        store.dispatch(ProtocolHistoryError(
          errorMessage: errorMessage,
        ));
      }

      store.dispatch(
        FetchingProtocolHistorySuccess(list: historyList),
      );
    };

ThunkAction<AppState> prepareProtocolForRevison({required int protocolId}) => (Store<AppState> store) async {
      // Отправляем action, чтобы инициализировать загрузку первого экрана формы
      // и затем загрузить необходимы стек экранов
      store.dispatch(PrepareForRevision(finished: false));

      try {
        final ProtocolEntity? savedProtocol = await UseCaseModule.protocol().getProtocolDetail(protocolId: protocolId);

        if (savedProtocol != null) {
          // готовим по-этапно все состояния формы
          store.dispatch(SetProtocolDraftId(id: protocolId, revision: true));
          store.dispatch(getGeneralStepDictionaries());

          // если у нас есть выбранные municipality / org, заполним соответствющие
          // списки нужно информмацией
          if (savedProtocol.selectedDistrict != null) {
            store.dispatch(getMunicipalities(districtId: int.parse(savedProtocol.selectedDistrict!.id)));
          }

          // тоже самое сделаем с выбранной организацией
          if (savedProtocol.selectedOrg != null) {
            store.dispatch(searchOrgs(query: savedProtocol.selectedOrg!.name, generalStep: true));
          }

          store.dispatch(
            UpdateGeneralProtocolData(
              date: savedProtocol.date!,
              departmentId: savedProtocol.departmentId,
              selectedMunicpality: savedProtocol.selectedMunicipality,
              selectedDistrict: savedProtocol.selectedDistrict,
              selectedorg: savedProtocol.selectedOrg,
              contract: savedProtocol.contract,
              subContract: savedProtocol.subContract,
              otherOpt: savedProtocol.otherOpt,
              contractRequisites: savedProtocol.contractRequisites ?? '',
              subContractRequisites: savedProtocol.subContractRequisites ?? '',
              otherRequisites: savedProtocol.otherRequisites ?? '',
              docs: savedProtocol.docs,
            ),
          );

          // Получим словари для этапа категорий работы
          store.dispatch(getWorkCategories());
          store.dispatch(UpdateProtocolWorkCategory(categoryId: savedProtocol.workCategory));

          // Получим словари для этапа условий работы
          store.dispatch(getWorkConditions());
          store.dispatch(UpdateProtocolWorkCondition(condition: savedProtocol.selectedWorkConditions, otherName: savedProtocol.otherConditionName));

          // Получим словари для этапа категорий работы
          store.dispatch(getWorkCategories());
          store.dispatch(UpdateProtocolWorkCategory(categoryId: savedProtocol.workCategory));

          // Обработаем данные представителей
          store.dispatch(getRepresentativeSelects(null));

          final List<Representative> committeeRep = [];
          final List<Representative> sppRep = [];

          if (savedProtocol.representatives.isNotEmpty) {
            for (var representative in savedProtocol.representatives) {
              // комитет
              if (representative.typeId == 1) {
                committeeRep.add(representative);
              }
              // СПП
              if (representative.typeId == 2) {
                sppRep.add(representative);
              }
            }
          }

          // Обновим блок Иное на экране представителей
          store.dispatch(UpdateSelectChoice(
            widgetKey: null,
            committeeRepresentatives: committeeRep,
            sppRepresentatives: sppRep,
            otherOrg: savedProtocol.otherRepresentative?.orgId != null
                ? '${savedProtocol.otherRepresentative!.orgId}_${savedProtocol.otherRepresentative!.orgName}'
                : null,
            otherFieldFio: savedProtocol.otherRepresentative?.userName,
            otherFieldPhone: savedProtocol.otherRepresentative?.userPhone,
            otherFieldPosition: savedProtocol.otherRepresentative?.userPosition,
          ));

          // Установим новый индекс для правильного сохранения объектов
          store.dispatch(ReviseObject(index: savedProtocol.objects.isNotEmpty ? savedProtocol.objects.length - 1 : 0, savedObjects: savedProtocol.objects));
          store.dispatch(UpdateProtocolWorkCategory(categoryId: savedProtocol.workCategory));
          store.dispatch(PrepareForRevision(finished: true));
        }
      } on AuthorizationException {
        store.dispatch(GeneralProtocolDataError(needAuth: true, isError: true, errorMessage: ''));
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(ProtocolTerritoryError(errorMessage: errorMessage));
        store.dispatch(GeneralProtocolDataError(
          needAuth: false,
          isError: true,
          errorMessage: errorMessage,
        ));
      }
    };
