import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:password_manager/constants/keys.dart';
import 'package:password_manager/screens/passwords_screen/widgets/password_tile.dart';

import '../../robot/password_robot.dart';
import '../../robot/signup_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Update the password', (tester) async {
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
      'amazon',
      'Shopping',
      'Amazon',
      'MaheshB77',
      'mbansode@amzn.com',
      'testpassword2',
    );
    expect(find.byType(PasswordTile), findsNWidgets(2));

    await tester.tap(find.text('Amazon'));
    await tester.pumpAndSettle();
    expect(find.text('Update password'), findsOne);
    expect(find.text('Shopping'), findsOne);  // category

    await tester.tap(find.byKey(AppKeys.categoryDropdownKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(AppKeys.titleKey), '');
    await tester.enterText(find.byKey(AppKeys.titleKey), 'Amazon 2');
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(AppKeys.usernameKey), '');
    await tester.enterText(find.byKey(AppKeys.usernameKey), 'Mahesh7696');
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(AppKeys.emailKey), '');
    await tester.enterText(find.byKey(AppKeys.emailKey), 'mbansode7696@amzn.com');
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(AppKeys.passwordKey), '');
    await tester.enterText(find.byKey(AppKeys.passwordKey), 'testpassword3');
    await tester.pumpAndSettle();

    await passwordRobot.savePassword();
    expect(find.text('Amazon 2'), findsOne);
  });
}
