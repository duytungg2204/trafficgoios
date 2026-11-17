import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trafficgo/app/state.dart';
import 'package:trafficgo/features/onboarding/screens.dart';

void main() {
  testWidgets('Signup and login only ask for username and password', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [preferencesProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: AccountScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nickname'), findsNothing);
    expect(find.text('Tên đăng nhập (không dấu)'), findsOneWidget);
    expect(find.text('Mật khẩu (ít nhất 10 ký tự)'), findsOneWidget);
    await tester.ensureVisible(find.text('Đã có tài khoản? Đăng nhập'));
    await tester.tap(find.text('Đã có tài khoản? Đăng nhập'));
    await tester.pumpAndSettle();
    expect(find.text('Nickname'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
