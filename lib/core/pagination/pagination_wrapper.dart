import 'package:flutter/material.dart';

/// Pagination state wrapper for managing paginated data loading states
enum PaginationState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
  empty,
}

/// Generic pagination wrapper for paginated data
/// Helps manage loading states and pagination operations
class PaginationWrapper<T> {
  /// Current pagination state
  final PaginationState state;

  /// List of items loaded so far
  final List<T> items;

  /// Current page number
  final int currentPage;

  /// Total pages available
  final int totalPages;

  /// Total items count
  final int totalItems;

  /// Error message if in error state
  final String? errorMessage;

  /// Whether loading more data
  bool get isLoadingMore => state == PaginationState.loadingMore;

  /// Whether initial load is in progress
  bool get isLoading => state == PaginationState.loading;

  /// Whether data is loaded
  bool get isLoaded => state == PaginationState.loaded;

  /// Whether an error occurred
  bool get hasError => state == PaginationState.error;

  /// Whether no data is available
  bool get isEmpty => state == PaginationState.empty;

  /// Whether can load more
  bool get canLoadMore => currentPage < totalPages && !isLoadingMore;

  const PaginationWrapper({
    this.state = PaginationState.initial,
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.errorMessage,
  });

  /// Initial state
  factory PaginationWrapper.initial() {
    return const PaginationWrapper();
  }

  /// Loading state
  factory PaginationWrapper.loading() {
    return const PaginationWrapper(state: PaginationState.loading);
  }

  /// Loaded state with items
  factory PaginationWrapper.loaded({
    required List<T> items,
    int currentPage = 1,
    int totalPages = 1,
    int totalItems = 0,
  }) {
    return PaginationWrapper(
      state: PaginationState.loaded,
      items: items,
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
    );
  }

  /// Loading more state (appending to existing items)
  factory PaginationWrapper.loadingMore({
    required List<T> existingItems,
    int currentPage = 1,
    int totalPages = 1,
    int totalItems = 0,
  }) {
    return PaginationWrapper(
      state: PaginationState.loadingMore,
      items: existingItems,
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
    );
  }

  /// Error state
  factory PaginationWrapper.error({
    required String message,
    List<T>? existingItems,
    int? currentPage,
    int? totalPages,
    int? totalItems,
  }) {
    return PaginationWrapper(
      state: PaginationState.error,
      items: existingItems ?? const [],
      currentPage: currentPage ?? 1,
      totalPages: totalPages ?? 1,
      totalItems: totalItems ?? 0,
      errorMessage: message,
    );
  }

  /// Empty state
  factory PaginationWrapper.empty() {
    return const PaginationWrapper(state: PaginationState.empty);
  }

  /// Create copy with updated values
  PaginationWrapper<T> copyWith({
    PaginationState? state,
    List<T>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? errorMessage,
  }) {
    return PaginationWrapper<T>(
      state: state ?? this.state,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Add more items to the list
  PaginationWrapper<T> appendItems(List<T> newItems) {
    return copyWith(
      items: [...items, ...newItems],
      state: PaginationState.loaded,
    );
  }

  /// Reset to initial state
  PaginationWrapper<T> reset() {
    return const PaginationWrapper();
  }

  @override
  String toString() {
    return 'PaginationWrapper(state: $state, items: ${items.length}, currentPage: $currentPage, totalPages: $totalPages)';
  }
}

/// Helper mixin for pagination in State classes
mixin PaginationMixin<T extends StatefulWidget, ItemType> on State<T> {
  /// Get pagination wrapper
  PaginationWrapper<ItemType> get paginationWrapper;

  /// Callback when data is loaded
  void onItemsLoaded(List<ItemType> items, int currentPage, int totalPages, int totalItems);

  /// Callback on error
  void onPaginationError(String message);
}