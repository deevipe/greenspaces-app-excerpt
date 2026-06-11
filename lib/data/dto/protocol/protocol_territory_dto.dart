class ProtocolTerritoryDTO {
  final int id;
  final String? title;
  final String layerUrl;
  final String layerId;
  final String type;

  ProtocolTerritoryDTO({
    required this.id,
    this.title,
    required this.layerUrl,
    required this.layerId,
    required this.type,
  });

  factory ProtocolTerritoryDTO.fromJson(Map<String, dynamic> json) => ProtocolTerritoryDTO(
        id: json['Id'],
        title: json['Title'],
        layerId: json['LayerId'],
        layerUrl: json['LayerUrl'],
        type: json['Type'],
      );
}
