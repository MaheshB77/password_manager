import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_manager/db/database_service.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/screens/import_export_screen/widgets/export_tile.dart';
import 'package:password_manager/screens/passwords_screen/passwords_screen.dart';
import 'package:password_manager/shared/utils/snackbar_util.dart';
import 'package:path/path.dart' as p;

class ImportExportScreen extends ConsumerStatefulWidget {
  const ImportExportScreen({super.key});

  @override
  ConsumerState<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends ConsumerState<ImportExportScreen> {

  void _import() async {
    var pickedResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (!mounted) return;
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
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  void _showImportConfirmation() {
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
              _import();
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
            const ExportTile(),
            Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: const Icon(Icons.arrow_circle_down_sharp),
                title: const Text('Import'),
                onTap: () {
                  _showImportConfirmation();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
