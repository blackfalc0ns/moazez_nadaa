import '../../../../core/pagination/paginated_list.dart';
import '../models/dismissal_notification_model.dart';

class DismissalNotificationMapper {
  const DismissalNotificationMapper._();

  static PaginatedList<DismissalNotificationModel> page(
    Map<String, dynamic> json,
  ) {
    final root = _payload(json);
    final items = _responseList(json, root, const [
      'notifications',
      'items',
    ]).map(notification).toList(growable: false);
    final pagination = _map(root['pagination'] ?? root['meta']) ?? root;
    final currentPage =
        _int(pagination, const ['page', 'currentPage', 'current_page']) ?? 1;
    final limit =
        _int(pagination, const [
          'limit',
          'perPage',
          'per_page',
          'itemsPerPage',
        ]) ??
        (items.isEmpty ? 20 : items.length);
    final total =
        _int(pagination, const ['total', 'totalItems', 'total_items']) ??
        items.length;
    final totalPages =
        _int(pagination, const ['totalPages', 'total_pages', 'lastPage']) ??
        (limit <= 0 ? 1 : (total / limit).ceil().clamp(1, 999999).toInt());
    final hasNext =
        _bool(pagination, const [
          'hasNext',
          'has_next',
          'hasMore',
          'has_more',
        ]) ??
        currentPage < totalPages;

    return PaginatedList<DismissalNotificationModel>(
      items: items,
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: total,
      itemsPerPage: limit,
      hasNextPage: hasNext,
      hasPreviousPage: currentPage > 1,
    );
  }

  static DismissalNotificationModel detail(Map<String, dynamic> json) =>
      notification(_unwrap(json, const ['notification', 'item', 'result']));

  static DismissalNotificationModel notification(Map<String, dynamic> json) {
    return DismissalNotificationModel(
      id: _string(json, const ['notificationId', 'notification_id', 'id']),
      type: _string(json, const ['type'], fallback: 'notification'),
      sourceModule: _string(json, const [
        'sourceModule',
        'source_module',
        'module',
      ], fallback: 'DISMISSAL'),
      sourceId: _nullableString(json, const [
        'sourceId',
        'source_id',
        'entityId',
      ]),
      title: _localized(json['title']),
      body: _localized(json['body'] ?? json['message'] ?? json['description']),
      priority: _string(json, const ['priority'], fallback: 'normal'),
      status: _string(json, const ['status'], fallback: 'unread'),
      readAt: _date(json['readAt'] ?? json['read_at']),
      archivedAt: _date(json['archivedAt'] ?? json['archived_at']),
      createdAt: _date(
        json['createdAt'] ?? json['created_at'] ?? json['sentAt'],
      ),
      deepLink: _deepLink(json),
    );
  }

  static DismissalNotificationsSummary summary(Map<String, dynamic> json) {
    final unread = _recursiveInt(json, const [
      'unreadCount',
      'unread_count',
      'unread',
      'unreadNotifications',
      'unread_notifications',
      'newCount',
      'new_count',
      'new',
    ]);
    final total = _recursiveInt(json, const [
      'totalCount',
      'total_count',
      'total',
      'allCount',
      'all_count',
      'all',
      'count',
      'notificationsCount',
      'notifications_count',
      'totalNotifications',
      'total_notifications',
    ]);
    final archived = _recursiveInt(json, const [
      'archivedCount',
      'archived_count',
      'archived',
      'archivedNotifications',
      'archived_notifications',
    ]);
    final highPriority =
        _recursiveInt(json, const [
          'highPriorityCount',
          'high_priority_count',
          'urgentCount',
          'urgent_count',
          'importantCount',
          'important_count',
        ]) ??
        _recursiveSum(json, const ['high', 'urgent', 'critical', 'important']);
    return DismissalNotificationsSummary(
      unreadCount: unread ?? 0,
      totalCount: total ?? 0,
      archivedCount: archived ?? 0,
      highPriorityCount: highPriority ?? 0,
    );
  }

  static DismissalNotificationsSummary summaryFromPage(
    PaginatedList<DismissalNotificationModel> page,
  ) {
    final items = page.items;
    return DismissalNotificationsSummary(
      totalCount: page.totalItems > items.length
          ? page.totalItems
          : items.length,
      unreadCount: items
          .where((item) => !item.isRead && !item.isArchived)
          .length,
      archivedCount: items.where((item) => item.isArchived).length,
      highPriorityCount: items.where((item) => item.isHighPriority).length,
    );
  }

  static DismissalNotificationsSummary reconcileSummary(
    DismissalNotificationsSummary summary,
    PaginatedList<DismissalNotificationModel> page,
  ) {
    final visible = summaryFromPage(page);
    return DismissalNotificationsSummary(
      totalCount: _max(summary.totalCount, visible.totalCount),
      unreadCount: _max(summary.unreadCount, visible.unreadCount),
      archivedCount: _max(summary.archivedCount, visible.archivedCount),
      highPriorityCount: _max(
        summary.highPriorityCount,
        visible.highPriorityCount,
      ),
    );
  }

  static DismissalNotificationDeepLink? _deepLink(Map<String, dynamic> json) {
    final raw = json['deepLink'] ?? json['deep_link'] ?? json['link'];
    final map = _map(raw);
    if (map != null) {
      final requestId = _nullableString(map, const [
        'requestId',
        'request_id',
        'dismissalRequestId',
        'dismissal_request_id',
        'sourceId',
        'source_id',
      ]);
      if (requestId != null) {
        return DismissalNotificationDeepLink(
          type: DismissalNotificationDeepLinkType.dismissalRequest,
          requestId: requestId,
        );
      }
      return null;
    }

    final sourceType = _string(json, const ['sourceType', 'source_type']);
    final sourceId = _nullableString(json, const [
      'requestId',
      'request_id',
      'dismissalRequestId',
      'dismissal_request_id',
      'sourceId',
      'source_id',
    ]);
    if ((sourceType == 'dismissal_request' ||
            sourceType.isEmpty ||
            sourceType == 'request') &&
        sourceId != null) {
      return DismissalNotificationDeepLink(
        type: DismissalNotificationDeepLinkType.dismissalRequest,
        requestId: sourceId,
      );
    }

    final direct = raw?.toString().trim();
    if (direct == null || direct.isEmpty) return null;
    final requestMatch = RegExp(
      r'^(?:dismissal_request|request):([^/]+)$',
    ).firstMatch(direct);
    if (requestMatch != null) {
      return DismissalNotificationDeepLink(
        type: DismissalNotificationDeepLinkType.dismissalRequest,
        requestId: requestMatch.group(1),
      );
    }
    return null;
  }

  static Map<String, dynamic> _payload(Map<String, dynamic> json) =>
      _map(json['data']) ?? json;

  static Map<String, dynamic> _unwrap(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    final root = _payload(json);
    for (final key in keys) {
      final nested = _map(root[key]);
      if (nested != null) return nested;
    }
    return root;
  }

  static List<Map<String, dynamic>> _responseList(
    Map<String, dynamic> json,
    Map<String, dynamic> root,
    List<String> keys,
  ) {
    for (final key in keys) {
      final values = _list(root[key]);
      if (values.isNotEmpty || root[key] is List) return values;
    }
    return _list(json['data']);
  }

  static List<Map<String, dynamic>> _list(Object? value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }

  static Map<String, dynamic>? _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String _string(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) => _nullableString(json, keys) ?? fallback;

  static String? _nullableString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
      if (value is num || value is bool) return value.toString();
    }
    return null;
  }

  static int? _int(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = num.tryParse(value);
        if (parsed != null) return parsed.toInt();
      }
    }
    return null;
  }

  static int? _recursiveInt(Object? value, List<String> keys, [int depth = 0]) {
    if (depth > 6) return null;
    final map = _map(value);
    if (map == null) return null;
    final normalizedKeys = keys.map(_normalizeKey).toSet();
    for (final entry in map.entries) {
      if (!normalizedKeys.contains(_normalizeKey(entry.key))) continue;
      final parsed = _toInt(entry.value);
      if (parsed != null) return parsed;
    }
    for (final nested in map.values) {
      final parsed = _recursiveInt(nested, keys, depth + 1);
      if (parsed != null) return parsed;
    }
    return null;
  }

  static int? _recursiveSum(Object? value, List<String> keys, [int depth = 0]) {
    if (depth > 6) return null;
    final map = _map(value);
    if (map == null) return null;
    final normalizedKeys = keys.map(_normalizeKey).toSet();
    var found = false;
    var total = 0;
    for (final entry in map.entries) {
      if (normalizedKeys.contains(_normalizeKey(entry.key))) {
        final parsed = _toInt(entry.value);
        if (parsed != null) {
          found = true;
          total += parsed;
        }
      }
      final nested = _recursiveSum(entry.value, keys, depth + 1);
      if (nested != null) {
        found = true;
        total += nested;
      }
    }
    return found ? total : null;
  }

  static int? _toInt(Object? value) {
    if (value is num) return value.toInt();
    if (value is String) return num.tryParse(value)?.toInt();
    return null;
  }

  static String _normalizeKey(String value) =>
      value.replaceAll(RegExp(r'[_\-\s]'), '').toLowerCase();

  static int _max(int first, int second) => first > second ? first : second;

  static bool? _bool(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final normalized = value.toLowerCase();
        if (normalized == 'true' || normalized == '1') return true;
        if (normalized == 'false' || normalized == '0') return false;
      }
    }
    return null;
  }

  static DateTime? _date(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static String _localized(Object? value) {
    if (value is String) return value.trim();
    final map = _map(value);
    if (map == null) return '';
    for (final key in ['ar', 'textAr', 'text_ar', 'en', 'textEn', 'text_en']) {
      final candidate = map[key];
      if (candidate is String && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }
    return '';
  }
}
