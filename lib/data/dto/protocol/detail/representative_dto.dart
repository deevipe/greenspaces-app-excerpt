class RepresentativeDTO {
  final int id;
  final int? userId;
  final int typeId;
  final String typeName;
  final String? userName;
  final String? userPosition;
  final String? userPhone;
  final int orgId;
  final int? representativeId;
  final String orgName;

  const RepresentativeDTO({
    required this.id,
    this.userId,
    required this.typeId,
    required this.typeName,
    this.userName,
    this.userPosition,
    this.userPhone,
    required this.orgId,
    this.representativeId,
    required this.orgName,
  });

  factory RepresentativeDTO.fromJson(Map<String, dynamic> json) => RepresentativeDTO(
        id: json['Id'],
        userId: json['RepresentativeMemberId'],
        typeId: json['RepresentativeTypeId'],
        typeName: json['TypeName'],
        userName: json['Name'],
        userPhone: json['Phone'],
        userPosition: json['Position'],
        orgId: json['OrganizationId'],
        representativeId: json['RepresentativeId'],
        orgName: json['OrgName'].isNotEmpty ? json['OrgName'].replaceAll(r'\', '') : '',
      );
}
