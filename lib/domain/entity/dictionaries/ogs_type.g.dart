// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ogs_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OgsTypeAdapter extends TypeAdapter<OgsType> {
  @override
  final int typeId = 5;

  @override
  OgsType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OgsType(
      id: fields[0] as int,
      title: fields[1] as String,
      elementTypeId: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OgsType obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.elementTypeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OgsTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
