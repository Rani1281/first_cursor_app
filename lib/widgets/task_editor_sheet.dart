import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_details.dart';

class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({super.key, this.initial});

  final TaskDetails? initial;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  late final TextEditingController _controller;
  DateTime? _targetDate;
  bool _isStarred = false;
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _controller = TextEditingController(text: initial?.title ?? '');
    _controller.addListener(_onTitleChanged);
    _targetDate = initial?.targetDate;
    _isStarred = initial?.isStarred ?? false;
    _isDone = initial?.isDone ?? false;
  }

  void _onTitleChanged() {
    setState(() {});
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (!mounted || selected == null) return;
    setState(() => _targetDate = selected);
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    Navigator.of(context).pop(
      TaskDetails(
        title: title,
        targetDate: _targetDate,
        isStarred: _isStarred,
        isDone: _isDone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.initial == null
                                    ? 'New task'
                                    : 'Edit task',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Capture what matters and we’ll keep it neat.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _controller,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        decoration: const InputDecoration(
                          labelText: 'Task title',
                          hintText: 'e.g. Finish motion design exploration',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: _pickDate,
                              icon: const Icon(Icons.calendar_today_rounded),
                              label: Text(
                                _targetDate == null
                                    ? 'Target date'
                                    : DateFormat.yMMMd().format(_targetDate!),
                              ),
                            ),
                          ),
                          if (_targetDate != null) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: 'Clear date',
                              onPressed: () =>
                                  setState(() => _targetDate = null),
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Mark as important'),
                        value: _isStarred,
                        onChanged: (value) =>
                            setState(() => _isStarred = value),
                        secondary: Icon(
                          _isStarred
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                        ),
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Task is done'),
                        value: _isDone,
                        onChanged: (value) =>
                            setState(() => _isDone = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _controller.text.trim().isEmpty
                              ? null
                              : _submit,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Save task'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTitleChanged);
    _controller.dispose();
    super.dispose();
  }
}
