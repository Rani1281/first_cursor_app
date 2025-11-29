import 'package:hive/hive.dart';
import 'task.dart';

/// Hive TypeAdapter for Task model to enable serialization.
class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as int,
      title: fields[1] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[2] as int),
      targetDate: fields[3] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[3] as int)
          : null,
      isStarred: fields[4] as bool? ?? false,
      isDone: fields[5] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(3)
      ..write(obj.targetDate?.millisecondsSinceEpoch)
      ..writeByte(4)
      ..write(obj.isStarred)
      ..writeByte(5)
      ..write(obj.isDone);
  }
}

