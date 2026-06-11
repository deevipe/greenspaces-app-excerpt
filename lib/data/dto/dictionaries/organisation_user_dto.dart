class OrganisationUserDTO {
  final int id;
  final String name;
  final String? position;
  final String? phone;
  final int orgId;
  final String orgName;

  const OrganisationUserDTO({required this.id, required this.orgId, required this.orgName, required this.name, this.position, this.phone});

  factory OrganisationUserDTO.fromJson(Map<String, dynamic> json) => OrganisationUserDTO(
        id: json['Id'],
        orgId: json['OrganizationId'],
        orgName: json['OrgName'],
        name: json['Name'] ?? '',
        position: json['Position'],
        phone: json['Phone'],
      );
}
