// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_occurrence_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalOccurrenceModelAdapter extends TypeAdapter<GoalOccurrenceModel> {
  @override
  final int typeId = 2;

  @override
  GoalOccurrenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalOccurrenceModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      goalId: fields[2] as String,
      dateKey: fields[3] as String,
      scheduledAt: fields[4] as DateTime,
      status: fields[5] as String,
      checkedInAt: fields[6] as DateTime?,
      pillar: fields[7] as String,
      motivationStyle: fields[8] as String,
      format: fields[9] as String,
      faithToggle: fields[10] as bool,
      messageText: fields[11] as String?,
      audioUrl: fields[12] as String?,
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GoalOccurrenceModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.goalId)
      ..writeByte(3)
      ..write(obj.dateKey)
      ..writeByte(4)
      ..write(obj.scheduledAt)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.checkedInAt)
      ..writeByte(7)
      ..write(obj.pillar)
      ..writeByte(8)
      ..write(obj.motivationStyle)
      ..writeByte(9)
      ..write(obj.format)
      ..writeByte(10)
      ..write(obj.faithToggle)
      ..writeByte(11)
      ..write(obj.messageText)
      ..writeByte(12)
      ..write(obj.audioUrl)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalOccurrenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
