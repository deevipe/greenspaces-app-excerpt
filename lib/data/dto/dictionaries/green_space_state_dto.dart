class GreenSpaceStateDTO {
  final int id;
  final String title;
  final bool? isDefault;
  final List<int>? workCatIds;
  final List<int> elementTypeIds;

  const GreenSpaceStateDTO({
    required this.id,
    required this.title,
    this.isDefault,
    this.workCatIds,
    required this.elementTypeIds,
  });

  factory GreenSpaceStateDTO.fromJson(Map<String, dynamic> json) => GreenSpaceStateDTO(
        id: json['Id'],
        title: json['Title'],
        isDefault: json['Data']['isDefault'],
        workCatIds: (json['Data']['workCatIds'] != null && json['Data']['workCatIds'].isNotEmpty) ? json['Data']['workCatIds'].cast<int>() : null,
        elementTypeIds: json['Data']['elementTypeIds'].cast<int>(),
      );
}
