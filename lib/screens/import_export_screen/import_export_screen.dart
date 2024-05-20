import 'dart:io';
import 'package:password_manager/db/database_service.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/screens/home_screen/home_screen.dart';
import 'package:password_manager/shared/utils/snackbar_util.dart';
import 'package:path/path.dart' as p;

class ImportExportScreen extends StatelessWidget {
  const ImportExportScreen({super.key});

  void _export(BuildContext context) async {
    File backupFile = await DatabaseService.instance.getDatabaseBackup();
    var backupBytes = await backupFile.readAsBytes();

    await FilePicker.platform.saveFile(
      dialogTitle: 'Please select the folder',
      fileName: 'backup.db',
      bytes: backupBytes,
    );
    if (!context.mounted) return;
    SnackBarUtil.showInfo(context, 'Successfully exported');
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
                onTap: () {
                  _export(context);
                },
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
