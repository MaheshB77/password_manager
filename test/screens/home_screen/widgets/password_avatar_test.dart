import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/screens/home_screen/widgets/password_avatar.dart';
import 'package:password_manager/shared/utils/icon_util.dart';

void main() {
  testWidgets('Should show default icon if no iconId is present',
      (tester) async {
    final Password pwd = Password(
      title: 'testTitle',
      username: 'testUsername',
      password: 'testPassword',
      categoryId: 'testCategoryId',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PasswordAvatar(password: pwd),
        ),
      ),
    );
    expect(find.image(AssetImage(IconUtil.defaultIcon.url)), findsOneWidget);
  });

  testWidgets('Should show icon according to iconId', (tester) async {
    final Password pwd = Password(
      title: 'testTitle',
      username: 'testUsername',
      password: 'testPassword',
      categoryId: 'testCategoryId',
      iconId: '3b3f84ea-581c-4aa2-9e89-4ca340cd315b', // Adobe icon id
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PasswordAvatar(password: pwd),
        ),
      ),
    );
    expect(
      find.image(const AssetImage('assets/icons/adobe.png')),
      findsOneWidget,
    );
  });
}
