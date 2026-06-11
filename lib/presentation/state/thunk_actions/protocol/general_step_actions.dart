import 'package:dio/dio.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/dio_settings.dart';
import 'package:gisogs_greenspacesapp/config/exceptions.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/municipality_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/use_case_module.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_general_data_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_representatives_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> getGeneralStepDictionaries() => (Store<AppState> store) async {
      store.dispatch(ProcessingDictionaries(processing: true, districts: [], municipalities: []));
      // List<Municipality> municipalities = [];
      List<SelectObject> districts = [];
      try {
        // municipalities = UseCaseModule.local().getLocalMunicipalities();
        districts = UseCaseModule.local().getLocalDistricts();

        store.dispatch(ProcessingDictionaries(processing: false, districts: districts, municipalities: []));
      } on AuthorizationException {
        store.dispatch(GeneralProtocolDataError(needAuth: true, isError: true, errorMessage: ''));
      } catch (e) {
        String errorMessage = GeneralErrors.errorWhileRetrievingInfo;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(GeneralProtocolDataError(errorMessage: errorMessage, isError: true, needAuth: false));
      }
    };

ThunkAction<AppState> getMunicipalities({required int districtId}) => (Store<AppState> store) async {
      store.dispatch(RefreshMunicipalitiesList(fetching: true, list: []));
      List<Municipality> municipalities = [];

      try {
        municipalities = UseCaseModule.local().getLocalMunicipalities(districtId: districtId);
        store.dispatch(RefreshMunicipalitiesList(fetching: true, list: municipalities));
      } catch (e) {
        store.dispatch(GeneralProtocolDataError(errorMessage: GeneralErrors.errorWhileRetrievingInfo, isError: true, needAuth: false));
      }
    };

ThunkAction<AppState> searchOrgs({required String query, bool? generalStep}) => (Store<AppState> store) async {
      (generalStep != null && generalStep) ? store.dispatch(SearchOrgs()) : store.dispatch(SearchOtherOrgs());
      List<Organisation> availableList = [];
      try {
        availableList = await UseCaseModule.protocol().searchOrgs(query: query);
        (generalStep != null && generalStep)
            ? store.dispatch(SearchOrgsSuccess(list: availableList))
            : store.dispatch(SearchOtherOrgsSuccess(list: availableList));
      } catch (e) {
        String errorMessage = GeneralErrors.errorWhileRetrievingInfo;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        (generalStep != null && generalStep)
            ? store.dispatch(SearchOrgsError(errorMessage: errorMessage))
            : store.dispatch(SearchOtherOrgsError(errorMessage: errorMessage));
      }
    };
