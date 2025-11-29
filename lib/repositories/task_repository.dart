import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/task_adapter.dart';

/// Repository for managing task persistence using Hive local storage.
class TaskRepository {
  static const String _boxName = 'tasks';
  Box<Task>? _box;

  /// Initializes the Hive box for tasks.
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
    _box = await Hive.openBox<Task>(_boxName);
  }

  /// Retrieves all tasks from local storage.
  List<Task> getAllTasks() {
    if (_box == null) return [];
    return _box!.values.toList();
  }

  /// Saves a new task to local storage.
  Future<void> createTask(Task task) async {
    if (_box == null) return;
    await _box!.put(task.id, task);
  }

  /// Updates an existing task in local storage.
  Future<void> updateTask(Task task) async {
    if (_box == null) return;
    await _box!.put(task.id, task);
  }

  /// Deletes a task from local storage.
  Future<void> deleteTask(int taskId) async {
    if (_box == null) return;
    await _box!.delete(taskId);
  }

  /// Gets the next available ID for a new task.
  int getNextId() {
    if (_box == null || _box!.isEmpty) return 0;
    final maxId = _box!.values.map((task) => task.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  /// Closes the Hive box.
  Future<void> close() async {
    await _box?.close();
  }
}

