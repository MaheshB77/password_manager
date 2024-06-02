import 'dart:convert';
import 'dart:io';

import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:path/path.dart' as p;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/shared/utils/snackbar_util.dart';

class ImportTile extends ConsumerStatefulWidget {
  const ImportTile({super.key});

  @override
  ConsumerState<ImportTile> createState() => _ImportTileState();
}

class _ImportTileState extends ConsumerState<ImportTile> {
  Future<List<CardItem>> _getCardsToImport(File file) async {
    try {
      String fileStr = await file.readAsString();
      final decodedJson = jsonDecode(fileStr) as Map<String, dynamic>;
      final decodedCardsJson = decodedJson['cards'] as List<dynamic>;
      final cardsJson =
          decodedCardsJson.map((e) => e as Map<String, dynamic>).toList();
      return cardsJson.map((e) => CardItem.fromMap(e)).toList();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> _importCards() async {
    var pickedResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (pickedResult != null) {
      var pickedFile = pickedResult.files.single;
      String filePath = pickedFile.path!;
      String fileType = p.extension(filePath);
      if (fileType != '.json') {
        SnackBarUtil.showError(
          context,
          'Please select file which ends with .json',
        );
        return;
      }
      final file = File(filePath);
      final cardsToImport = await _getCardsToImport(file);

      // TODO: Only importing cards and not the card categories
      await ref.read(cardListProvider.notifier).import(cardsToImport);

      if (!mounted) return;
      SnackBarUtil.showInfo(context, 'Cards imported successfully !');
    }
  }

  Future<void> _import() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Import'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: const Text('Cards'),
                    onTap: () async {
                      await _importCards();
                      // if (!context.mounted) return;
                      // Navigator.pop(context);
                    },
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: const Text('Passwords'),
                    onTap: () async {
                      // await _exportPasswords();
                      // if (!context.mounted) return;
                      // Navigator.pop(context);
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const Icon(Icons.arrow_circle_down_sharp),
        title: const Text('Import'),
        onTap: () => _import(),
      ),
    );
  }
}
