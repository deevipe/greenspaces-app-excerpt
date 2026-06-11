import 'package:hive/hive.dart';

part 'organisation_user.g.dart';

@HiveType(typeId: 7)
class OrganisationUser {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? position;
  @HiveField(2)
  final String? tel;
  @HiveField(3)
  final String? fio;
  @HiveField(4)
  final int orgId;
    @HiveField(5)
  final String orgName;

  OrganisationUser({
    required this.id,
    required this.orgId,
    required this.orgName,
    this.fio,
    this.position,
    this.tel,
  });

  Map toJson() => {'id': id, 'position': position, 'tel': tel, 'fio': fio, 'orgId': orgId, 'orgName': orgName};

  factory OrganisationUser.fromJson(Map<String, dynamic> json) => OrganisationUser(
        id: json['id'],
        orgId: json['orgId'],
        position: json['position'],
        orgName: json['orgName'],
        tel: json['tel'],
        fio: json['fio'],
      );
}
