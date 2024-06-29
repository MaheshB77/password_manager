import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/constants/keys.dart';
import 'package:password_manager/screens/login_screen/widgets/button.dart';
import 'package:password_manager/screens/login_screen/widgets/signin_form.dart';
import 'package:password_manager/screens/passwords_screen/passwords_screen.dart';
import 'package:password_manager/main.dart' as app;

import '../utils/test_utils.dart';

class SignInRobot {
  final WidgetTester tester;

  SignInRobot(this.tester);

  Future<void> signIn() async {
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
  }
}
