// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_occurrence_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalOccurrenceAdapter extends TypeAdapter<GoalOccurrence> {
  @override
  final int typeId = 2;

  @override
  GoalOccurrence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalOccurrence(
      goalId: fields[0] as String,
      dateKey: fields[1] as String,
      scheduledAt: fields[2] as DateTime,
      status: fields[3] as GoalOccurrenceStatus,
      checkedInAt: fields[4] as DateTime?,
      pillar: fields[5] as String?,
      motivationStyle: fields[6] as String?,
      format: fields[7] as String?,
      messageText: fields[8] as String?,
      audioUrl: fields[9] as String?,
      goalTitle: fields[12] as String?,
      createdAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, GoalOccurrence obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.goalId)
      ..writeByte(1)
      ..write(obj.dateKey)
      ..writeByte(2)
      ..write(obj.scheduledAt)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.checkedInAt)
      ..writeByte(5)
      ..write(obj.pillar)
      ..writeByte(6)
      ..write(obj.motivationStyle)
      ..writeByte(7)
      ..write(obj.format)
      ..writeByte(8)
      ..write(obj.messageText)
      ..writeByte(9)
      ..write(obj.audioUrl)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.goalTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalOccurrenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalOccurrenceStatusAdapter extends TypeAdapter<GoalOccurrenceStatus> {
  @override
  final int typeId = 5;

  @override
  GoalOccurrenceStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GoalOccurrenceStatus.pending;
      case 1:
        return GoalOccurrenceStatus.completed;
      case 2:
        return GoalOccurrenceStatus.skipped;
      default:
        return GoalOccurrenceStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, GoalOccurrenceStatus obj) {
    switch (obj) {
      case GoalOccurrenceStatus.pending:
        writer.writeByte(0);
        break;
      case GoalOccurrenceStatus.completed:
        writer.writeByte(1);
        break;
      case GoalOccurrenceStatus.skipped:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalOccurrenceStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
