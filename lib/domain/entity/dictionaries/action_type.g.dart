// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActionTypeAdapter extends TypeAdapter<ActionType> {
  @override
  final int typeId = 2;

  @override
  ActionType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActionType(
      id: fields[0] as int,
      title: fields[2] as String,
      elementTypeId: fields[1] as int,
      parentIds: (fields[3] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ActionType obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.elementTypeId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.parentIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
