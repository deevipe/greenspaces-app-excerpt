// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'green_space_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GreenSpaceStateAdapter extends TypeAdapter<GreenSpaceState> {
  @override
  final int typeId = 4;

  @override
  GreenSpaceState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GreenSpaceState(
      id: fields[0] as int,
      title: fields[1] as String,
      isDefault: fields[2] as bool?,
      workCatIds: (fields[3] as List?)?.cast<int>(),
      elementTypeIds: (fields[4] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, GreenSpaceState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isDefault)
      ..writeByte(3)
      ..write(obj.workCatIds)
      ..writeByte(4)
      ..write(obj.elementTypeIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GreenSpaceStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
