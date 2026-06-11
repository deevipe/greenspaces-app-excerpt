class ProtocolListItemDTO {
  final int id;
  final String address;
  final String? date;

  ProtocolListItemDTO({
    required this.id,
    required this.address,
    this.date,
  });

  factory ProtocolListItemDTO.fromJson(Map<String, dynamic> json) => ProtocolListItemDTO(
        id: json['id'],
        address: json['district'],
        date: json['inspection_date'],
      );
}
