import 'package:hive/hive.dart';

/// Represents a task with all its properties.
class Task extends HiveObject {
  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.targetDate,
    this.isStarred = false,
    this.isDone = false,
  });

  final int id;
  final String title;
  final DateTime createdAt;
  final DateTime? targetDate;
  final bool isStarred;
  final bool isDone;

  Task copyWith({
    String? title,
    DateTime? targetDate,
    bool? isStarred,
    bool? isDone,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      targetDate: targetDate ?? this.targetDate,
      isStarred: isStarred ?? this.isStarred,
      isDone: isDone ?? this.isDone,
    );
  }
}

