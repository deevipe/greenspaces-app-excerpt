import 'package:gisogs_greenspacesapp/data/dto/protocol/protocol_list_data_dto.dart';
import 'package:gisogs_greenspacesapp/data/mapper/protocol/protocol_list_item_mapper.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_data.dart';

class ProtocolListDataMapper {
  static ProtocolListData mapDTO(ProtocolListDataDTO data) => ProtocolListData(
        page: data.page,
        list: data.list.isNotEmpty ? data.list.map((item) => ProtocolListItemMapper.mapDTO(item)).toList() : [],
        maxPage: data.maxPage,
      );
}
