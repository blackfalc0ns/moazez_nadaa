
/// Parameters for paginated requests
class PaginationParams {
  /// Current page number (1-based)
  final int page;

  /// Number of items per page
  final int pageSize;

  /// Search/filter query (optional)
  final String? query;

  /// Sort field (optional)
  final String? sortBy;

  /// Sort direction (asc/desc)
  final String sortDirection;

  /// Additional filters
  final Map<String, dynamic>? filters;

  const PaginationParams({
    this.page = 1,
    this.pageSize = 20,
    this.query,
    this.sortBy,
    this.sortDirection = 'asc',
    this.filters,
  });

  /// Create default pagination params
  factory PaginationParams.defaultPage() {
    return const PaginationParams();
  }

  /// Create for first page with page size
  factory PaginationParams.firstPage({int pageSize = 20}) {
    return PaginationParams(page: 1, pageSize: pageSize);
  }

  /// Create with query
  factory PaginationParams.withQuery({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) {
    return PaginationParams(
      page: page,
      pageSize: pageSize,
      query: query,
    );
  }

  /// Create with filters
  factory PaginationParams.withFilters({
    required Map<String, dynamic> filters,
    int page = 1,
    int pageSize = 20,
  }) {
    return PaginationParams(
      page: page,
      pageSize: pageSize,
      filters: filters,
    );
  }

  /// Convert to query parameters map
  Map<String, dynamic> toQueryParams({
    String pageKey = 'page',
    String pageSizeKey = 'limit',
    String queryKey = 'search',
    String sortByKey = 'sort_by',
    String sortDirectionKey = 'sort_direction',
  }) {
    final params = <String, dynamic>{
      pageKey: page,
      pageSizeKey: pageSize,
    };

    if (query != null && query!.isNotEmpty) {
      params[queryKey] = query;
    }

    if (sortBy != null && sortBy!.isNotEmpty) {
      params[sortByKey] = sortBy;
      params[sortDirectionKey] = sortDirection;
    }

    if (filters != null && filters!.isNotEmpty) {
      params.addAll(filters!);
    }

    params.removeWhere((key, value) => value == null || value == '');
    return params;
  }

  /// Create copy with updated values
  PaginationParams copyWith({
    int? page,
    int? pageSize,
    String? query,
    String? sortBy,
    String? sortDirection,
    Map<String, dynamic>? filters,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      query: query ?? this.query,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      filters: filters ?? this.filters,
    );
  }

  /// Create for next page (load more)
  PaginationParams nextPage() {
    return copyWith(page: page + 1);
  }

  /// Create for previous page
  PaginationParams previousPage() {
    return copyWith(page: page - 1);
  }

  /// Create for specific page
  PaginationParams forPage(int pageNumber) {
    return copyWith(page: pageNumber);
  }

  /// Reset to first page
  PaginationParams reset() {
    return copyWith(page: 1);
  }

  /// Add filter
  PaginationParams addFilter(String key, dynamic value) {
    final newFilters = Map<String, dynamic>.from(filters ?? {});
    newFilters[key] = value;
    return copyWith(filters: newFilters);
  }

  /// Remove filter
  PaginationParams removeFilter(String key) {
    final newFilters = Map<String, dynamic>.from(filters ?? {});
    newFilters.remove(key);
    return copyWith(filters: newFilters.isEmpty ? null : newFilters);
  }

  /// Clear all filters
  PaginationParams clearFilters() {
    return copyWith(filters: null, query: null);
  }

  @override
  String toString() {
    return 'PaginationParams(page: $page, pageSize: $pageSize, query: $query, sortBy: $sortBy, sortDirection: $sortDirection, filters: $filters)';
  }
}