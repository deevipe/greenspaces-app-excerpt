import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/dio_settings.dart';
import 'package:gisogs_greenspacesapp/config/exceptions.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/representative.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/use_case_module.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_representatives_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_representatives_view_model.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> addRepresentativeBlock({required OrganizationType orgType}) => (Store<AppState> store) {
      final ProtocolRepresentativesViewModel state = store.state.protocolRepresentativesState;
      final List<Representative> modifiedList =
          orgType == OrganizationType.committee ? List.from(state.committeeRepresentatives) : List.from(state.sppRepresentatives);

      modifiedList.add(Representative.generateDefault(type: orgType));

      store.dispatch(UpdateRepresentativesBlock(type: orgType, newList: modifiedList));
    };

ThunkAction<AppState> removeRepresentativeBlock({required OrganizationType orgType, required int index, required UniqueKey widgetKey}) =>
    (Store<AppState> store) {
      final ProtocolRepresentativesViewModel state = store.state.protocolRepresentativesState;
      final List<Representative> modifiedList =
          orgType == OrganizationType.committee ? List.from(state.committeeRepresentatives) : List.from(state.sppRepresentatives);

      modifiedList.removeAt(index);

      store.dispatch(UpdateRepresentativesBlock(type: orgType, newList: modifiedList, widgetKey: widgetKey));
    };

ThunkAction<AppState> getRepresentativeSelects(Completer? completer) => (Store<AppState> store) {
      store.dispatch(FetchingProtocolFourthStep(refresh: completer != null));
      try {
        final Map<OrganizationType, List<Organisation>> typedOrgs = UseCaseModule.local().getOrgsByType();

        store.dispatch(FetchProtocolFourthStepSuccess(
          committeeList: typedOrgs[OrganizationType.committee] ?? [],
          sppList: typedOrgs[OrganizationType.spp] ?? [],
          usersForSelects: {},
        ));
      } on ParseException catch (e) {
        store.dispatch(ProtocolFourthStepError(errorMessage: e.toString()));
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(ProtocolFourthStepError(errorMessage: errorMessage));
      } finally {
        completer?.complete();
      }
    };

ThunkAction<AppState> getCommitteeUsers({required String committeeId, required UniqueKey widgetKey, bool? spp}) => (Store<AppState> store) {
      final ProtocolRepresentativesViewModel state = store.state.protocolRepresentativesState;
      store.dispatch(FetchingCommitteeDependencies(spp: spp ?? false, widgetKey: widgetKey));
      try {
        final List<OrganisationUser> usersList = UseCaseModule.local()
            .getCommiteeUsersSelect(orgId: int.parse(committeeId.split('_').first), orgs: spp == true ? state.sppList : state.committeeList);

        Map<UniqueKey, List<OrganisationUser>> modifiedData = Map.from(state.usersForSelects);
        modifiedData[widgetKey] = usersList;

        store.dispatch(FetchProtocolFourthStepSuccess(
          committeeList: state.committeeList,
          sppList: state.sppList,
          usersForSelects: modifiedData,
        ));
      } on ParseException catch (e) {
        store.dispatch(ProtocolFourthStepError(errorMessage: e.toString()));
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(ProtocolFourthStepError(errorMessage: errorMessage));
      }
    };
