import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/task_details.dart';
import '../models/task_section.dart';
import '../models/sort_mode.dart';
import '../models/group_mode.dart';
import '../widgets/empty_state.dart';
import '../widgets/filters_row.dart';
import '../widgets/task_editor_sheet.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Task> _tasks = [];
  int _nextId = 0;
  SortMode _sortMode = SortMode.targetDate;
  GroupMode _groupMode = GroupMode.none;

  void _toggleDone(Task task, bool? value) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index == -1) return;
      _tasks[index] = _tasks[index].copyWith(isDone: value ?? false);
    });
  }

  void _toggleStar(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index == -1) return;
      _tasks[index] = _tasks[index].copyWith(isStarred: !task.isStarred);
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
  }

  Future<void> _openEditor({Task? task}) async {
    final details = await showModalBottomSheet<TaskDetails>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (context) => TaskEditorSheet(
        initial: task == null ? null : TaskDetails.fromTask(task),
      ),
    );

    if (details == null) return;

    setState(() {
      if (task == null) {
        _tasks.add(
          Task(
            id: _nextId++,
            title: details.title,
            targetDate: details.targetDate,
            isStarred: details.isStarred,
            isDone: details.isDone,
            createdAt: DateTime.now(),
          ),
        );
      } else {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index == -1) {
          return;
        }
        _tasks[index] = _tasks[index].copyWith(
          title: details.title,
          targetDate: details.targetDate,
          isStarred: details.isStarred,
          isDone: details.isDone,
        );
      }
    });
  }

  List<Task> _sortedTasks() {
    final sorted = [..._tasks];
    sorted.sort((a, b) {
      switch (_sortMode) {
        case SortMode.alphabetical:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case SortMode.targetDate:
          final dateA = a.targetDate;
          final dateB = b.targetDate;
          if (dateA == null && dateB == null) {
            return a.title.toLowerCase().compareTo(b.title.toLowerCase());
          }
          if (dateA == null) return 1;
          if (dateB == null) return -1;
          final compareDate = _justDate(dateA).compareTo(_justDate(dateB));
          if (compareDate != 0) return compareDate;
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case SortMode.createdNewest:
          return b.createdAt.compareTo(a.createdAt);
        case SortMode.starred:
          final starScore = (b.isStarred ? 1 : 0) - (a.isStarred ? 1 : 0);
          if (starScore != 0) return starScore;
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });
    return sorted;
  }

  List<TaskSection> _sectionsFor(List<Task> tasks) {
    if (_groupMode == GroupMode.none) {
      return [TaskSection(label: 'Tasks', tasks: tasks)];
    }

    final map = <DateTime?, List<Task>>{};
    for (final task in tasks) {
      final key = task.targetDate == null ? null : _justDate(task.targetDate!);
      map.putIfAbsent(key, () => []).add(task);
    }

    final entries = map.entries.toList()
      ..sort((a, b) {
        if (a.key == null && b.key == null) return 0;
        if (a.key == null) return 1;
        if (b.key == null) return -1;
        return a.key!.compareTo(b.key!);
      });

    return entries
        .map(
          (entry) => TaskSection(
            label: entry.key == null
                ? 'No target date'
                : DateFormat.yMMMMd().format(entry.key!),
            tasks: entry.value,
          ),
        )
        .toList();
  }

  DateTime _justDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Widget _buildMetaChips(BuildContext context, Task task) {
    final chips = <Widget>[];
    if (task.targetDate != null) {
      chips.add(
        _MetaChip(
          icon: Icons.calendar_today_rounded,
          label: DateFormat.MMMd().format(task.targetDate!),
        ),
      );
    }
    if (task.isStarred) {
      chips.add(const _MetaChip(icon: Icons.star_rounded, label: 'Important'));
    }
    if (task.isDone) {
      chips.add(
        const _MetaChip(icon: Icons.done_all_rounded, label: 'Completed'),
      );
    }
    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(spacing: 8, runSpacing: 6, children: chips);
  }

  Widget _buildTaskCard(BuildContext context, Task task, int index) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      decoration: task.isDone
          ? TextDecoration.lineThrough
          : TextDecoration.none,
      color: task.isDone
          ? theme.colorScheme.onSurface.withOpacity(0.6)
          : theme.colorScheme.onSurface,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.97, end: 1),
      duration: Duration(milliseconds: 320 + (index * 18)),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) => Transform.scale(
        scale: scale,
        alignment: Alignment.center,
        child: child,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceVariant.withOpacity(0.35),
            ],
          ),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () => _openEditor(task: task),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _toggleDone(task, !task.isDone),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: task.isDone
                            ? LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary,
                                ],
                              )
                            : null,
                        border: Border.all(
                          color: task.isDone
                              ? Colors.transparent
                              : theme.colorScheme.outlineVariant,
                          width: 2,
                        ),
                        color: task.isDone
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surface,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: task.isDone
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title, style: titleStyle),
                        const SizedBox(height: 8),
                        _buildMetaChips(context, task),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: task.isStarred
                            ? 'Unmark important'
                            : 'Mark important',
                        onPressed: () => _toggleStar(task),
                        icon: Icon(
                          task.isStarred
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                        ),
                        color: task.isStarred
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      PopupMenuButton<String>(
                        tooltip: 'More options',
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _openEditor(task: task);
                              break;
                            case 'delete':
                              _deleteTask(task);
                              break;
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Divider(thickness: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required int total,
    required int active,
    required int completed,
    required double progress,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.18),
              blurRadius: 30,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Focus',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                active == 0
                    ? 'You\'re all caught up. Enjoy your day!'
                    : 'You have $active active ${active == 1 ? 'task' : 'tasks'}.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _HeaderStat(
                    label: 'Total',
                    value: '$total',
                    accentColor: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  _HeaderStat(
                    label: 'Completed',
                    value: '$completed',
                    accentColor: theme.colorScheme.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.onPrimaryContainer
                      .withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTaskListWidgets(
    BuildContext context,
    List<TaskSection> sections,
  ) {
    final widgets = <Widget>[];
    var taskIndex = 0;
    for (final section in sections) {
      if (_groupMode != GroupMode.none) {
        widgets.add(_buildSectionHeader(context, section.label));
      }
      for (final task in section.tasks) {
        widgets.add(_buildTaskCard(context, task, taskIndex));
        taskIndex++;
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final sortedTasks = _sortedTasks();
    final sections = _sectionsFor(sortedTasks);
    final showEmptyState = sortedTasks.isEmpty;
    final completedCount = sortedTasks.where((task) => task.isDone).length;
    final activeCount = sortedTasks.length - completedCount;
    final progress = sortedTasks.isEmpty
        ? 0.0
        : completedCount / sortedTasks.length;

    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add task'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.6),
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(
                  context,
                  total: sortedTasks.length,
                  active: activeCount,
                  completed: completedCount,
                  progress: progress,
                ),
                FiltersRow(
                  sortMode: _sortMode,
                  groupMode: _groupMode,
                  onSortChanged: (mode) => setState(() => _sortMode = mode),
                  onGroupChanged: (mode) => setState(() => _groupMode = mode),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: showEmptyState
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: EmptyState(),
                          )
                        : ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
                            children: _buildTaskListWidgets(context, sections),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.18),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 0.6,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: accentColor.computeLuminance() > 0.5
                    ? Colors.black.withOpacity(0.8)
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
