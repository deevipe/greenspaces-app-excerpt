class ActionTypeDTO {
  final int id;
  final int elementTypeId;
  final String title;
  final List<int> parentIds;

  const ActionTypeDTO({required this.id, required this.title, required this.elementTypeId, required this.parentIds});

  factory ActionTypeDTO.fromJson(Map<String, dynamic> json) => ActionTypeDTO(
        id: json['Id'],
        title: json['Title'],
        elementTypeId: json['ElementTypeId'],
        parentIds: json['ParentIds'].cast<int>(),
      );
}
