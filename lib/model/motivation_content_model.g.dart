// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motivation_content_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MotivationContentModelAdapter
    extends TypeAdapter<MotivationContentModel> {
  @override
  final int typeId = 3;

  @override
  MotivationContentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MotivationContentModel(
      id: fields[0] as String,
      pillar: fields[1] as String,
      style: fields[2] as String,
      faithOnly: fields[3] as bool,
      text: fields[4] as String?,
      audioUrl: fields[5] as String?,
      active: fields[6] as bool,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MotivationContentModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pillar)
      ..writeByte(2)
      ..write(obj.style)
      ..writeByte(3)
      ..write(obj.faithOnly)
      ..writeByte(4)
      ..write(obj.text)
      ..writeByte(5)
      ..write(obj.audioUrl)
      ..writeByte(6)
      ..write(obj.active)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotivationContentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
