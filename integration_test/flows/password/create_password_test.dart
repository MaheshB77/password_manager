import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:password_manager/screens/passwords_screen/widgets/password_tile.dart';

import '../../robot/password_robot.dart';
import '../../robot/signup_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Create the password', (tester) async {
    final signUpRobot = SignUpRobot(tester);
    final passwordRobot = PasswordRobot(tester);
    await signUpRobot.signUp();

    await passwordRobot.checkFallback();
    await passwordRobot.goToPasswordForm();
    await passwordRobot.createPassword(
      'google',
      'Work',
      'Google',
      'MaheshB76',
      'mbansode@gmail.com',
      'testpassword',
    );
    expect(find.byType(PasswordTile), findsOne);

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
    expect(find.text('Amazon'), findsOne);
    expect(find.text('Google'), findsOne);
  });
}
