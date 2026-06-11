import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation_user.dart';
import 'package:hive/hive.dart';

part 'organisation.g.dart';

@HiveType(typeId: 8)
class Organisation {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<OrganisationUser> members;
  @HiveField(3)
  final OrganizationType type;

  const Organisation({
    required this.id,
    required this.name,
    required this.members,
    required this.type,
  });

  factory Organisation.fromJson(Map<String, dynamic> json) => Organisation(
      id: json['id'],
      name: json['name'],
      members: json['members'].map((el) => OrganisationUser.fromJson(el)).toList().cast<OrganisationUser>(),
      type: getOrgTypeFromString(id: json['type']));

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'members': members.map((el) => el.toJson()).toList(), 'type': '${type.getTypeId}'};
}

OrganizationType getOrgTypeFromString({required String id}) {
  switch (id) {
    case '1':
      return OrganizationType.committee;
    case '2':
      return OrganizationType.spp;
    default:
      return OrganizationType.other;
  }
}

@HiveType(typeId: 9)
enum OrganizationType {
  @HiveField(0)
  committee,
  @HiveField(1)
  spp,
  @HiveField(2)
  other,
}

extension SelectedOrgType on OrganizationType {
  String get name => describeEnum(this);

  int get getTypeId {
    switch (this) {
      case OrganizationType.committee:
        return 1;
      case OrganizationType.spp:
        return 2;
      default:
        return 1;
    }
  }
}
