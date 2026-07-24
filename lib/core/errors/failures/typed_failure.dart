import 'package:flutter/material.dart';
import '../../../generated/app_localizations.dart';
import '../error_message_mapper.dart';

/// Typed failure system for better error handling
/// Instead of string messages, use typed failures
///
/// Benefits:
/// - Type-safe error handling
/// - UI can react differently to different failure types
/// - Better testing
/// - Cleaner code
enum FailureType {
  // Network failures
  network,
  timeout,
  connectionError,

  // Server failures
  serverError,
  unauthorized,
  forbidden,
  conflict,
  notFound,
  internalServer,
  serviceUnavailable,

  // Validation failures
  validation,
  invalidInput,

  // Auth failures
  tokenExpired,
  invalidCredentials,
  sessionExpired,

  // Cache failures
  cacheError,

  // Unknown
  unknown,
}

/// Base typed failure class
abstract class TypedFailure {
  final FailureType type;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? metadata;

  const TypedFailure({
    required this.type,
    this.message,
    this.statusCode,
    this.metadata,
  });

  /// Get localized message
  String getLocalizedMessage(BuildContext context);

  /// Get icon for this failure type
  IconData get icon;

  /// Get color for this failure type
  Color get color;

  /// Check if failure is recoverable
  bool get isRecoverable;

  /// Get suggested action
  String getSuggestedAction(BuildContext context);
}

/// Network failure
class NetworkFailure extends TypedFailure {
  const NetworkFailure({super.message, super.metadata})
    : super(type: FailureType.network);

  @override
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorMessageMapper.toLocalized(
      context,
      message,
      defaultMessage: l10n.errorNetwork,
    );
  }

  @override
  IconData get icon => Icons.wifi_off;

  @override
  Color get color => Colors.orange;

  @override
  bool get isRecoverable => true;

  @override
  String getSuggestedAction(BuildContext context) {
    return AppLocalizations.of(context)!.errorNetworkAction;
  }
}

/// Timeout failure
class TimeoutFailure extends TypedFailure {
  const TimeoutFailure({super.message, super.metadata})
    : super(type: FailureType.timeout);

  @override
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorMessageMapper.toLocalized(
      context,
      message,
      defaultMessage: l10n.errorTimeout,
    );
  }

  @override
  IconData get icon => Icons.access_time;

  @override
  Color get color => Colors.orange;

  @override
  bool get isRecoverable => true;

  @override
  String getSuggestedAction(BuildContext context) {
    return AppLocalizations.of(context)!.tryAgain;
  }
}

/// Server failure
class ServerFailureTyped extends TypedFailure {
  const ServerFailureTyped({super.message, super.statusCode, super.metadata})
    : super(type: FailureType.serverError);

  @override
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorMessageMapper.toLocalized(
      context,
      message,
      defaultMessage: l10n.errorServer,
    );
  }

  @override
  IconData get icon => Icons.error_outline;

  @override
  Color get color => Colors.red;

  @override
  bool get isRecoverable => statusCode != null && statusCode! >= 500;

  @override
  String getSuggestedAction(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isRecoverable) {
      return l10n.errorServerActionRetry;
    }
    return l10n.errorServerActionContact;
  }
}

/// Unauthorized failure
class UnauthorizedFailure extends TypedFailure {
  const UnauthorizedFailure({super.message, super.metadata})
    : super(type: FailureType.unauthorized, statusCode: 401);

  @override
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorMessageMapper.toLocalized(
      context,
      message,
      defaultMessage: l10n.errorInvalidCredentials,
    );
  }

  @override
  IconData get icon => Icons.lock_outline;

  @override
  Color get color => Colors.red;

  @override
  bool get isRecoverable => false;

  @override
  String getSuggestedAction(BuildContext context) {
    return AppLocalizations.of(context)!.errorUnauthorizedAction;
  }
}

/// Forbidden failure
class ForbiddenFailure extends TypedFailure {
  const ForbiddenFailure({super.message, super.metadata})
    : super(type: FailureType.forbidden, statusCode: 403);

  @override
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorMessageMapper.toLocalized(
      context,
      message,
      defaultMessage: l10n.errorForbidden,
    );
  }

  @override
  IconData get icon => Icons.block;

  @override
  Color get color => Colors.red;

  @override
  bool get isRecoverable => false;

  @override
  String getSuggestedAction(BuildContext context) {
    return AppLocalizations.of(context)!.errorForbiddenAction;
  }
}

/// Conflict failure (e.g., duplicate resource, race condition)
class ConflictFailure extends TypedFailure {
  const ConflictFailure({super.message, super.metadata})
    : super(type: FailureType.conflict, statusCode: 409);

  @override
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorMessageMapper.toLocalized(
      context,
      message,
      defaultMessage: l10n.error_conflict,
    );
  }

  @override
  IconData get icon => Icons.sync_problem;

  @override
  Color get color => Colors.orange;

  @override
  bool get isRecoverable => true;

  @override
  String getSuggestedAction(BuildContext context) {
    return AppLocalizations.of(context)!.tryAgain;
  }
}

/// Not found failure
class NotFoundFailure extends TypedFailure {
  const NotFoundFailure({super.message, super.metadata})
    : super(type: FailureType.notFound, statusCode: 404);

  @override
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorMessageMapper.toLocalized(
      context,
      message,
      defaultMessage: l10n.errorNotFound,
    );
  }

  @override
  IconData get icon => Icons.search_off;

  @override
  Color get color => Colors.grey;

  @override
  bool get isRecoverable => false;

  @override
  String getSuggestedAction(BuildContext context) {
    return AppLocalizations.of(context)!.errorNotFoundAction;
  }
}

/// Validation failure
class ValidationFailureTyped extends TypedFailure {
  final Map<String, dynamic>? errors;

  const ValidationFailureTyped({super.message, this.errors, super.metadata})
    : super(type: FailureType.validation, statusCode: 422);

  @override
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorMessageMapper.toLocalized(
      context,
      message,
      defaultMessage: l10n.errorValidation,
    );
  }

  @override
  IconData get icon => Icons.warning_amber;

  @override
  Color get color => Colors.amber;

  @override
  bool get isRecoverable => true;

  @override
  String getSuggestedAction(BuildContext context) {
    return AppLocalizations.of(context)!.errorValidationAction;
  }
}

/// Token expired failure
class TokenExpiredFailure extends TypedFailure {
  const TokenExpiredFailure({super.message, super.metadata})
    : super(type: FailureType.tokenExpired);

  @override
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ErrorMessageMapper.toLocalized(
      context,
      message,
      defaultMessage: l10n.errorTokenExpired,
    );
  }

  @override
  IconData get icon => Icons.timer_off;

  @override
  Color get color => Colors.orange;

  @override
  bool get isRecoverable => true;

  @override
  String getSuggestedAction(BuildContext context) {
    return AppLocalizations.of(context)!.errorTokenExpiredAction;
  }
}

/// Unknown failure
class UnknownFailure extends TypedFailure {
  const UnknownFailure({super.message, super.metadata})
    : super(type: FailureType.unknown);

  @override
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (metadata?['reason'] == 'cancelled') return l10n.error_cancelled;
    return ErrorMessageMapper.toLocalized(
      context,
      message,
      defaultMessage: l10n.errorUnknown,
    );
  }

  @override
  IconData get icon => Icons.help_outline;

  @override
  Color get color => Colors.grey;

  @override
  bool get isRecoverable => true;

  @override
  String getSuggestedAction(BuildContext context) {
    return AppLocalizations.of(context)!.tryAgain;
  }
}

/// Factory to create typed failures from status codes
class TypedFailureFactory {
  static TypedFailure fromStatusCode(
    int statusCode, {
    String? message,
    Map<String, dynamic>? metadata,
  }) {
    switch (statusCode) {
      case 401:
        return UnauthorizedFailure(message: message, metadata: metadata);
      case 403:
        return ForbiddenFailure(message: message, metadata: metadata);
      case 409:
        return ConflictFailure(message: message, metadata: metadata);
      case 404:
        return NotFoundFailure(message: message, metadata: metadata);
      case 422:
        return ValidationFailureTyped(
          message: message,
          errors: metadata?['errors'],
          metadata: metadata,
        );
      case >= 500:
        return ServerFailureTyped(
          message: message,
          statusCode: statusCode,
          metadata: metadata,
        );
      default:
        return UnknownFailure(message: message, metadata: metadata);
    }
  }

  static TypedFailure fromException(Exception exception) {
    if (exception.toString().contains('SocketException')) {
      return const NetworkFailure();
    } else if (exception.toString().contains('TimeoutException')) {
      return const TimeoutFailure();
    } else {
      return UnknownFailure(message: exception.toString());
    }
  }
}
