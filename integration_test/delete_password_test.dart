import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:password_manager/constants/keys.dart';
import 'package:password_manager/screens/password_form/widgets/password_actions.dart';

import 'robot/password_robot.dart';
import 'robot/signup_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Delete password', () {
    testWidgets('Delete single password', (tester) async {
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

    testWidgets('Delete multiple passwords', (tester) async {
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

      await passwordRobot.goToPasswordForm();
      await passwordRobot.createPassword(
        'bing',
        'Work',
        'Bing',
        'MaheshBNG76',
        'mbansode@bing.com',
        'testpwdbing',
      );

      await passwordRobot.goToPasswordForm();
      await passwordRobot.createPassword(
        'bitcoin',
        'Finance',
        'Bitcoin',
        'MaheshBTC76',
        'mbansode@btc.com',
        'testpwdbtc',
      );

      await tester.longPress(find.text('Google'));
      await tester.pumpAndSettle();
      await tester.longPress(find.text('Bitcoin'));
      await tester.pumpAndSettle();
      expect(find.byType(Switch), findsNothing);  // Favorites switch

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.byType(Switch), findsOne);

      await tester.longPress(find.text('Bing'));
      await tester.pumpAndSettle();
      await tester.longPress(find.text('Google'));
      await tester.pumpAndSettle();
      expect(find.byType(Switch), findsNothing);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOne);

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(Switch), findsOne);
      expect(find.text('Bing'), findsNothing);
      expect(find.text('Google'), findsNothing);
      expect(find.text('Bitcoin'), findsOne);

      await tester.pump(const Duration(seconds: 3));

    });
  });
}
