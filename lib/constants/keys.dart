import 'package:flutter/material.dart';

class AppKeys {
  // Sign-up page keys
  static const Key signUpPassword = ValueKey('password');
  static const Key signUpConfirmPassword = ValueKey('confirmPassword');
  static const Key signUpPasswordHint = ValueKey('passwordHint');

  // Sign-in page keys
  static const Key signInPassword = ValueKey('password');

  // Password form screen keys
  static const Key categoryDropdownKey = ValueKey('categoryDropdownKey');
  static const Key titleKey = ValueKey('titleKey');
  static const Key usernameKey = ValueKey('usernameKey');
  static const Key emailKey = ValueKey('emailKey');
  static const Key passwordKey = ValueKey('passwordKey');
  static const Key addButton = ValueKey('addButton');
  static const Key passwordOptionButton = ValueKey('passwordOptionButton');
}
