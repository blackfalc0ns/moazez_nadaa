import 'package:flutter_test/flutter_test.dart';
import 'package:ndaaa_chat/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App starts from splash screen', (tester) async {
    SharedPreferences.setMockInitialValues({
      'ndaaa_chat_onboarding_seen': true,
    });

    await tester.pumpWidget(const MoazezChatApp());
    await tester.pump(const Duration(milliseconds: 2600));

    expect(find.byType(MoazezChatApp), findsOneWidget);
  });
}
