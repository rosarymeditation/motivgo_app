// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalModelAdapter extends TypeAdapter<GoalModel> {
  @override
  final int typeId = 1;

  @override
  GoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalModel(
      id: fields[0] as String?,
      userId: fields[1] as String?,
      title: fields[2] as String?,
      pillar: fields[3] as String?,
      reminderTime: fields[4] as String?,
      frequency: fields[5] as String?,
      customDays: (fields[6] as List?)?.cast<int>(),
      startDate: fields[7] as DateTime?,
      endDate: fields[8] as DateTime?,
      motivationStyle: fields[9] as String?,
      format: fields[10] as String?,
      faithToggle: fields[11] as bool?,
      active: fields[12] as bool?,
      currentStreak: fields[13] as int?,
      bestStreak: fields[14] as int?,
      lastCompletedDateKey: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GoalModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.pillar)
      ..writeByte(4)
      ..write(obj.reminderTime)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.customDays)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.endDate)
      ..writeByte(9)
      ..write(obj.motivationStyle)
      ..writeByte(10)
      ..write(obj.format)
      ..writeByte(11)
      ..write(obj.faithToggle)
      ..writeByte(12)
      ..write(obj.active)
      ..writeByte(13)
      ..write(obj.currentStreak)
      ..writeByte(14)
      ..write(obj.bestStreak)
      ..writeByte(15)
      ..write(obj.lastCompletedDateKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
