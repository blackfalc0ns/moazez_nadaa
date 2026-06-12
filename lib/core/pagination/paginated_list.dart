/// Represents a paginated list of items
/// Used for API responses that return lists with pagination info
class PaginatedList<T> {
  /// The list of items for the current page
  final List<T> items;

  /// Current page number
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Total number of items across all pages
  final int totalItems;

  /// Number of items per page
  final int itemsPerPage;

  /// Whether there is a next page
  final bool hasNextPage;

  /// Whether there is a previous page
  final bool hasPreviousPage;

  /// Index of the first item on current page
  final int? firstItemIndex;

  /// Index of the last item on current page
  final int? lastItemIndex;

  const PaginatedList({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.firstItemIndex,
    this.lastItemIndex,
  });

  /// Create empty paginated list
  factory PaginatedList.empty() {
    return const PaginatedList(
      items: [],
      currentPage: 1,
      totalPages: 1,
      totalItems: 0,
      itemsPerPage: 20,
      hasNextPage: false,
      hasPreviousPage: false,
    );
  }

  /// Create from common API envelope shapes.
  ///
  /// Supported data keys examples: items, tasks, submissions, history, classes
  /// Supported pagination keys examples: pagination, meta, root-level page fields
  factory PaginatedList.fromApiEnvelope(
    Map<String, dynamic> json, {
    required T Function(Map<String, dynamic>) fromJson,
    List<String> itemKeys = const ['items'],
  }) {
    final dynamic itemsDynamic = _extractByKeys(json, itemKeys) ?? const [];
    final listRaw = itemsDynamic is List ? itemsDynamic : const [];

    final items = listRaw
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);

    final paginationMap = _extractPaginationMap(json);

    final currentPage = _readInt(paginationMap, const [
      'current_page',
      'currentPage',
      'page',
    ], fallback: 1);
    final totalPages = _readInt(paginationMap, const [
      'total_pages',
      'totalPages',
      'last_page',
      'lastPage',
    ], fallback: 1);
    final totalItems = _readInt(paginationMap, const [
      'total_items',
      'totalItems',
      'total',
      'count',
    ], fallback: items.length);
    final itemsPerPage = _readInt(paginationMap, const [
      'per_page',
      'items_per_page',
      'itemsPerPage',
      'limit',
      'page_size',
    ], fallback: items.length);

    final hasNext = _readBool(
      paginationMap,
      const ['has_next', 'hasNext', 'has_more', 'hasMore'],
      fallback: currentPage < totalPages,
    );

    final hasPrevious = _readBool(
      paginationMap,
      const ['has_previous', 'hasPrevious'],
      fallback: currentPage > 1,
    );

    return PaginatedList<T>(
      items: items,
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      itemsPerPage: itemsPerPage,
      hasNextPage: hasNext,
      hasPreviousPage: hasPrevious,
      firstItemIndex: _readNullableInt(
        paginationMap,
        const ['first_item_index', 'firstItemIndex', 'from'],
      ),
      lastItemIndex: _readNullableInt(
        paginationMap,
        const ['last_item_index', 'lastItemIndex', 'to'],
      ),
    );
  }

  static dynamic _extractByKeys(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key)) return json[key];
    }
    return null;
  }

  static Map<String, dynamic> _extractPaginationMap(Map<String, dynamic> json) {
    final fromPagination = json['pagination'];
    if (fromPagination is Map) return Map<String, dynamic>.from(fromPagination);

    final fromMeta = json['meta'];
    if (fromMeta is Map) {
      final meta = Map<String, dynamic>.from(fromMeta);
      final nestedPagination = meta['pagination'];
      if (nestedPagination is Map) return Map<String, dynamic>.from(nestedPagination);
      return meta;
    }

    return json;
  }

  static int _readInt(
    Map<String, dynamic> source,
    List<String> keys, {
    required int fallback,
  }) {
    for (final key in keys) {
      final value = source[key];
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return fallback;
  }

  static int? _readNullableInt(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  static bool _readBool(
    Map<String, dynamic> source,
    List<String> keys, {
    required bool fallback,
  }) {
    for (final key in keys) {
      final value = source[key];
      if (value is bool) return value;
      if (value is String) {
        final normalized = value.toLowerCase();
        if (normalized == 'true' || normalized == '1') return true;
        if (normalized == 'false' || normalized == '0') return false;
      }
      if (value is int) {
        if (value == 1) return true;
        if (value == 0) return false;
      }
    }
    return fallback;
  }

  /// Create from JSON with parser
  factory PaginatedList.fromJson(
    Map<String, dynamic> json, {
    required T Function(Map<String, dynamic>) fromJson,
    required int Function(Map<String, dynamic>) getCurrentPage,
    required int Function(Map<String, dynamic>) getTotalPages,
    required int Function(Map<String, dynamic>) getTotalItems,
    required int Function(Map<String, dynamic>) getItemsPerPage,
    required List<T> Function(Map<String, dynamic>) getItems,
  }) {
    return PaginatedList(
      items: getItems(json),
      currentPage: getCurrentPage(json),
      totalPages: getTotalPages(json),
      totalItems: getTotalItems(json),
      itemsPerPage: getItemsPerPage(json),
      hasNextPage: getCurrentPage(json) < getTotalPages(json),
      hasPreviousPage: getCurrentPage(json) > 1,
      firstItemIndex: json['first_item_index'],
      lastItemIndex: json['last_item_index'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items,
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_items': totalItems,
      'items_per_page': itemsPerPage,
      'has_next_page': hasNextPage,
      'has_previous_page': hasPreviousPage,
      'first_item_index': firstItemIndex,
      'last_item_index': lastItemIndex,
    };
  }

  /// Check if list is empty
  bool get isEmpty => items.isEmpty;

  /// Check if list is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Check if can load more
  bool get canLoadMore => hasNextPage && currentPage < totalPages;

  /// Check if is first page
  bool get isFirstPage => currentPage == 1;

  /// Check if is last page
  bool get isLastPage => currentPage >= totalPages;

  /// Get the page number of the next page
  int? get nextPage => hasNextPage ? currentPage + 1 : null;

  /// Get the page number of the previous page
  int? get previousPage => hasPreviousPage ? currentPage - 1 : null;

  /// Create a copy with updated values
  PaginatedList<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
    int? firstItemIndex,
    int? lastItemIndex,
  }) {
    return PaginatedList<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      firstItemIndex: firstItemIndex ?? this.firstItemIndex,
      lastItemIndex: lastItemIndex ?? this.lastItemIndex,
    );
  }

  /// Create a new instance with additional items (for load more)
  PaginatedList<T> appendItems(List<T> newItems) {
    return PaginatedList<T>(
      items: [...items, ...newItems],
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      itemsPerPage: itemsPerPage,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
      firstItemIndex: firstItemIndex,
      lastItemIndex: lastItemIndex,
    );
  }

  @override
  String toString() {
    return 'PaginatedList(items: ${items.length}, currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems)';
  }
}