import 'dart:io';
import 'package:password_manager/db/database_service.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
