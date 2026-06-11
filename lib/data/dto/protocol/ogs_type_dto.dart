class OgsTypeDTO {
  final String title;
  final int elementTypeId;

  const OgsTypeDTO({
    required this.title,
    required this.elementTypeId,
  });

  factory OgsTypeDTO.fromJson(Map<String, dynamic> json) => OgsTypeDTO(
        title: json['Title'],
        elementTypeId: json['ElementTypeId'],
      );
}
