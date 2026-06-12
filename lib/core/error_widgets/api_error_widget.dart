import 'package:flutter/material.dart';
import 'package:ndaaa_chat/core/errors/api_exception.dart';
import 'package:ndaaa_chat/core/errors/api_error_type.dart';

import 'no_internet_error_widget.dart';
import 'timeout_error_widget.dart';
import 'server_error_widget.dart';
import 'client_error_widget.dart';
import 'generic_error_widget.dart';

class ApiErrorWidget extends StatelessWidget {
  final ApiException exception;
  final VoidCallback? onRetry;
  final VoidCallback? onGoBack;
  final VoidCallback? onContactSupport;
  final VoidCallback? onCheckConnection;

  const ApiErrorWidget({
    super.key,
    required this.exception,
    this.onRetry,
    this.onGoBack,
    this.onContactSupport,
    this.onCheckConnection,
  });

  @override
  Widget build(BuildContext context) {
    switch (exception.errorType) {
      // Network errors
      case ApiErrorType.noInternetConnection:
        return NoInternetErrorWidget(
          onRetry: onRetry,
          onCheckConnection: onCheckConnection,
        );

      // Timeout errors
      case ApiErrorType.connectionTimeout:
      case ApiErrorType.receiveTimeout:
      case ApiErrorType.sendTimeout:
      case ApiErrorType.requestTimeout:
        return TimeoutErrorWidget(
          timeoutType: exception.errorType,
          onRetry: onRetry,
        );

      // Server errors
      case ApiErrorType.serverError:
      case ApiErrorType.internalServerError:
      case ApiErrorType.badGateway:
      case ApiErrorType.serviceUnavailable:
      case ApiErrorType.gatewayTimeout:
        return ServerErrorWidget(
          serverErrorType: exception.errorType,
          statusCode: exception.statusCode,
          serverMessage: !exception.isTranslationKey ? exception.message : null,
          onRetry: onRetry,
          onContactSupport: onContactSupport,
        );

      // Client errors
      case ApiErrorType.badRequest:
      case ApiErrorType.unauthorized:
      case ApiErrorType.forbidden:
      case ApiErrorType.notFound:
      case ApiErrorType.methodNotAllowed:
      case ApiErrorType.notAcceptable:
      case ApiErrorType.conflict:
      case ApiErrorType.gone:
      case ApiErrorType.lengthRequired:
      case ApiErrorType.preconditionFailed:
      case ApiErrorType.payloadTooLarge:
      case ApiErrorType.uriTooLong:
      case ApiErrorType.unsupportedMediaType:
      case ApiErrorType.rangeNotSatisfiable:
      case ApiErrorType.expectationFailed:
      case ApiErrorType.tooManyRequests:
        final shouldUseServerMessage =
            exception.errorType != ApiErrorType.unauthorized;
        return ClientErrorWidget(
          clientErrorType: exception.errorType,
          statusCode: exception.statusCode,
          serverMessage: shouldUseServerMessage && !exception.isTranslationKey
              ? exception.message
              : null,
          onRetry: onRetry,
          onGoBack: onGoBack,
        );

      // Generic errors
      case ApiErrorType.unknown:
      case ApiErrorType.cancelled:
      case ApiErrorType.other:
        return GenericErrorWidget(
          errorType: exception.errorType,
          serverMessage: !exception.isTranslationKey ? exception.message : null,
          onRetry: onRetry,
          onGoBack: onGoBack,
        );
    }
  }

  /// Factory method to create ApiErrorWidget from any exception
  static Widget fromException(
    Exception exception, {
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
    VoidCallback? onContactSupport,
    VoidCallback? onCheckConnection,
  }) {
    ApiException apiException;

    if (exception is ApiException) {
      apiException = exception;
    } else {
      // Convert any other exception to ApiException
      apiException = ApiException(
        errorType: ApiErrorType.unknown,
        message: exception.toString(),
      );
    }

    return ApiErrorWidget(
      exception: apiException,
      onRetry: onRetry,
      onGoBack: onGoBack,
      onContactSupport: onContactSupport,
      onCheckConnection: onCheckConnection,
    );
  }

  /// Factory method to create ApiErrorWidget from TypedFailure
  static Widget fromTypedFailure(
    dynamic failure, {
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
    VoidCallback? onContactSupport,
    VoidCallback? onCheckConnection,
  }) {
    ApiErrorType mapType(dynamic type) {
      final typeString = type.toString();
      if (typeString.contains('network') || typeString.contains('connectionError')) return ApiErrorType.noInternetConnection;
      if (typeString.contains('timeout')) return ApiErrorType.connectionTimeout;
      if (typeString.contains('serverError') || typeString.contains('internalServer')) return ApiErrorType.serverError;
      if (typeString.contains('unauthorized') || typeString.contains('tokenExpired') || typeString.contains('sessionExpired') || typeString.contains('invalidCredentials')) return ApiErrorType.unauthorized;
      if (typeString.contains('forbidden')) return ApiErrorType.forbidden;
      if (typeString.contains('notFound')) return ApiErrorType.notFound;
      if (typeString.contains('validation') || typeString.contains('invalidInput')) return ApiErrorType.badRequest;
      return ApiErrorType.unknown;
    }

    final apiException = ApiException(
      errorType: mapType(failure.type),
      message: '',
      statusCode: failure.statusCode,
      isTranslationKey: true,
    );

    return ApiErrorWidget(
      exception: apiException,
      onRetry: onRetry,
      onGoBack: onGoBack,
      onContactSupport: onContactSupport,
      onCheckConnection: onCheckConnection,
    );
  }
}
