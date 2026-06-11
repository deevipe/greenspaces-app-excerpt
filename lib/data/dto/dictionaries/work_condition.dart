class WorkConditionDTO {
  final int id;
  final String title;

  const WorkConditionDTO({required this.id, required this.title});

  factory WorkConditionDTO.fromJson(Map<String, dynamic> json) => WorkConditionDTO(id: json['Id'], title: json['Title']);
}
