import 'task.dart';

class TaskDetails {
  const TaskDetails({
    required this.title,
    this.targetDate,
    this.isStarred = false,
    this.isDone = false,
  });

  final String title;
  final DateTime? targetDate;
  final bool isStarred;
  final bool isDone;

  factory TaskDetails.fromTask(Task task) => TaskDetails(
        title: task.title,
        targetDate: task.targetDate,
        isStarred: task.isStarred,
        isDone: task.isDone,
      );
}

