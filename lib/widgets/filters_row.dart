import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/sort_mode.dart';
import '../models/group_mode.dart';
import 'dropdown_chip.dart';

class FiltersRow extends StatelessWidget {
  const FiltersRow({
    super.key,
    required this.sortMode,
    required this.groupMode,
    required this.onSortChanged,
    required this.onGroupChanged,
  });

  final SortMode sortMode;
  final GroupMode groupMode;
  final ValueChanged<SortMode> onSortChanged;
  final ValueChanged<GroupMode> onGroupChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: theme.colorScheme.surface.withValues(alpha: 0.82),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customize your list',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 14,
                  runSpacing: 12,
                  children: [
                    DropdownChip<SortMode>(
                      label: 'Sort',
                      value: sortMode,
                      items: SortMode.values,
                      display: (mode) => mode.label,
                      onChanged: onSortChanged,
                    ),
                    DropdownChip<GroupMode>(
                      label: 'Group',
                      value: groupMode,
                      items: GroupMode.values,
                      display: (mode) => mode.label,
                      onChanged: onGroupChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
