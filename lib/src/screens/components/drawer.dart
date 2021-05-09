import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../utils/date_time.dart';
import '../../../utils/pdf_document.dart';
import '../../core/service/database_service.dart';
import 'toast_message.dart';

class CustomDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final DatabaseService _databaseService = locator<DatabaseService>();

  CustomDrawer(this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                leading: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export Today's Record(PDF)"),
            onTap: () async {
              final dateTimeHelper = DateTimeHelper();
              String path = await _databaseService
                  .generateCSV(dateTimeHelper.formattedDate);

              String message = "Failed to export your daily entries";

              if (path == null)
                toastMessage(scaffoldKey.currentContext, message, Colors.red);
              else {
                message = "File saved at $path";
                toastMessage(scaffoldKey.currentContext, message);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export Today's Record(CSV)"),
            onTap: () async {
              final dateTimeHelper = DateTimeHelper();
              String path = await _databaseService
                  .generateCSV(dateTimeHelper.formattedDate);

              String message = "Failed to export your daily entries";

              if (path == null)
                toastMessage(scaffoldKey.currentContext, message, Colors.red);
              else {
                message = "File saved at $path";
                toastMessage(scaffoldKey.currentContext, message);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export All(PDF)"),
            onTap: () async {
              await generatePDF();
              toastMessage(
                  scaffoldKey.currentContext, "File saved successfully.");
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export All(CSV)"),
            onTap: () async {
              String path =
                  await _databaseService.generateCSV(); //generateCSVPerDay

              String message = "Failed to generate CSV file";

              if (path == null)
                toastMessage(scaffoldKey.currentContext, message, Colors.red);
              else {
                message = "File saved at $path";
                toastMessage(scaffoldKey.currentContext, message);
              }
            },
          ),
        ],
      ),
    );
  }
}
