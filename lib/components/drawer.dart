import 'package:coe_attendance/components/toast_message.dart';
import 'package:coe_attendance/import_attendance.dart';
import 'package:coe_attendance/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:coe_attendance/main.dart';
import 'package:coe_attendance/records.dart';

class CustomDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final DatabaseService databaseService = DatabaseService();

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
                  context, MaterialPageRoute(builder: (_) => MyHomePage()));
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
            title: Text("Export to CSV"),
            onTap: () async {
              String path = await databaseService.generateCSV();

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
