class MunicipalityDTO {
  final int id;
  final String title;
  final int districtId;
  final String oktmo;

  MunicipalityDTO({
    required this.id,
    required this.title,
    required this.districtId,
    required this.oktmo,
  });

  factory MunicipalityDTO.fromJson(Map<String, dynamic> json) => MunicipalityDTO(
        id: json['Id'],
        title: json['Title'],
        districtId: json['DistrictId'],
        oktmo: json['Oktmo'] ?? '',
      );
}
