class GreenSpaceObjectItemDTO {
  final int id;
  final int typeId;
  final bool multiStem;
  final String? selectedKind;
  final String? selectedWorkType;
  final String? selectedWorkSubType;
  final String? selectedObjectState;
  final String? selectedDiameter;
  final String? otherStateValue;
  final String? selectedAge;
  final double? areaValue;
  final int? amountValue;
  // final String? stemAmount;
  // final List<StemDTO> stemList;

  GreenSpaceObjectItemDTO({
    required this.id,
    required this.typeId,
    required this.multiStem,
    this.selectedKind,
    this.selectedWorkType,
    this.selectedWorkSubType,
    this.selectedObjectState,
    this.selectedDiameter,
    this.otherStateValue,
    this.selectedAge,
    this.areaValue,
    this.amountValue,
    // this.stemAmount,
    // required this.stemList,
  });

  factory GreenSpaceObjectItemDTO.fromJson(Map<String, dynamic> json) => GreenSpaceObjectItemDTO(
        id: json['Id'],
        typeId: json['ElementType']['Id'],
        multiStem: json['Multitrunk'],
        selectedKind: json['OgsType']['Id'] == 0 ? null : '${json['OgsType']['Id']}_${json['OgsType']['Title']}',
        selectedWorkType: '${json['ActionType']['Id']}_${json['ActionType']['Title']}',
        selectedWorkSubType: json['WorkMethod']['Id'] == 0 ? null : '${json['WorkMethod']['Id']}_${json['WorkMethod']['Title']}',
        selectedObjectState: (json['States'] != null && json['States'].isNotEmpty)
            ? json['States'].first['Id'] == 0
                ? null
                : '${json['States'].first['Id']}_${json['States'].first['Title']}'
            : null,
        selectedDiameter: json['Diameter']['Id'] == 0 ? null : '${json['Diameter']['Id']}_${json['Diameter']['Title']}',
        otherStateValue: json['StateOther'],
        selectedAge: json['Age']['Id'] == 0 ? null : '${json['Age']['Id']}_${json['Age']['Title']}',
        areaValue: json['Area'],
        amountValue: json['Count'],
      );
}
