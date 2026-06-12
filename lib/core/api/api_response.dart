import '../errors/failures/typed_failure.dart';

/// API response wrapper class that handles all API responses with TypedFailure
/// Provides a consistent structure for success and error responses
class ApiResponse<T> {
  /// Whether the request was successful
  final bool success;

  /// The response data (can be null for error responses)
  final T? data;

  /// Typed failure if the request failed
  final TypedFailure? failure;

  /// HTTP status code of the response
  final int? statusCode;

  /// Response headers
  final Map<String, dynamic>? headers;

  /// Pagination information if applicable
  final PaginationInfo? pagination;

  /// Metadata for additional response information
  final Map<String, dynamic>? metadata;

  const ApiResponse({
    required this.success,
    this.data,
    this.failure,
    this.statusCode,
    this.headers,
    this.pagination,
    this.metadata,
  });

  /// Create a successful response
  factory ApiResponse.success({
    required T data,
    int? statusCode,
    Map<String, dynamic>? headers,
    PaginationInfo? pagination,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      statusCode: statusCode,
      headers: headers,
      pagination: pagination,
      metadata: metadata,
    );
  }

  /// Create a failure response with TypedFailure
  factory ApiResponse.failure({
    required TypedFailure failure,
    Map<String, dynamic>? headers,
  }) {
    return ApiResponse<T>(
      success: false,
      failure: failure,
      statusCode: failure.statusCode,
      headers: headers,
    );
  }

  /// Check if response is successful
  bool get isSuccess => success;

  /// Check if response has error
  bool get hasError => !success;

  /// Get error message (for backward compatibility)
  String? get errorMessage => failure?.message;

  /// Get error code (for backward compatibility)
  String? get errorCode => failure?.type.name;

  /// Get data or throw if null
  T get orThrow => data ?? (throw Exception('No data available'));

  /// Get data with default fallback
  T orDefault(T defaultValue) => data ?? defaultValue;

  /// Helper method to require data (throws if null)
  T requireData() {
    if (data == null) {
      throw Exception(failure?.message ?? 'No data available');
    }
    return data!;
  }

  /// Copy with new values
  ApiResponse<T> copyWith({
    bool? success,
    T? data,
    TypedFailure? failure,
    int? statusCode,
    Map<String, dynamic>? headers,
    PaginationInfo? pagination,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: success ?? this.success,
      data: data ?? this.data,
      failure: failure ?? this.failure,
      statusCode: statusCode ?? this.statusCode,
      headers: headers ?? this.headers,
      pagination: pagination ?? this.pagination,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, failure: $failure, statusCode: $statusCode)';
  }
}

/// Pagination information for paginated responses
class PaginationInfo {
  /// Current page number
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Total number of items
  final int totalItems;

  /// Number of items per page
  final int itemsPerPage;

  /// Whether there is a next page
  final bool hasNextPage;

  /// Whether there is a previous page
  final bool hasPreviousPage;

  /// Index of the first item in current page
  final int? firstItemIndex;

  /// Index of the last item in current page
  final int? lastItemIndex;

  const PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.firstItemIndex,
    this.lastItemIndex,
  });

  /// Parse from JSON response
  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? json['currentPage'] ?? 1,
      totalPages: json['total_pages'] ?? json['totalPages'] ?? 1,
      totalItems: json['total_items'] ?? json['totalItems'] ?? 0,
      itemsPerPage: json['per_page'] ?? json['itemsPerPage'] ?? 20,
      hasNextPage: json['has_next'] ?? json['hasNext'] ?? false,
      hasPreviousPage: json['has_previous'] ?? json['hasPrevious'] ?? false,
      firstItemIndex: json['first_item_index'],
      lastItemIndex: json['last_item_index'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_items': totalItems,
      'per_page': itemsPerPage,
      'has_next': hasNextPage,
      'has_previous': hasPreviousPage,
      'first_item_index': firstItemIndex,
      'last_item_index': lastItemIndex,
    };
  }

  /// Check if has next page
  bool get canLoadMore => hasNextPage && currentPage < totalPages;

  /// Check if is first page
  bool get isFirstPage => currentPage == 1;

  /// Check if is last page
  bool get isLastPage => currentPage >= totalPages;

  @override
  String toString() {
    return 'PaginationInfo(currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems, itemsPerPage: $itemsPerPage)';
  }
}

/// Extension for list responses with pagination
class PaginatedApiResponse<T> extends ApiResponse<List<T>> {
  const PaginatedApiResponse({
    required super.success,
    super.data,
    super.failure,
    super.statusCode,
    super.headers,
    super.pagination,
  });

  /// Create successful paginated response
  factory PaginatedApiResponse.success({
    required List<T> data,
    required PaginationInfo pagination,
    int? statusCode,
  }) {
    return PaginatedApiResponse<T>(
      success: true,
      data: data,
      pagination: pagination,
      statusCode: statusCode,
    );
  }
}