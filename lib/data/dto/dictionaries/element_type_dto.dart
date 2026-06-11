class ElementTypeDTO {
  final int id;
  final String title;
  final List<int> workCatIds;

  const ElementTypeDTO({required this.id, required this.title, required this.workCatIds});

  factory ElementTypeDTO.fromJson(Map<String, dynamic> json) => ElementTypeDTO(
        id: json['Id'],
        title: json['Title'],
        workCatIds: json['WorkCatIds'].cast<int>(),
      );
}
