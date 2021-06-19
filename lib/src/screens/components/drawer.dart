import 'dart:async';

import 'package:coe_proctors_attendance/utils/date_time.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../utils/csv_generator.dart';
import '../../../utils/flash_helper.dart';
import '../../../utils/pdf_document.dart';
import '../../core/service/database_service.dart';
import 'toast_message.dart';

class CustomDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final DatabaseService _databaseService = locator<DatabaseService>();

  CustomDrawer(this.scaffoldKey);

  final dateTimeHelper = DateTimeHelper();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export Today's Record(PDF)"),
            onTap: () async {
              final attendanceRecords = await _databaseService
                  .getAttendanceRecordByDate(dateTimeHelper.formattedDate);

              final completer = Completer();

              generatePDF(attendanceRecords).then((filePath) {
                completer.complete();

                toastMessage(
                    scaffoldKey.currentContext, "File saved at $filePath");
              });

              FlashHelper.blockDialog(
                context,
                dismissCompleter: completer,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export Today's Record(CSV)"),
            onTap: () async {
              final attendanceRecords = await _databaseService
                  .getAttendanceRecordByDate(dateTimeHelper.formattedDate);

              final completer = Completer();

              generateCSV(attendanceRecords).then((filePath) {
                completer.complete();

                toastMessage(
                    scaffoldKey.currentContext, "File saved at $filePath");
              });

              FlashHelper.blockDialog(
                context,
                dismissCompleter: completer,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export All(PDF)"),
            onTap: () async {
              final attendanceRecords =
                  await _databaseService.getAttendanceRecords();

              final completer = Completer();

              generatePDF(attendanceRecords).then((filePath) {
                completer.complete();

                toastMessage(
                    scaffoldKey.currentContext, "File saved at $filePath");
              });

              FlashHelper.blockDialog(
                context,
                dismissCompleter: completer,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export All(CSV)"),
            onTap: () async {
              final attendanceRecords =
                  await _databaseService.getAttendanceRecords();

              final completer = Completer();

              generateCSV(attendanceRecords).then((filePath) {
                completer.complete();

                toastMessage(
                    scaffoldKey.currentContext, "File saved at $filePath");
              });

              FlashHelper.blockDialog(
                context,
                dismissCompleter: completer,
              );
            },
          ),
        ],
      ),
    );
  }
}
