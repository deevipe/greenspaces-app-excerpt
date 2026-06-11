// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'municipality_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MunicipalityAdapter extends TypeAdapter<Municipality> {
  @override
  final int typeId = 10;

  @override
  Municipality read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Municipality(
      id: fields[0] as int,
      districtId: fields[2] as int,
      title: fields[1] as String,
      oktmo: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Municipality obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.districtId)
      ..writeByte(3)
      ..write(obj.oktmo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MunicipalityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
