import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/password/local_password_notifier.dart';

final passwordProvider =
    StateNotifierProvider<PasswordNotifierLocal, List<Password>>(
  (ref) => PasswordNotifierLocal(),
);
