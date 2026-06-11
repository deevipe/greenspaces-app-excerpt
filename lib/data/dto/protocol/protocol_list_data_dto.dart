import 'package:gisogs_greenspacesapp/data/dto/protocol/protocol_list_item_dto.dart';

class ProtocolListDataDTO {
  final int page;
  final int maxPage;
  final List<ProtocolListItemDTO> list;

  ProtocolListDataDTO({required this.page, required this.list, required this.maxPage});

  factory ProtocolListDataDTO.initial() => ProtocolListDataDTO(page: 1, list: [], maxPage: 0);

  factory ProtocolListDataDTO.fromJson(Map<String, dynamic> json) => ProtocolListDataDTO(
        page: json['Page'],
        maxPage: json['PageCount'],
        list: json['Objects'].map((el) => ProtocolListItemDTO.fromJson(el)).toList().cast<ProtocolListItemDTO>(),
      );
}
