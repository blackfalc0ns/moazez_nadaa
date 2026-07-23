import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ndaaa_chat/core/interceptors/auth_interceptor.dart';
import 'package:ndaaa_chat/core/interceptors/refresh_token_interceptor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('concurrent 401 requests share one refresh', () async {
    final values = <String, String>{
      'access_token': 'old-token',
      'refresh_token': 'refresh-token',
    };
    FlutterSecureStorage.setMockInitialValues(values);
    final adapter = _RefreshAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;
    const storage = FlutterSecureStorage();
    var callbackCalls = 0;

    dio.interceptors
      ..add(AuthInterceptor(storage))
      ..add(
        RefreshTokenInterceptor(
          dio: dio,
          secureStorage: storage,
          onTokenRefreshed: (_) async {
            callbackCalls++;
            throw StateError('realtime unavailable');
          },
        ),
      );

    final responses = await Future.wait([
      dio.get('/resource/one'),
      dio.get('/resource/two'),
    ]);

    expect(responses.map((item) => item.statusCode), everyElement(200));
    expect(adapter.refreshCalls, 1);
    expect(callbackCalls, 1);
    expect(adapter.refreshAuthorization, isNull);
    expect(values['access_token'], 'new-token');
    expect(values['refresh_token'], 'rotated-token');
  });
}

class _RefreshAdapter implements HttpClientAdapter {
  int refreshCalls = 0;
  Object? refreshAuthorization;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.path == '/auth/refresh') {
      refreshCalls++;
      refreshAuthorization = options.headers['Authorization'];
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return _json(200, {
        'data': {
          'accessToken': 'new-token',
          'refreshToken': 'rotated-token',
          'expiresIn': 900,
        },
      });
    }
    if (options.headers['Authorization'] != 'Bearer new-token') {
      return _json(401, {
        'error': {'code': 'auth.token.invalid'},
      });
    }
    return _json(200, {'ok': true});
  }

  ResponseBody _json(int status, Map<String, dynamic> body) {
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
