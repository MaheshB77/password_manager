import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/constants/keys.dart';
import 'package:password_manager/screens/password_form/password_form_screen.dart';
import 'package:password_manager/screens/password_form/widgets/icon_selector.dart';
import 'package:password_manager/screens/passwords_screen/passwords_screen.dart';
import 'package:password_manager/screens/passwords_screen/widgets/no_passwords.dart';

class PasswordRobot {
  final WidgetTester tester;

  PasswordRobot(this.tester);

  Future<void> checkFallback() async {
    expect(find.byType(NoPasswords), findsOneWidget);
    expect(find.text('No passwords added yet!'), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/images/no_passwords.png')),
      findsOne,
    );
    await tester.pumpAndSettle();
  }

  Future<void> goToPasswordForm() async {
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('New password'), findsOne);
    expect(find.byType(PasswordsScreen), findsNothing);
    expect(find.byType(PasswordFormScreen), findsOne);
  }

  Future<void> createPassword(
    String icon,
    String category,
    String title,
    String username,
    String email,
    String password,
  ) async {
    await selectIcon(icon);
    await selectCategory(category);
    await fillDetails(title, username, email, password);
    await savePassword();
  }

  Future<void> selectIcon(String brand) async {
    final imgUrl = 'assets/icons/$brand.png';

    await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(IconSelector), findsOneWidget);
    await tester.tap(
      find.image(AssetImage(imgUrl)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.check_circle_outline_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(IconSelector), findsNothing);
    expect(find.image(AssetImage(imgUrl)), findsOne);
  }

  Future<void> selectCategory(String category) async {
    expect(find.text('Other'), findsOne); // Default category
    await tester.tap(find.byKey(AppKeys.categoryDropdownKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(category));
    await tester.pumpAndSettle();
  }

  Future<void> fillDetails(
    String title,
    String username,
    String email,
    String password,
  ) async {
    await tester.enterText(find.byKey(AppKeys.titleKey), title);
    await tester.enterText(find.byKey(AppKeys.usernameKey), username);
    await tester.enterText(find.byKey(AppKeys.emailKey), email);
    await tester.enterText(find.byKey(AppKeys.passwordKey), password);
    await tester.pumpAndSettle();
  }

  Future<void> savePassword() async {
    await tester.ensureVisible(find.byKey(AppKeys.addButton));
    await tester.tap(find.byKey(AppKeys.addButton));
    await tester.pumpAndSettle();

    expect(find.byType(PasswordFormScreen), findsNothing);
    expect(find.byType(PasswordsScreen), findsOne);
  }
}
