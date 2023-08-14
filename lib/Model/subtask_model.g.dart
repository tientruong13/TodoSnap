// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubTaskModelAdapter extends TypeAdapter<SubTaskModel> {
  @override
  final int typeId = 2;

  @override
  SubTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubTaskModel(
      id: fields[0] as String?,
      title: fields[1] as String,
      detail: fields[2] as String,
      isCompleted: fields[3] as bool,
      parent: fields[4] as String,
      date: fields[5] as DateTime,
      subTaskIndex: fields[6] as int?,
      isNotificationActive: fields[13] as bool?,
      notificationType: fields[12] as NotificationType?,
      eventTime: fields[7] as TimeOfDay?,
      eventDate: fields[8] as DateTime?,
      notificationId: fields[9] as int?,
      imagePath: fields[10] as String?,
      imagePaths: (fields[11] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubTaskModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.detail)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.parent)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.subTaskIndex)
      ..writeByte(7)
      ..write(obj.eventTime)
      ..writeByte(8)
      ..write(obj.eventDate)
      ..writeByte(9)
      ..write(obj.notificationId)
      ..writeByte(10)
      ..write(obj.imagePath)
      ..writeByte(11)
      ..write(obj.imagePaths)
      ..writeByte(12)
      ..write(obj.notificationType)
      ..writeByte(13)
      ..write(obj.isNotificationActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
