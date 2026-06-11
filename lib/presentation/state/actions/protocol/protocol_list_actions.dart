import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_item_entity.dart';

class FetchingProtocolList {
  final bool refresh;
  final bool? loadingMore;
  FetchingProtocolList({required this.refresh, this.loadingMore});
}

class DeletingProtocol {
  final int protocolId;
  DeletingProtocol({required this.protocolId});
}

class FetchProtocolListSuccess {
  final int maxPage;
  final int page;
  final List<ProtocolListItem> list;

  FetchProtocolListSuccess({
    required this.page,
    required this.maxPage,
    required this.list,
  });
}

class SetRevisionProcess {
  final bool value;
  SetRevisionProcess({required this.value});
}

class ProtocolListError {
  final String errorMessage;

  ProtocolListError({
    required this.errorMessage,
  });
}
