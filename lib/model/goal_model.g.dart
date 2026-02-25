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
      alarmId: fields[4] as int?,
      scheduledAt: fields[5] as DateTime?,
      repeatType: fields[6] as String?,
      weekdays: (fields[7] as List?)?.cast<int>(),
      dayOfMonth: fields[8] as int?,
      hour: fields[9] as int?,
      minute: fields[10] as int?,
      motivationStyle: fields[11] as String?,
      format: fields[12] as String?,
      faithToggle: fields[13] as bool?,
      active: fields[14] as bool?,
      currentStreak: fields[15] as int?,
      bestStreak: fields[16] as int?,
      lastCompletedDateKey: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GoalModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.pillar)
      ..writeByte(4)
      ..write(obj.alarmId)
      ..writeByte(5)
      ..write(obj.scheduledAt)
      ..writeByte(6)
      ..write(obj.repeatType)
      ..writeByte(7)
      ..write(obj.weekdays)
      ..writeByte(8)
      ..write(obj.dayOfMonth)
      ..writeByte(9)
      ..write(obj.hour)
      ..writeByte(10)
      ..write(obj.minute)
      ..writeByte(11)
      ..write(obj.motivationStyle)
      ..writeByte(12)
      ..write(obj.format)
      ..writeByte(13)
      ..write(obj.faithToggle)
      ..writeByte(14)
      ..write(obj.active)
      ..writeByte(15)
      ..write(obj.currentStreak)
      ..writeByte(16)
      ..write(obj.bestStreak)
      ..writeByte(17)
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
