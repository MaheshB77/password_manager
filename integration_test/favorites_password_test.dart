import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:password_manager/screens/passwords_screen/widgets/password_tile.dart';

import 'robot/password_robot.dart';
import 'robot/signup_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Should test favorite password functionality', (tester) async {
    final signUpRobot = SignUpRobot(tester);
    final passwordRobot = PasswordRobot(tester);
    await signUpRobot.signUp();

    final count = await passwordRobot.createDummyPasswords();
    expect(find.byIcon(Icons.star_border), findsNWidgets(count));

    await tester.tap(find.byKey(const ValueKey('password_favorite_1')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsOne);
    expect(find.byIcon(Icons.star_border), findsNWidgets(count - 1));

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.byType(PasswordTile), findsOne);
    expect(find.byIcon(Icons.star), findsOne);
    expect(find.byIcon(Icons.star_border), findsNothing);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.byType(PasswordTile), findsNWidgets(count));
    expect(find.byIcon(Icons.star), findsOne);

    await tester.tap(find.byKey(const ValueKey('password_favorite_1')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsNothing);
    expect(find.byIcon(Icons.star_border), findsNWidgets(count));

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.byType(PasswordTile), findsNothing);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.byType(PasswordTile), findsNWidgets(count));
  });
}
