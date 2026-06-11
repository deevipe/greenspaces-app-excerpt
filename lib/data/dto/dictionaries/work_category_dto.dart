class WorkCategoryDTO {
  final int id;
  final String title;

  const WorkCategoryDTO({required this.id, required this.title});

  factory WorkCategoryDTO.fromJson(Map<String, dynamic> json) => WorkCategoryDTO(id: json['Id'], title: json['Title']);
}
