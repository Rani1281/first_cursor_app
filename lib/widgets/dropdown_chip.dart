import 'package:flutter/material.dart';

class DropdownChip<T> extends StatelessWidget {
  const DropdownChip({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.display,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T value) display;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.expand_more_rounded),
                borderRadius: BorderRadius.circular(16),
                items: items
                    .map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          display(item),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (selected) {
                  if (selected != null) {
                    onChanged(selected);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
