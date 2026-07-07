import 'package:dartz/dartz.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/errors/failures/typed_failure.dart';
import '../mappers/dismissal_mapper.dart';
import '../models/dismissal_models.dart';

class DismissalRepo {
  DismissalRepo({ApiService? apiService})
    : _apiService = apiService ?? sl<ApiService>();

  final ApiService _apiService;

  Future<Either<TypedFailure, DismissalProfileModel>> getProfileSafe() {
    return _get(
      ApiEndpoints.dismissalProfile,
      DismissalMapper.profileFromJson,
    );
  }

  Future<Either<TypedFailure, DismissalQueuePageModel>> getActiveQueueSafe({
    DismissalRequestStatus? status,
    String? gateId,
    int page = 1,
    int limit = 30,
  }) {
    return _get(
      ApiEndpoints.dismissalActiveRequests,
      DismissalMapper.queuePageFromJson,
      queryParameters: _queueQuery(
        status: status,
        gateId: gateId,
        page: page,
        limit: limit,
      ),
    );
  }

  Future<Either<TypedFailure, DismissalRequestModel>> getRequestSafe(
    String requestId,
  ) {
    return _get(
      ApiEndpoints.dismissalRequest(requestId),
      _requestFromEnvelope,
    );
  }

  Future<Either<TypedFailure, DismissalQueuePageModel>>
  getWaitingStudentsSafe({String? gateId, int page = 1, int limit = 30}) {
    return _get(
      ApiEndpoints.dismissalWaitingStudents,
      DismissalMapper.queuePageFromJson,
      queryParameters: {
        if ((gateId ?? '').isNotEmpty) 'gateId': gateId,
        'page': page,
        'limit': limit,
      },
    );
  }

  Future<Either<TypedFailure, DismissalGatesPageModel>> getGatesSafe() {
    return _get(
      ApiEndpoints.dismissalGates,
      DismissalMapper.gatesPageFromJson,
    );
  }

  Future<Either<TypedFailure, DismissalQueuePageModel>> getHistorySafe({
    DismissalRequestStatus? status,
    String? gateId,
    int page = 1,
    int limit = 30,
  }) {
    return _get(
      ApiEndpoints.dismissalRequestHistory,
      DismissalMapper.queuePageFromJson,
      queryParameters: {
        ..._queueQuery(
          status: status,
          gateId: gateId,
          page: page,
          limit: limit,
        ),
        'sort': 'requested_at_desc',
      },
    );
  }

  Future<Either<TypedFailure, DismissalRequestModel>> getHistoryRequestSafe(
    String requestId,
  ) {
    return _get(
      ApiEndpoints.dismissalHistoryRequest(requestId),
      _requestFromEnvelope,
    );
  }

  Future<Either<TypedFailure, DismissalNotificationsPageModel>>
  getNotificationsSafe({
    bool unreadOnly = false,
    int page = 1,
    int limit = 30,
  }) {
    return _get(
      ApiEndpoints.dismissalNotifications,
      DismissalMapper.notificationsPageFromJson,
      queryParameters: {
        if (unreadOnly) 'status': 'unread',
        'page': page,
        'limit': limit,
      },
    );
  }

  Future<Either<TypedFailure, bool>> markNotificationReadSafe(
    String notificationId,
  ) {
    return _patchFlag(
      ApiEndpoints.dismissalNotificationRead(notificationId),
    );
  }

  Future<Either<TypedFailure, bool>> markAllNotificationsReadSafe() {
    return _patchFlag(ApiEndpoints.dismissalNotificationsReadAll);
  }

  Future<Either<TypedFailure, bool>> registerDeviceTokenSafe({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
  }) {
    return _postFlag(
      ApiEndpoints.dismissalNotificationDeviceTokens,
      data: {
        'token': token,
        'platform': platform,
        if ((deviceId ?? '').isNotEmpty) 'deviceId': deviceId,
        if ((deviceName ?? '').isNotEmpty) 'deviceName': deviceName,
      },
    );
  }

  Future<Either<TypedFailure, bool>> unregisterCurrentDeviceTokenSafe({
    required String token,
  }) async {
    try {
      final response = await _apiService.delete<Map<String, dynamic>>(
        ApiEndpoints.dismissalNotificationCurrentDeviceToken,
        data: {'token': token},
        parser: DismissalMapper.extractMap,
      );
      return _flagResult(response.isSuccess, response.failure);
    } catch (error) {
      return Left(_failureFromError(error));
    }
  }

  Future<Either<TypedFailure, DismissalRequestModel>> updateStatusSafe({
    required String requestId,
    required DismissalRequestStatus status,
    String? note,
  }) {
    return _patch(
      ApiEndpoints.dismissalRequestStatus(requestId),
      _requestFromEnvelope,
      data: {
        'status': status.apiValue,
        if ((note ?? '').isNotEmpty) 'note': note,
      },
    );
  }

  Future<Either<TypedFailure, DismissalRequestModel>> confirmArrivalSafe({
    required String requestId,
  }) {
    return _post(
      ApiEndpoints.dismissalWaitingStudentArrival(requestId),
      _requestFromEnvelope,
    );
  }

  Future<Either<TypedFailure, DismissalRecipientsModel>> getRecipientsSafe(
    String requestId,
  ) {
    return _get(
      ApiEndpoints.dismissalPickupRecipients(requestId),
      DismissalMapper.recipientsFromJson,
    );
  }

  Future<Either<TypedFailure, DismissalDeliveryModel>> deliverSafe({
    required String requestId,
    required String pickupRecipientToken,
    required String pickupCode,
    String? note,
  }) {
    return _post(
      ApiEndpoints.dismissalDeliver(requestId),
      DismissalMapper.deliveryFromJson,
      data: {
        'pickupRecipientToken': pickupRecipientToken,
        if (pickupCode.trim().isNotEmpty) 'pickupCode': pickupCode.trim(),
        if ((note ?? '').isNotEmpty) 'note': note,
      },
    );
  }

  Future<Either<TypedFailure, DismissalRequestModel>> escalateSafe({
    required String requestId,
    String? reason,
  }) {
    return _post(
      ApiEndpoints.dismissalEscalate(requestId),
      _requestFromEnvelope,
      data: {if ((reason ?? '').isNotEmpty) 'reason': reason},
    );
  }

  Map<String, dynamic> _queueQuery({
    required DismissalRequestStatus? status,
    required String? gateId,
    required int page,
    required int limit,
  }) {
    return {
      if (status != null && status != DismissalRequestStatus.unknown)
        'status': status.apiValue,
      if ((gateId ?? '').isNotEmpty) 'gateId': gateId,
      'page': page,
      'limit': limit,
    };
  }

  DismissalRequestModel _requestFromEnvelope(Map<String, dynamic> json) {
    final request = DismissalMapper.mapFrom(json, 'request');
    return DismissalMapper.requestFromJson(request.isEmpty ? json : request);
  }

  Future<Either<TypedFailure, T>> _get<T>(
    String path,
    T Function(Map<String, dynamic>) mapper, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        parser: DismissalMapper.extractMap,
      );
      if (!response.isSuccess || response.data == null) {
        return Left(response.failure ?? const UnknownFailure());
      }
      return Right(mapper(response.data!));
    } catch (error) {
      return Left(_failureFromError(error));
    }
  }

  Future<Either<TypedFailure, T>> _post<T>(
    String path,
    T Function(Map<String, dynamic>) mapper, {
    dynamic data,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        path,
        data: data,
        parser: DismissalMapper.extractMap,
      );
      if (!response.isSuccess || response.data == null) {
        return Left(response.failure ?? const UnknownFailure());
      }
      return Right(mapper(response.data!));
    } catch (error) {
      return Left(_failureFromError(error));
    }
  }

  Future<Either<TypedFailure, T>> _patch<T>(
    String path,
    T Function(Map<String, dynamic>) mapper, {
    dynamic data,
  }) async {
    try {
      final response = await _apiService.patch<Map<String, dynamic>>(
        path,
        data: data,
        parser: DismissalMapper.extractMap,
      );
      if (!response.isSuccess || response.data == null) {
        return Left(response.failure ?? const UnknownFailure());
      }
      return Right(mapper(response.data!));
    } catch (error) {
      return Left(_failureFromError(error));
    }
  }

  Future<Either<TypedFailure, bool>> _postFlag(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        path,
        data: data,
        parser: DismissalMapper.extractMap,
      );
      return _flagResult(response.isSuccess, response.failure);
    } catch (error) {
      return Left(_failureFromError(error));
    }
  }

  Future<Either<TypedFailure, bool>> _patchFlag(String path) async {
    try {
      final response = await _apiService.patch<Map<String, dynamic>>(
        path,
        parser: DismissalMapper.extractMap,
      );
      return _flagResult(response.isSuccess, response.failure);
    } catch (error) {
      return Left(_failureFromError(error));
    }
  }

  Either<TypedFailure, bool> _flagResult(
    bool isSuccess,
    TypedFailure? failure,
  ) {
    return isSuccess
        ? const Right(true)
        : Left(failure ?? const UnknownFailure());
  }

  TypedFailure _failureFromError(Object error) {
    if (error is TypedFailure) return error;
    return TypedFailureFactory.fromException(
      error is Exception ? error : Exception(error.toString()),
    );
  }
}
