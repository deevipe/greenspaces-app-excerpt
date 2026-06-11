class CommitteeUserDTO {
  final int id;
  final String fio;
  final String? position;
  final String? tel;

  CommitteeUserDTO({
    required this.id,
    required this.fio,
    this.position,
    this.tel,
  });

  factory CommitteeUserDTO.fromJson(Map<String, dynamic> json) => CommitteeUserDTO(
        id: json['Id'],
        fio: json['Fio'],
        position: json['Position'],
        tel: json['Tel'],
      );
}
