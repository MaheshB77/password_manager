import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/screens/home_screen/widgets/password_list.dart';

void main() {
  // TODO
  testWidgets('Should display all passwords', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PasswordList(),
        ),
      ),
    );
  });
}