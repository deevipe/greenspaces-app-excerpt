// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organisation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganisationAdapter extends TypeAdapter<Organisation> {
  @override
  final int typeId = 8;

  @override
  Organisation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Organisation(
      id: fields[0] as int,
      name: fields[1] as String,
      members: (fields[2] as List).cast<OrganisationUser>(),
      type: fields[3] as OrganizationType,
    );
  }

  @override
  void write(BinaryWriter writer, Organisation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.members)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganisationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrganizationTypeAdapter extends TypeAdapter<OrganizationType> {
  @override
  final int typeId = 9;

  @override
  OrganizationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrganizationType.committee;
      case 1:
        return OrganizationType.spp;
      case 2:
        return OrganizationType.other;
      default:
        return OrganizationType.committee;
    }
  }

  @override
  void write(BinaryWriter writer, OrganizationType obj) {
    switch (obj) {
      case OrganizationType.committee:
        writer.writeByte(0);
        break;
      case OrganizationType.spp:
        writer.writeByte(1);
        break;
      case OrganizationType.other:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
