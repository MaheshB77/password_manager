import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:password_manager/constants/keys.dart';
import 'package:password_manager/screens/password_form/widgets/password_actions.dart';

import 'robot/password_robot.dart';
import 'robot/signup_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Delete password', (tester) async {
    final signUpRobot = SignUpRobot(tester);
    final passwordRobot = PasswordRobot(tester);
    await signUpRobot.signUp();

    await passwordRobot.goToPasswordForm();
    await passwordRobot.createPassword(
      'google',
      'Work',
      'Google',
      'MaheshB76',
      'mbansode@gmail.com',
      'testpassword',
    );

    await tester.tap(find.text('Google'));
    await tester.pumpAndSettle();
    expect(find.byType(PasswordAction), findsOne);

    await tester.tap(find.byKey(AppKeys.passwordOptionButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOne);

    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    await passwordRobot.checkFallback();
  });
}