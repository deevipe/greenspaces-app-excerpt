import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_item_entity.dart';

class ProtocolListData {
  final int page;
  final int maxPage;
  final List<ProtocolListItem> list;

  ProtocolListData({required this.page, required this.list, required this.maxPage});
}
