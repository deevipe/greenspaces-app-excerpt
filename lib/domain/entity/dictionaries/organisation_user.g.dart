// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organisation_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganisationUserAdapter extends TypeAdapter<OrganisationUser> {
  @override
  final int typeId = 7;

  @override
  OrganisationUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganisationUser(
      id: fields[0] as int,
      orgId: fields[4] as int,
      orgName: fields[5] as String,
      fio: fields[3] as String?,
      position: fields[1] as String?,
      tel: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrganisationUser obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.tel)
      ..writeByte(3)
      ..write(obj.fio)
      ..writeByte(4)
      ..write(obj.orgId)
      ..writeByte(5)
      ..write(obj.orgName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganisationUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
