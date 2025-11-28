enum GroupMode { none, targetDate }

extension GroupModeLabel on GroupMode {
  String get label {
    switch (this) {
      case GroupMode.none:
        return 'No grouping';
      case GroupMode.targetDate:
        return 'By target date';
    }
  }
}

