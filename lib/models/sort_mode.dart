enum SortMode { alphabetical, targetDate, createdNewest, starred }

extension SortModeLabel on SortMode {
  String get label {
    switch (this) {
      case SortMode.alphabetical:
        return 'Alphabetical';
      case SortMode.targetDate:
        return 'Target date';
      case SortMode.createdNewest:
        return 'Newest first';
      case SortMode.starred:
        return 'Important first';
    }
  }
}

