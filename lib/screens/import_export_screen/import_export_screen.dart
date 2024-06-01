import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/db/database_service.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/models/card_category.dart';
import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/providers/card/card_category_provider.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:password_manager/screens/import_export_screen/utils/import_export_util.dart';
import 'package:password_manager/screens/passwords_screen/passwords_screen.dart';
import 'package:password_manager/shared/utils/snackbar_util.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImportExportScreen extends ConsumerStatefulWidget {
  const ImportExportScreen({super.key});

  @override
  ConsumerState<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends ConsumerState<ImportExportScreen> {
  AsyncValue<List<CardCategory>>? cardCategories;
  AsyncValue<List<CardItem>>? cards;

  @override
  void initState() {
    super.initState();
    ref.listenManual(cardCategoryListProvider, (previous, next) {
      cardCategories = next;
    });

    ref.listenManual(cardListProvider, (previous, next) {
      cards = next;
    });
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
                      // TODO :
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    // await _exportCards();
  }

  Future<void> _exportCards() async {
    if (cardCategories == null || cards == null) {
      SnackBarUtil.showInfo(context, 'Something went wrong!');
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/cardCategories.json');

      final cardCategoriesList = CardCategory.toJsonArray(
        cardCategories!.value,
      );

      final cardList = CardItem.toJsonArray(
        cards!.value,
      );

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
        fileName: 'cardCategories.json',
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

  void _import(BuildContext context) async {
    var pickedResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (!context.mounted) return;
    if (pickedResult != null) {
      var pickedFile = pickedResult.files.single;
      String filePath = pickedFile.path!;
      String fileType = p.extension(filePath);
      if (fileType != '.db') {
        SnackBarUtil.showError(
          context,
          'Please select file which ends with .db',
        );
        return;
      }
      await DatabaseService.instance.importDatabase(File(filePath));
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  void _showImportConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Note'),
        content: const Text('Please select the file which ends with .db'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _import(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    cardCategories = ref.watch(cardCategoryListProvider);
    cards = ref.watch(cardListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import / Export'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: const Icon(Icons.arrow_circle_up_sharp),
                title: const Text('Export'),
                onTap: () => _export(),
              ),
            ),
            Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: const Icon(Icons.arrow_circle_down_sharp),
                title: const Text('Import'),
                onTap: () {
                  _showImportConfirmation(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
