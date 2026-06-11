import 'package:gisogs_greenspacesapp/presentation/state/actions/protocol/protocol_list_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/protocol/protocol_list_view_model.dart';
import 'package:redux/redux.dart';

final protocolListReducer = combineReducers<ProtocolListViewModel>([
  TypedReducer<ProtocolListViewModel, FetchingProtocolList>(_process),
  TypedReducer<ProtocolListViewModel, FetchProtocolListSuccess>(_success),
  TypedReducer<ProtocolListViewModel, SetRevisionProcess>(_revision),
  TypedReducer<ProtocolListViewModel, ProtocolListError>(_errorHandler),
  TypedReducer<ProtocolListViewModel, DeletingProtocol>(_deleteHandler),
]);

ProtocolListViewModel _process(ProtocolListViewModel state, FetchingProtocolList action) {
  return state.copyWith(
    isLoading: (!action.refresh && !(action.loadingMore ?? false)),
    loadingMore: action.loadingMore,
    isError: false,
    errorMessage: '',
  );
}

ProtocolListViewModel _success(ProtocolListViewModel state, FetchProtocolListSuccess action) {
  return state.copyWith(
    list: action.list,
    page: action.page,
    maxPage: action.maxPage,
    loadingMore: false,
    isLoading: false,
    isError: false,
    errorMessage: '',
  );
}

ProtocolListViewModel _revision(ProtocolListViewModel state, SetRevisionProcess action) {
  return state.copyWith(
    list: state.list,
    isLoading: false,
    loadingMore: false,
    isError: false,
    errorMessage: '',
    revision: action.value,
  );
}

ProtocolListViewModel _errorHandler(ProtocolListViewModel state, ProtocolListError action) {
  return state.copyWith(
    list: state.list,
    isLoading: false,
    loadingMore: false,
    isError: true,
    errorMessage: action.errorMessage,
  );
}

ProtocolListViewModel _deleteHandler(ProtocolListViewModel state, DeletingProtocol action) {
  return state.copyWith(
    idToDelete: action.protocolId
  );
}
