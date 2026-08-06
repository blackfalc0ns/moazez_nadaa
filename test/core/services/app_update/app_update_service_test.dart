import 'package:flutter_test/flutter_test.dart';
import 'package:ndaaa_chat/core/services/app_update/app_update_service.dart';

void main() {
  group('AppUpdateService.evaluateUpdateType', () {
    test('requires an update below the minimum supported build', () {
      expect(
        AppUpdateService.evaluateUpdateType(
          currentBuild: 2,
          minimumBuild: 3,
          latestBuild: 4,
        ),
        AppUpdateType.required,
      );
    });

    test('offers an optional update below only the latest build', () {
      expect(
        AppUpdateService.evaluateUpdateType(
          currentBuild: 3,
          minimumBuild: 3,
          latestBuild: 4,
        ),
        AppUpdateType.optional,
      );
    });

    test('does not offer an update on the latest build', () {
      expect(
        AppUpdateService.evaluateUpdateType(
          currentBuild: 4,
          minimumBuild: 3,
          latestBuild: 4,
        ),
        isNull,
      );
    });

    test('keeps defaults disabled when build targets are zero', () {
      expect(
        AppUpdateService.evaluateUpdateType(
          currentBuild: 2,
          minimumBuild: 0,
          latestBuild: 0,
        ),
        isNull,
      );
    });
  });
}
