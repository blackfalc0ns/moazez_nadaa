/// List extensions providing utility methods for list manipulation
extension ListExtensions<T> on List<T> {
  /// Get element at index or null if out of bounds
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Get first element or null if list is empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null if list is empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Get element at index or default value
  T getOrElse(int index, T defaultValue) {
    if (index < 0 || index >= length) return defaultValue;
    return this[index];
  }

  /// Safely map list elements
  List<R> mapSafe<R>(R Function(T element) transform) {
    return map(transform).toList();
  }

  /// Filter list and remove nulls
  List<R> filterMap<R>(R? Function(T element) transform) {
    return where((e) => transform(e) != null).map((e) => transform(e)!).toList();
  }

  /// Partition list into two lists based on predicate
  (List<T>, List<T>) partition(bool Function(T) predicate) {
    final pass = <T>[];
    final fail = <T>[];
    for (final element in this) {
      if (predicate(element)) {
        pass.add(element);
      } else {
        fail.add(element);
      }
    }
    return (pass, fail);
  }

  /// Group list by key
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(element);
    }
    return map;
  }

  /// Sort list by key
  List<T> sortedBy<K extends Comparable<K>>(K Function(T) keyFunction) {
    final list = List<T>.from(this);
    list.sort((a, b) => keyFunction(a).compareTo(keyFunction(b)));
    return list;
  }

  /// Sort list by key in descending order
  List<T> sortedByDescending<K extends Comparable<K>>(K Function(T) keyFunction) {
    final list = List<T>.from(this);
    list.sort((a, b) => keyFunction(b).compareTo(keyFunction(a)));
    return list;
  }

  /// Take first n elements
  List<T> takeFirst(int n) {
    if (n >= length) return List<T>.from(this);
    return sublist(0, n);
  }

  /// Skip first n elements
  List<T> skipFirst(int n) {
    if (n >= length) return [];
    return sublist(n);
  }

  /// Chunk list into smaller lists of specified size
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }

  /// Check if all elements satisfy predicate
  bool allWhere(bool Function(T) predicate) {
    for (final element in this) {
      if (!predicate(element)) return false;
    }
    return true;
  }

  /// Check if any element satisfies predicate
  bool anyWhere(bool Function(T) predicate) {
    for (final element in this) {
      if (predicate(element)) return true;
    }
    return false;
  }

  /// Get unique elements based on key
  List<T> uniqueBy<K>(K Function(T) keyFunction) {
    final seen = <K>{};
    final result = <T>[];
    for (final element in this) {
      final key = keyFunction(element);
      if (!seen.contains(key)) {
        seen.add(key);
        result.add(element);
      }
    }
    return result;
  }

  /// Flatten nested list
  List<R> flatten<R>() {
    return expand((e) => e is List ? e.flatten<R>() : [e as R]).toList();
  }

  /// Replace element at index
  List<T> replaceAt(int index, T element) {
    if (index < 0 || index >= length) return this;
    final list = List<T>.from(this);
    list[index] = element;
    return list;
  }

  /// Insert element at index if valid
  List<T> insertAt(int index, T element) {
    if (index < 0 || index > length) return this;
    final list = List<T>.from(this);
    list.insert(index, element);
    return list;
  }

  /// Remove element at index if valid
  List<T> removeAt(int index) {
    if (index < 0 || index >= length) return this;
    final list = List<T>.from(this);
    list.removeAt(index);
    return list;
  }

  /// Get middle element
  T? get middle {
    if (isEmpty) return null;
    return this[(length / 2).floor()];
  }

  /// Check if list is not empty
  bool get isNotEmptyList => isNotEmpty;

  /// Check if list is empty
  bool get isEmptyList => isEmpty;
}

/// Nullable List extensions
extension NullableListExtensions<T> on List<T>? {
  /// Check if null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Get list or empty list
  List<T> get orEmpty => this ?? [];

  /// Check if not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
}