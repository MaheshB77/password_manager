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
      final cardsJson = decodedCardsJson
          .map(
            (e) => e as Map<String, dynamic>,
          )
          .toList();
      return cardsJson.map((e) => CardItem.fromMap(e)).toList();
    } catch (error) {
      throw Exception(error);
    }
  }

  bool _isJsonFile(File file) {
    String extension = p.extension(file.path);
    if (extension != '.json' && mounted) {
      SnackBarUtil.showError(
        context,
        'Please select file which ends with .json',
      );
    }
    return extension == '.json';
  }

  Future<File?> _getSelectedFile() async {
    var pickedResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (mounted) Navigator.pop(context);

    if (pickedResult != null) {
      var pickedFile = pickedResult.files.single;
      return File(pickedFile.path!);
    }

    if (mounted) SnackBarUtil.showError(context, 'No file selected !');
    return null;
  }

  Future<void> _importCards() async {
    final file = await _getSelectedFile();
    if (file == null || !_isJsonFile(file)) return;

    // TODO : Handle exception if json file does not contain desired format/values
    final cardsToImport = await _getCardsToImport(file);

    // TODO: Import card categories also
    await ref.read(cardListProvider.notifier).import(cardsToImport);

    if (!mounted) return;
    SnackBarUtil.showInfo(context, 'Cards imported successfully !');
  }

  Future<void> _importPasswords() async {
    final file = await _getSelectedFile();
    if (file == null || !_isJsonFile(file)) return;
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
                    onTap: () => _importCards(),
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: const Text('Passwords'),
                    onTap: () => _importPasswords(),
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
