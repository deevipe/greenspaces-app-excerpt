class AreaTypeDTO {
  final int id;
  final String title;
  final String url;

  const AreaTypeDTO({
    required this.id,
    required this.title,
    required this.url,
  });

  factory AreaTypeDTO.fromJson(Map<String, dynamic> json) => AreaTypeDTO(
        id: json['Id'],
        title: json['Title'],
        url: json['Url'],
      );
}
