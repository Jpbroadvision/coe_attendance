import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../utils/pdf_document.dart';
import '../../core/service/database_service.dart';
import '../views/import_attendance.dart';
import '../views/records.dart';
import '../views/home.dart';
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
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Records"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Records()));
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export Today's Entries"),
            onTap: () async {
              String path = await _databaseService.generateCSVPerDay();

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
            title: Text("Export All to CSV"),
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
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export PDF"),
            onTap: () async {
              await generatePDF();
              toastMessage(
                  scaffoldKey.currentContext, "File saved successfully.");
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Import from CSV"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ImportAttendance()));
            },
          )
        ],
      ),
    );
  }
}
