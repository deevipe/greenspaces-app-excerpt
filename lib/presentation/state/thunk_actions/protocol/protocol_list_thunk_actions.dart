import 'dart:async';

import 'package:dio/dio.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/dio_settings.dart';
import 'package:gisogs_greenspacesapp/config/exceptions.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_data.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_item_entity.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/use_case_module.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_list_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_list_view_model.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> getProtocolList({Completer? completer, required bool revision, required int page, bool? loadingMore}) => (Store<AppState> store) async {
      store.dispatch(FetchingProtocolList(refresh: completer != null, loadingMore: loadingMore));
      try {
        final ProtocolListData protocolData = await UseCaseModule.protocol().listProtocols(revision: revision, page: page);
        if (protocolData.list.isEmpty) {
          store.dispatch(ProtocolListError(errorMessage: GeneralErrors.emptyProtocolDraft));
        } else {
          List<ProtocolListItem> newList = List.from(store.state.protocolListState.list);

          if (loadingMore == true) {
            newList.addAll(protocolData.list);
          } else {
            newList = protocolData.list;
          }

          store.dispatch(FetchProtocolListSuccess(list: newList, page: protocolData.page, maxPage: protocolData.maxPage));
        }
      } on ParseException catch (e) {
        store.dispatch(ProtocolListError(errorMessage: e.toString()));
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(ProtocolListError(errorMessage: errorMessage));
      } finally {
        completer?.complete();
      }
    };

ThunkAction<AppState> removeProtocol({required int id}) => (Store<AppState> store) async {
      store.dispatch(DeletingProtocol(protocolId: id));
      try {
        final ProtocolListViewModel state = store.state.protocolListState;
        final bool delRes = await UseCaseModule.protocol().deleteProtocolById(protocolId: id);

        if (delRes) {
          // попробуем не запрашивать новый список, а просто удалить элемент из текущего
          List<ProtocolListItem> currentList = List<ProtocolListItem>.from(state.list);
          currentList.removeWhere((element) => element.id == id);

          store.dispatch(FetchProtocolListSuccess(list: currentList, page: state.page, maxPage: state.maxPage ?? 1));
        }
      } catch (e) {
        String errorMessage = GeneralErrors.generalError;
        if (e is DioError) {
          errorMessage = DioExceptions.fromDioError(e).toString();
        } else if (e is CustomException) {
          errorMessage = e.toString();
        }
        store.dispatch(ProtocolListError(errorMessage: errorMessage));
      }
      // store.dispatch(getProtocolList(completer: null, revision: false));
    };
