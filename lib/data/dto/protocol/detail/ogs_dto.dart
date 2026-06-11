class OgsDTO {
  final int? id;
  final String? name;

  const OgsDTO({this.id, this.name});

  factory OgsDTO.fromJson(Map<String, dynamic> json) => OgsDTO(
    id: json['id'],
    name: json['name'],
  );
}
