import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/organisation.dart';

class Representative {
  final int? id;
  final int? userId;
  final int typeId;
  final OrganizationType? type;
  final String? typeName;
  final String? userName;
  final String? userPosition;
  final String? userPhone;
  // Идентификатор непосредственно организации
  final int? orgId;
  // Id определяющий идентификатор представителя в модели ответа АПИ
  final int? representativeId;
  final String? orgName;

  const Representative({
    this.id,
    this.userId,
    required this.typeId,
    this.type,
    this.typeName,
    this.userName,
    this.userPosition,
    this.userPhone,
    this.orgId,
    this.representativeId,
    this.orgName,
  });

  factory Representative.generateDefault({required OrganizationType type}) => Representative(
        type: type,
        typeId: type.getTypeId,
        orgId: null,
        representativeId: null,
        orgName: null,
        userId: null,
        userName: null,
        userPhone: null,
        userPosition: null,
      );

  Representative copyWith({
    int? id,
    int? userId,
    String? userName,
    String? userPosition,
    String? userPhone,
    int? orgId,
    int? representativeId,
    String? orgName,
  }) =>
      Representative(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userPhone: userPhone ?? this.userPhone,
        userPosition: userPosition ?? this.userPosition,
        type: type,
        typeId: typeId,
        typeName: typeName,
        orgId: orgId ?? this.orgId,
        representativeId: representativeId ?? this.representativeId,
        orgName: orgName ?? this.orgName,
      );
}
