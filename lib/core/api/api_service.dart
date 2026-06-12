import 'package:dio/dio.dart';
import '../api/api_response.dart';
import '../api/api_config.dart';
import '../errors/failures/typed_failure.dart';

/// Generic API service that handles HTTP requests with TypedFailure error handling
/// Provides a consistent interface for all API operations
class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  /// Handle response and convert to ApiResponse with TypedFailure
  ApiResponse<T> _handleResponse<T>(
    Response<dynamic> response, {
    T Function(dynamic)? parser,
  }) {
    final statusCode = response.statusCode;
    final data = response.data;

    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      T parsedData;
      if (parser != null && data != null) {
        parsedData = parser(data);
      } else if (data is T) {
        parsedData = data;
      } else {
        parsedData = data as T;
      }
      return ApiResponse.success(
        data: parsedData,
        statusCode: statusCode,
      );
    } else {
      final failure = TypedFailureFactory.fromStatusCode(
        statusCode ?? 500,
        message: _extractErrorMessage(data),
        metadata: data is Map<String, dynamic> ? data : null,
      );
      return ApiResponse.failure(failure: failure);
    }
  }

  /// Extract error message from response
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      // ✅ Check for nested error object first (API standard format)
      if (data['error'] != null && data['error'] is Map) {
        final error = data['error'] as Map;
        return error['message'] ?? error['msg'];
      }
      // Fallback to root level message
      return data['message'] ?? data['error'] ?? data['msg'];
    }
    return data.toString();
  }

  /// Handle Dio exception and convert to TypedFailure
  TypedFailure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        // ✅ For network errors, use fallback message (no API response)
        return const TimeoutFailure(
          message: 'انتهت مهلة الاتصال',
          metadata: {},
        );
      case DioExceptionType.connectionError:
        // ✅ For network errors, use fallback message (no API response)
        return const NetworkFailure(
          message: 'لا يوجد اتصال بالإنترنت',
          metadata: {},
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'تم إلغاء الطلب');
      case DioExceptionType.unknown:
      default:
        return UnknownFailure(
          message: 'حدث خطأ غير متوقع',
          metadata: {'exception': e.toString()},
        );
    }
  }

  /// Handle bad HTTP responses and convert to TypedFailure
  TypedFailure _handleBadResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (statusCode == null) {
      return const ServerFailureTyped(message: 'لم يتم الحصول على رد من الخادم');
    }

    // Extract API message (may be English; ErrorMessageMapper will localize it)
    final apiMessage = _extractErrorMessage(data);
    final metadata = data is Map<String, dynamic>
        ? {...data, 'api_message': apiMessage}
        : {'api_message': apiMessage};

    return TypedFailureFactory.fromStatusCode(
      statusCode,
      message: apiMessage,
      metadata: metadata,
    );
  }

  /// Perform GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response, parser: parser);
    } on DioException catch (e) {
      final failure = _handleDioException(e);
      return ApiResponse.failure(failure: failure);
    } catch (e) {
      return ApiResponse.failure(
        failure: UnknownFailure(
          message: 'حدث خطأ غير متوقع',
          metadata: {'exception': e.toString()},
        ),
      );
    }
  }

  /// Perform POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response, parser: parser);
    } on DioException catch (e) {
      final failure = _handleDioException(e);
      return ApiResponse.failure(failure: failure);
    } catch (e) {
      return ApiResponse.failure(
        failure: UnknownFailure(
          message: 'حدث خطأ غير متوقع',
          metadata: {'exception': e.toString()},
        ),
      );
    }
  }

  /// Perform PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response, parser: parser);
    } on DioException catch (e) {
      final failure = _handleDioException(e);
      return ApiResponse.failure(failure: failure);
    } catch (e) {
      return ApiResponse.failure(
        failure: UnknownFailure(
          message: 'حدث خطأ غير متوقع',
          metadata: {'exception': e.toString()},
        ),
      );
    }
  }

  /// Perform PATCH request
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response, parser: parser);
    } on DioException catch (e) {
      final failure = _handleDioException(e);
      return ApiResponse.failure(failure: failure);
    } catch (e) {
      return ApiResponse.failure(
        failure: UnknownFailure(
          message: 'حدث خطأ غير متوقع',
          metadata: {'exception': e.toString()},
        ),
      );
    }
  }

  /// Perform DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response, parser: parser);
    } on DioException catch (e) {
      final failure = _handleDioException(e);
      return ApiResponse.failure(failure: failure);
    } catch (e) {
      return ApiResponse.failure(
        failure: UnknownFailure(
          message: 'حدث خطأ غير متوقع',
          metadata: {'exception': e.toString()},
        ),
      );
    }
  }

  /// Upload file with progress tracking
  Future<ApiResponse<T>> uploadFile<T>({
    required String path,
    required FormData data,
    void Function(int, int)? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        onSendProgress: onSendProgress,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response, parser: parser);
    } on DioException catch (e) {
      final failure = _handleDioException(e);
      return ApiResponse.failure(failure: failure);
    } catch (e) {
      return ApiResponse.failure(
        failure: UnknownFailure(
          message: 'حدث خطأ غير متوقع',
          metadata: {'exception': e.toString()},
        ),
      );
    }
  }

  /// Download file with progress tracking
  Future<ApiResponse<String>> downloadFile({
    required String path,
    required String savePath,
    void Function(int, int)? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
        path,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return ApiResponse.success(data: savePath);
    } on DioException catch (e) {
      final failure = _handleDioException(e);
      return ApiResponse.failure(failure: failure);
    } catch (e) {
      return ApiResponse.failure(
        failure: UnknownFailure(
          message: 'حدث خطأ غير متوقع',
          metadata: {'exception': e.toString()},
        ),
      );
    }
  }

  /// Set auth token for all requests
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = ApiConfig.authorizationHeader(token);
  }

  /// Clear auth token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Set language header
  void setLanguage(String languageCode) {
    _dio.options.headers['X-Language'] = languageCode;
  }
}