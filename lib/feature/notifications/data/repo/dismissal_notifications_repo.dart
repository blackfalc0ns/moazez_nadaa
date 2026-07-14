import 'package:dartz/dartz.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/errors/failures/typed_failure.dart';
import '../../../../core/pagination/paginated_list.dart';
import '../mappers/dismissal_notification_mapper.dart';
import '../models/dismissal_notification_model.dart';

abstract class DismissalNotificationsRepo {
  Future<Either<TypedFailure, PaginatedList<DismissalNotificationModel>>> list({
    int page = 1,
    int limit = 20,
    String status = 'all',
    String type = 'all',
  });

  Future<Either<TypedFailure, DismissalNotificationsSummary>> summary();
  Future<Either<TypedFailure, DismissalNotificationModel>> detail(
    DismissalNotificationModel notification,
  );
  Future<Either<TypedFailure, DismissalNotificationModel>> markRead(String id);
  Future<Either<TypedFailure, Unit>> markAllRead();
  Future<Either<TypedFailure, Unit>> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? appVersion,
    String? locale,
    String? timezone,
  });
  Future<Either<TypedFailure, Unit>> unregisterCurrentDeviceToken({
    String? token,
    String? deviceId,
  });
}

class DismissalNotificationsRepoImpl implements DismissalNotificationsRepo {
  DismissalNotificationsRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<Either<TypedFailure, PaginatedList<DismissalNotificationModel>>> list({
    int page = 1,
    int limit = 20,
    String status = 'all',
    String type = 'all',
  }) async {
    final hasLocalFilters = status != 'all' || type != 'all';
    final query = <String, dynamic>{
      'page': page,
      'limit': hasLocalFilters && limit < 100 ? 100 : limit,
    };
    return _get(
      ApiEndpoints.dismissalNotifications,
      query: query,
      map: (json) => _applyLocalFilters(
        DismissalNotificationMapper.page(json),
        status: status,
        type: type,
      ),
    );
  }

  PaginatedList<DismissalNotificationModel> _applyLocalFilters(
    PaginatedList<DismissalNotificationModel> page, {
    required String status,
    required String type,
  }) {
    if (status == 'all' && type == 'all') return page;
    final filtered = page.items
        .where((notification) {
          final matchesStatus = switch (status) {
            'all' => true,
            'unread' => !notification.isRead,
            'read' => notification.isRead,
            _ => true,
          };
          final matchesType = type == 'all' || notification.type == type;
          return matchesStatus && matchesType;
        })
        .toList(growable: false);
    return page.copyWith(items: filtered);
  }

  @override
  Future<Either<TypedFailure, DismissalNotificationsSummary>> summary() async {
    return _summaryFromRows();
  }

  Future<Either<TypedFailure, DismissalNotificationsSummary>> _summaryFromRows({
    DismissalNotificationsSummary? zeroSummary,
  }) async {
    final rows = await list(limit: 100);
    return rows.fold(
      Left.new,
      (page) => Right(
        DismissalNotificationMapper.reconcileSummary(
          zeroSummary ?? DismissalNotificationsSummary.empty,
          page,
        ),
      ),
    );
  }

  @override
  Future<Either<TypedFailure, DismissalNotificationModel>> detail(
    DismissalNotificationModel notification,
  ) async {
    return Right(notification);
  }

  @override
  Future<Either<TypedFailure, DismissalNotificationModel>> markRead(
    String id,
  ) async {
    try {
      final response = await _apiService.patch<dynamic>(
        ApiEndpoints.dismissalNotificationRead(id),
        data: const <String, dynamic>{},
        parser: (data) => data,
      );
      if (!response.isSuccess) {
        return Left(response.failure ?? const UnknownFailure());
      }
      if (response.data is Map) {
        final mapped = DismissalNotificationMapper.detail(
          Map<String, dynamic>.from(response.data as Map),
        );
        if (mapped.id.isNotEmpty) return Right(mapped);
      }
      return Right(DismissalNotificationModel.reference(id).markRead());
    } catch (error) {
      return Left(_failureFrom(error));
    }
  }

  @override
  Future<Either<TypedFailure, Unit>> markAllRead() =>
      _patchUnit(ApiEndpoints.dismissalNotificationsReadAll);

  @override
  Future<Either<TypedFailure, Unit>> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? appVersion,
    String? locale,
    String? timezone,
  }) {
    final payload = <String, dynamic>{'token': token, 'platform': platform};
    if ((deviceId ?? '').isNotEmpty) payload['deviceId'] = deviceId;
    if ((appVersion ?? '').isNotEmpty) payload['appVersion'] = appVersion;
    if ((locale ?? '').isNotEmpty) payload['locale'] = locale;
    if ((timezone ?? '').isNotEmpty) payload['timezone'] = timezone;
    return _postUnit(
      ApiEndpoints.dismissalNotificationDeviceTokens,
      data: payload,
    );
  }

  @override
  Future<Either<TypedFailure, Unit>> unregisterCurrentDeviceToken({
    String? token,
    String? deviceId,
  }) async {
    final payload = <String, dynamic>{};
    if ((token ?? '').isNotEmpty) payload['token'] = token;
    if ((deviceId ?? '').isNotEmpty) payload['deviceId'] = deviceId;
    if (payload.isEmpty) {
      return const Left(
        ValidationFailureTyped(message: 'A token or deviceId is required.'),
      );
    }
    try {
      final response = await _apiService.delete<dynamic>(
        ApiEndpoints.dismissalNotificationCurrentDeviceToken,
        data: payload,
        parser: (data) => data,
      );
      if (response.isSuccess) return const Right(unit);
      return Left(response.failure ?? const UnknownFailure());
    } catch (error) {
      return Left(_failureFrom(error));
    }
  }

  Future<Either<TypedFailure, T>> _get<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic>) map,
  }) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
        parser: (data) => data as Map<String, dynamic>,
      );
      if (response.isSuccess && response.data != null) {
        return Right(map(response.data!));
      }
      return Left(response.failure ?? const UnknownFailure());
    } catch (error) {
      return Left(_failureFrom(error));
    }
  }

  Future<Either<TypedFailure, Unit>> _postUnit(
    String path, {
    Map<String, dynamic> data = const {},
  }) async {
    try {
      final response = await _apiService.post<dynamic>(
        path,
        data: data,
        parser: (value) => value,
      );
      if (response.isSuccess) return const Right(unit);
      return Left(response.failure ?? const UnknownFailure());
    } catch (error) {
      return Left(_failureFrom(error));
    }
  }

  Future<Either<TypedFailure, Unit>> _patchUnit(
    String path, {
    Map<String, dynamic> data = const {},
  }) async {
    try {
      final response = await _apiService.patch<dynamic>(
        path,
        data: data,
        parser: (value) => value,
      );
      if (response.isSuccess) return const Right(unit);
      return Left(response.failure ?? const UnknownFailure());
    } catch (error) {
      return Left(_failureFrom(error));
    }
  }

  TypedFailure _failureFrom(Object error) {
    return TypedFailureFactory.fromException(
      error is Exception ? error : Exception(error.toString()),
    );
  }
}
