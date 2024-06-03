import 'dart:convert';
import 'dart:io';

import 'package:password_manager/models/card_item.dart';
import 'package:password_manager/models/password.dart';
import 'package:password_manager/providers/card/card_provider.dart';
import 'package:password_manager/providers/password/password_provider.dart';
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
  Future<List<CardItem>?> _getCardsToImport(File file) async {
    try {
      String fileStr = await file.readAsString();
      final decodedJson = jsonDecode(fileStr) as Map<String, dynamic>;
      final decodedCardsJson = decodedJson['cards'] as List<dynamic>;
      final cardsJson = decodedCardsJson
          .map(
            (cardMap) => CardItem.fromMap(cardMap),
          )
          .toList();
      return cardsJson;
      // return cardsJson.map((e) => CardItem.fromMap(e)).toList();
    } catch (error) {
      print('Error while parsing the cards from file : $error');
    }
    return null;
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

    final cardsToImport = await _getCardsToImport(file);
    if (cardsToImport == null && mounted) {
      SnackBarUtil.showError(
        context,
        'Please select the file which was exported',
      );
      return;
    }

    // TODO: Import card categories also
    await ref.read(cardListProvider.notifier).import(cardsToImport!);

    if (!mounted) return;
    SnackBarUtil.showInfo(context, 'Cards imported successfully !');
  }

  Future<List<Password>?> _getPasswordsToImport(File file) async {
    try {
      String fileStr = await file.readAsString();
      final decodedJson = jsonDecode(fileStr) as Map<String, dynamic>;
      final decodedPwdsJson = decodedJson['passwords'] as List<dynamic>;
      final pwdsJson = decodedPwdsJson
          .map(
            (pwdMap) => Password.fromMap(pwdMap),
          )
          .toList();
      return pwdsJson;
    } catch (error) {
      print('Error while parsing the passwords from file : $error');
    }
    return null;
  }

  Future<void> _importPasswords() async {
    final file = await _getSelectedFile();
    if (file == null || !_isJsonFile(file)) return;

    final pwdsToImport = await _getPasswordsToImport(file);
    if (pwdsToImport == null && mounted) {
      SnackBarUtil.showError(
        context,
        'Please select the file which was exported',
      );
      return;
    }

    // TODO: Import password categories also
    await ref.read(passwordProvider.notifier).import(pwdsToImport!);

    if (!mounted) return;
    SnackBarUtil.showInfo(context, 'Passwords imported successfully !');
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
