import 'dart:convert';

import '../models/dismissal_auth_session.dart';

class DismissalAuthMapper {
  const DismissalAuthMapper._();

  static Map<String, dynamic> loginPayload({
    required String email,
    required String password,
  }) {
    return {'email': email.trim().toLowerCase(), 'password': password};
  }

  static Map<String, dynamic> extractMap(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final data = map['data'];
      if (data is Map) return Map<String, dynamic>.from(data);
      return map;
    }
    return const <String, dynamic>{};
  }

  static DismissalAuthSession sessionFromJson(Map<String, dynamic> json) {
    final user = _mapFrom(json, 'user');
    final actor = user.isEmpty ? json : user;
    final membership = _mapFrom(actor, 'activeMembership');
    final accessToken = _firstNonEmpty([
      _stringFrom(json, 'accessToken'),
      _stringFrom(json, 'access_token'),
      _stringFrom(json, 'token'),
    ]);
    final tokenPayload = _decodeJwtPayload(accessToken);
    final permissions = _permissionsFrom(json).isNotEmpty
        ? _permissionsFrom(json)
        : _permissionsFrom(actor).isNotEmpty
        ? _permissionsFrom(actor)
        : _permissionsFrom(membership);

    return DismissalAuthSession(
      accessToken: accessToken,
      refreshToken: _firstNonEmpty([
        _stringFrom(json, 'refreshToken'),
        _stringFrom(json, 'refresh_token'),
      ]),
      userType: _firstNonEmpty([
        _stringFrom(json, 'userType'),
        _stringFrom(json, 'user_type'),
        _stringFrom(actor, 'userType'),
        _stringFrom(actor, 'user_type'),
        _stringFrom(tokenPayload, 'userType'),
        _stringFrom(tokenPayload, 'user_type'),
        _stringFrom(tokenPayload, 'type'),
      ]),
      userId: _firstNonEmpty([
        _stringFrom(actor, 'id'),
        _stringFrom(json, 'userId'),
        _stringFrom(json, 'user_id'),
        _stringFrom(tokenPayload, 'sub'),
      ]),
      displayName: _firstNonEmpty([
        _stringFrom(actor, 'displayName'),
        _stringFrom(actor, 'fullName'),
        _stringFrom(actor, 'full_name'),
        [
          _stringFrom(actor, 'firstName'),
          _stringFrom(actor, 'lastName'),
        ].where((part) => part.isNotEmpty).join(' '),
      ]),
      status: _firstNonEmpty([
        _stringFrom(actor, 'status'),
        _stringFrom(json, 'status'),
        'ACTIVE',
      ]),
      permissions: permissions,
      mustChangePassword:
          _boolFrom(actor, 'mustChangePassword') ??
          _boolFrom(actor, 'must_change_password') ??
          _boolFrom(json, 'mustChangePassword') ??
          _boolFrom(json, 'must_change_password') ??
          _boolFrom(tokenPayload, 'mustChangePassword') ??
          _boolFrom(tokenPayload, 'must_change_password') ??
          false,
    );
  }

  static Map<String, dynamic> sessionToJson(DismissalAuthSession session) {
    return {
      'accessToken': session.accessToken,
      'refreshToken': session.refreshToken,
      'userType': session.userType,
      'userId': session.userId,
      'displayName': session.displayName,
      'status': session.status,
      'permissions': session.permissions,
      'mustChangePassword': session.mustChangePassword,
    };
  }

  static Map<String, dynamic> _mapFrom(Map<String, dynamic> json, String key) {
    final value = json[key];
    return value is Map
        ? Map<String, dynamic>.from(value)
        : const <String, dynamic>{};
  }

  static String _stringFrom(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) return value.trim();
    if (value is num || value is bool) return value.toString();
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      for (final candidate in const ['key', 'name', 'code', 'value']) {
        final inner = map[candidate];
        if (inner is String && inner.trim().isNotEmpty) return inner.trim();
      }
    }
    return '';
  }

  static bool? _boolFrom(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }
    return null;
  }

  static String _firstNonEmpty(Iterable<String> values) {
    for (final value in values) {
      if (value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }

  static List<String> _permissionsFrom(Map<String, dynamic> json) {
    final values = <String>{};

    void collect(dynamic value) {
      if (value is String && value.contains('.')) {
        values.add(value.trim());
      } else if (value is List) {
        for (final item in value) {
          collect(item);
        }
      } else if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        for (final key in const [
          'key',
          'name',
          'code',
          'value',
          'permission',
          'permissions',
        ]) {
          if (map.containsKey(key)) collect(map[key]);
        }
      }
    }

    collect(json['permissions']);
    return values.toList(growable: false);
  }

  static Map<String, dynamic> _decodeJwtPayload(String token) {
    if (token.isEmpty) return const <String, dynamic>{};
    try {
      final parts = token.split('.');
      if (parts.length != 3) return const <String, dynamic>{};
      final raw = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decoded = jsonDecode(raw);
      return decoded is Map
          ? Map<String, dynamic>.from(decoded)
          : const <String, dynamic>{};
    } catch (_) {
      return const <String, dynamic>{};
    }
  }
}
