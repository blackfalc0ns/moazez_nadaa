import '../../../../generated/app_localizations.dart';

class DismissalNotificationContent {
  const DismissalNotificationContent({required this.title, required this.body});

  final String title;
  final String body;
}

/// Localizes the canonical dismissal messages persisted by the backend.
class DismissalNotificationLocalizer {
  const DismissalNotificationLocalizer._();

  static DismissalNotificationContent? resolve({
    required AppLocalizations l10n,
    required String type,
    required String sourceModule,
    required String rawTitle,
    required String rawBody,
  }) {
    final event = _event(type, sourceModule, rawTitle);
    if (event == null) return null;

    final childName = _childName(event, rawBody);
    final gateName = _gateName(rawBody);
    switch (event) {
      case _DismissalEvent.created:
        return DismissalNotificationContent(
          title: l10n.dismissalNotificationCreatedTitle,
          body: childName == null
              ? rawBody
              : l10n.dismissalNotificationCreatedBody(childName),
        );
      case _DismissalEvent.cancelled:
        return DismissalNotificationContent(
          title: l10n.dismissalNotificationCancelledTitle,
          body: childName == null
              ? rawBody
              : l10n.dismissalNotificationCancelledBody(childName),
        );
      case _DismissalEvent.called:
        return DismissalNotificationContent(
          title: l10n.dismissalNotificationCalledTitle,
          body: childName == null
              ? rawBody
              : l10n.dismissalNotificationCalledBody(childName),
        );
      case _DismissalEvent.ready:
        return DismissalNotificationContent(
          title: l10n.dismissalNotificationReadyTitle,
          body: childName == null || gateName == null
              ? rawBody
              : l10n.dismissalNotificationReadyBody(childName, gateName),
        );
      case _DismissalEvent.handedOver:
        return DismissalNotificationContent(
          title: l10n.dismissalNotificationCompletedTitle,
          body: childName == null
              ? rawBody
              : l10n.dismissalNotificationCompletedBody(childName),
        );
      case _DismissalEvent.expired:
        return DismissalNotificationContent(
          title: l10n.dismissalNotificationExpiredTitle,
          body: childName == null
              ? rawBody
              : l10n.dismissalNotificationExpiredBody(childName),
        );
    }
  }

  static _DismissalEvent? _event(
    String type,
    String sourceModule,
    String title,
  ) {
    final normalizedType = type.trim().toLowerCase();
    final normalizedModule = sourceModule.trim().toLowerCase();
    final normalizedTitle = title.trim().toLowerCase();
    final isDismissal =
        normalizedModule.contains('dismissal') ||
        normalizedModule.contains('smart_pickup') ||
        normalizedType.contains('dismissal') ||
        normalizedType.startsWith('request_') ||
        normalizedTitle.contains('pickup') ||
        normalizedTitle.contains('student called') ||
        normalizedTitle.contains('student ready');
    if (!isDismissal) return null;

    if (normalizedType.contains('handed_over') ||
        normalizedType.contains('completed') ||
        normalizedTitle.contains('pickup completed')) {
      return _DismissalEvent.handedOver;
    }
    if (normalizedType.contains('cancelled') ||
        normalizedTitle.contains('cancelled')) {
      return _DismissalEvent.cancelled;
    }
    if (normalizedType.contains('called') ||
        normalizedTitle.contains('called')) {
      return _DismissalEvent.called;
    }
    if (normalizedType.contains('ready') || normalizedTitle.contains('ready')) {
      return _DismissalEvent.ready;
    }
    if (normalizedType.contains('expired') ||
        normalizedTitle.contains('expired')) {
      return _DismissalEvent.expired;
    }
    if (normalizedType.contains('created') ||
        normalizedTitle.contains('new pickup')) {
      return _DismissalEvent.created;
    }
    return null;
  }

  static String? _childName(_DismissalEvent event, String body) {
    final patterns = switch (event) {
      _DismissalEvent.created => <RegExp>[
        RegExp(
          r'^A pickup request was created for (.+?)\.?$',
          caseSensitive: false,
        ),
      ],
      _DismissalEvent.cancelled => <RegExp>[
        RegExp(
          r'^A parent cancelled the pickup request for (.+?)\.?$',
          caseSensitive: false,
        ),
      ],
      _DismissalEvent.called => <RegExp>[
        RegExp(r'^(.+?) has been called for pickup\.?$', caseSensitive: false),
      ],
      _DismissalEvent.ready => <RegExp>[
        RegExp(r'^(.+?) is ready at .+?\.?$', caseSensitive: false),
      ],
      _DismissalEvent.handedOver => <RegExp>[
        RegExp(
          r'^Pickup for (.+?) has been completed\.?$',
          caseSensitive: false,
        ),
      ],
      _DismissalEvent.expired => <RegExp>[
        RegExp(
          r'^The pickup request for (.+?) expired automatically\.?$',
          caseSensitive: false,
        ),
      ],
    };
    for (final pattern in patterns) {
      final value = pattern.firstMatch(body.trim())?.group(1)?.trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  static String? _gateName(String body) {
    final value = RegExp(
      r'^.+? is ready at (.+?)\.?$',
      caseSensitive: false,
    ).firstMatch(body.trim())?.group(1)?.trim();
    return value == null || value.isEmpty ? null : value;
  }
}

enum _DismissalEvent { created, cancelled, called, ready, handedOver, expired }
