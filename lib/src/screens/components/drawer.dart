import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/csv_generator.dart';
import '../../../utils/flash_helper.dart';
import '../../../utils/pdf_document.dart';
import '../providers/service_providers.dart';
import 'toast_message.dart';

class CustomDrawer extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  CustomDrawer(this.scaffoldKey);


  @override
  Widget build(BuildContext context, ScopedReader watch) {

    final dbService = watch (dbServiceProvider);
    final datetimeHelper = watch (datetimeHelperProvider);
    
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Export Today's Record(PDF)"),
            onTap: () async {
              final attendanceRecords = await dbService
                  .getAttendanceRecordByDate(datetimeHelper.formattedDate);

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
              final attendanceRecords =  await dbService
                  .getAttendanceRecordByDate(datetimeHelper.formattedDate);

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
                  await dbService.getAttendanceRecords();

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
                  await dbService.getAttendanceRecords();

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
