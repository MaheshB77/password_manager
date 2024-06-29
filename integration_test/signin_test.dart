import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:password_manager/constants/keys.dart';
import 'package:password_manager/screens/login_screen/widgets/button.dart';
import 'package:password_manager/main.dart' as app;
import 'package:password_manager/screens/login_screen/widgets/signin_form.dart';
import 'package:password_manager/screens/passwords_screen/passwords_screen.dart';

import 'robot/signup_robot.dart';
import 'utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test the sign-in flow', (tester) async {
    final signUpRobot = SignUpRobot(tester);
    await signUpRobot.signUp();

    await tester.pumpWidget(
      const ProviderScope(
        child: app.MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(AppKeys.signInPassword),
      TestConstants.password,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle();

    expect(find.byType(SignInForm), findsNothing);
    expect(find.byType(PasswordsScreen), findsOne);
  });
}
