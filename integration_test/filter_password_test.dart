import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/constants/keys.dart';
import 'package:password_manager/screens/passwords_screen/widgets/password_filter.dart';
import 'package:password_manager/screens/passwords_screen/widgets/password_tile.dart';

import 'robot/password_robot.dart';
import 'robot/signup_robot.dart';

void main() {
  group('Should test the password filters', () {
    testWidgets('Should test the search functionality', (tester) async {
      final signUpRobot = SignUpRobot(tester);
      final passwordRobot = PasswordRobot(tester);
      await signUpRobot.signUp();
      final count = await passwordRobot.createDummyPasswords();

      await tester.enterText(find.byKey(AppKeys.passwordSearchKey), 'go');
      await tester.pumpAndSettle();
      expect(find.byType(PasswordTile), findsOne);
      expect(find.text('Google'), findsOne);

      await tester.enterText(find.byKey(AppKeys.passwordSearchKey), '');
      await tester.pumpAndSettle();
      expect(find.byType(PasswordTile), findsNWidgets(count));

      await tester.enterText(find.byKey(AppKeys.passwordSearchKey), 'xy');
      await tester.pumpAndSettle();
      expect(find.byType(PasswordTile), findsNothing);
    });

    testWidgets('Should test the filters', (tester) async {
      final signUpRobot = SignUpRobot(tester);
      final passwordRobot = PasswordRobot(tester);
      await signUpRobot.signUp();
      final count = await passwordRobot.createDummyPasswords();

      await tester.tap(find.byKey(AppKeys.passwordFilterKey));
      await tester.pumpAndSettle();
      expect(find.byType(PasswordFilter), findsOne);

      await tester.tap(find.text('Work'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();
      expect(find.byType(PasswordFilter), findsNothing);
      expect(find.byType(FilterChip), findsOne);
      expect(find.text('Google'), findsOne);
      expect(find.text('Bing'), findsOne);
      expect(find.text('Bitcoin'), findsNothing);

      await tester.tap(find.byType(FilterChip));
      await tester.pumpAndSettle();
      expect(find.byType(PasswordTile), findsNWidgets(count));
      expect(find.byType(FilterChip), findsNothing);

      await tester.tap(find.byKey(AppKeys.passwordFilterKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Other'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();
      expect(find.byType(PasswordTile), findsNothing);

      await tester.pump(const Duration(seconds: 5));
    });
  });
}
