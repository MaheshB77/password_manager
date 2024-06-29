import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/constants/keys.dart';
import 'package:password_manager/db/database_service.dart';
import 'package:password_manager/screens/login_screen/login_screen.dart';
import 'package:password_manager/screens/login_screen/widgets/button.dart';
import 'package:password_manager/screens/login_screen/widgets/signup_form.dart';
import 'package:password_manager/screens/passwords_screen/passwords_screen.dart';

import '../utils/test_utils.dart';

class SignUpRobot {
  final WidgetTester tester;

  SignUpRobot(this.tester);

  Future<void> signUp() async {
    final db = DatabaseService.instance;
    await db.reset();
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(AppKeys.signUpPassword),
      TestConstants.password,
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(AppKeys.signUpConfirmPassword),
      TestConstants.password,
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(AppKeys.signUpPasswordHint),
      TestConstants.hint,
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(Button));
    await tester.tap(find.byType(Button));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(SignUpForm), findsNothing);
    expect(find.byType(PasswordsScreen), findsOne);
  }
}
