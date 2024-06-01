import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/models/category.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/card/card_category_provider.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:password_manager/providers/category/category_provider.dart';
import 'package:password_manager/providers/password/password_provider.dart';
import 'package:password_manager/screens/import_export_screen/utils/import_export_util.dart';
import 'package:password_manager/shared/utils/snackbar_util.dart';

class ExportTile extends ConsumerStatefulWidget {
  const ExportTile({super.key});

  @override
  ConsumerState<ExportTile> createState() => _ExportTileState();
}

class _ExportTileState extends ConsumerState<ExportTile> {
  AsyncValue<List<CardCategory>>? _cardCategories;
  AsyncValue<List<CardItem>>? _cards;
  List<Password>? _passwords;
  List<Category>? _passwordCategories;

  Future<void> _exportCards() async {
    if (_cardCategories == null || _cards == null) {
      SnackBarUtil.showInfo(context, 'Something went wrong!');
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/cards.json');
      final cardList = CardItem.toJsonArray(_cards!.value);
      final cardCategoriesList =
          CardCategory.toJsonArray(_cardCategories!.value);

      final encodedJson = jsonEncode(
        ImportExportUtil.cardExportFormat(
          cardCategoriesList,
          cardList,
        ),
      );

      await file.writeAsString(encodedJson);
      final bytes = await file.readAsBytes();

      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select the folder',
        fileName: 'cards.json',
        bytes: bytes,
      );

      if (!mounted) return;
      if (savedPath != null) {
        SnackBarUtil.showInfo(context, 'Successfully exported');
      } else {
        SnackBarUtil.showInfo(context, 'Export cancelled');
      }
    } catch (error) {
      print('error : $error');
      SnackBarUtil.showInfo(context, 'Something went wrong!');
    }
  }

  Future<void> _exportPasswords() async {
    if (_passwordCategories == null || _passwords == null) {
      SnackBarUtil.showInfo(context, 'Something went wrong!');
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/passwords.json');
      final passwords = Password.toJsonArray(_passwords);
      final passwordCategories = Category.toJsonArray(_passwordCategories);

      final encodedJson = jsonEncode(
        ImportExportUtil.passwordExportFormat(
          passwordCategories,
          passwords,
        ),
      );

      await file.writeAsString(encodedJson);
      final bytes = await file.readAsBytes();

      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select the folder',
        fileName: 'passwords.json',
        bytes: bytes,
      );

      if (!mounted) return;
      if (savedPath != null) {
        SnackBarUtil.showInfo(context, 'Successfully exported');
      } else {
        SnackBarUtil.showInfo(context, 'Export cancelled');
      }
    } catch (error) {
      print('error : $error');
      SnackBarUtil.showInfo(context, 'Something went wrong!');
    }
  }

  Future<void> _export() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: const Text('Cards'),
                    onTap: () async {
                      await _exportCards();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: const Text('Passwords'),
                    onTap: () async {
                      await _exportPasswords();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _cardCategories = ref.watch(cardCategoryListProvider);
    _cards = ref.watch(cardListProvider);
    _passwords = ref.watch(passwordProvider);
    _passwordCategories = ref.watch(categoryProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const Icon(Icons.arrow_circle_up_sharp),
        title: const Text('Export'),
        onTap: () => _export(),
      ),
    );
  }
}
