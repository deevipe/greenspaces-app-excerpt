class SelectObjectDTO {
  final String id;
  final String name;
  final String? code;

  SelectObjectDTO({required this.id, required this.name, this.code});

  factory SelectObjectDTO.fromJson(Map<String, dynamic> json) => SelectObjectDTO(
        id: json['Id'].toString(),
        name: json['Title'] ?? json['Name'] ?? '',
        code: json['Code']?.toString(),
      );
}
