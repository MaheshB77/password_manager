import 'package:flutter/material.dart';
import 'package:password_manager/constants/icons.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/utils/icon_util.dart';

class PasswordAvatar extends StatelessWidget {
  final Password password;
  const PasswordAvatar({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return password.iconId == null
        ? Image.asset(IconUtil.defaultIcon.url, width: 45)
        : Image.asset(
            IconUtil.getById(pmIcons, password.iconId!).url,
            width: 45,
          );
  }
}
