import 'package:gisogs_greenspacesapp/data/dto/protocol/protocol_list_item_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/protocol_list_item_entity.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';

class ProtocolListItemMapper {
  static ProtocolListItem mapDTO(ProtocolListItemDTO data) {
    final DateTime? convertedDate = data.date != null ? DateTime.parse(data.date!).add(const Duration(hours: 3)) : null;

    final String stringDate = HelperUtils.convertDateToString(convertedDate);

    return ProtocolListItem(
      id: data.id,
      address: data.address,
      date: convertedDate,
      dateString: stringDate,
    );
  }
}
