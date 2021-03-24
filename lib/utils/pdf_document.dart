import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:coe_attendance/locator.dart';
import 'package:coe_attendance/models/attendance_records_model.dart';
import 'package:coe_attendance/service/database_service.dart';

Future<Uint8List> generatePDF() async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);
  final DatabaseService databaseService = locator<DatabaseService>();
  var dateTimeNow = DateTime.now().year;
  var dateTimeLastYear = (dateTimeNow - 1);
  List<AttendanceRecordsModel> attendanceRecords;
//Change the page orientation to landscape
  
  await databaseService
      .getAllAttendanceRecords()
      .then((invigilators) => attendanceRecords = invigilators);

  doc.addPage(
    pw.MultiPage(
        pageFormat:
            PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Text('CoE Attendance Record',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
              pw.Header(
                  level: 0,
                  title: 'CoE Attendance Record',
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: <pw.Widget>[
                        pw.Text(
                            'CoE Attendance Records For ${dateTimeLastYear.toString()}/${dateTimeNow.toString()} Academic Year',
                            textScaleFactor: 2),
                        // pw.PdfLogo()
                      ])),
              pw.Table(children: [
                pw.TableRow(
                  children: [
                    pw.Text("ID #"),
                    pw.Text("NAME"),
                    pw.Text("SESSION"),
                    pw.Text("DURATION"),
                    pw.Text("ROOM"),
                    pw.Text("DATE TIME"),
                    pw.Text("SIGNATURE")
                  ],
                ),
                ...attendanceRecords.map((attendantRecord) {
                  final File file = File(attendantRecord.signImagePath);

                  var data = file.readAsBytesSync();

                  return pw.TableRow(children: [
                    pw.Text("${attendantRecord.id}"),
                    pw.Text(attendantRecord.name),
                    pw.Text(attendantRecord.session),
                    pw.Text(attendantRecord.duration),
                    pw.Text(attendantRecord.room),
                    pw.Text(attendantRecord.dateTime),
                    pw.Image(pw.MemoryImage(data.buffer.asUint8List()))
                  ]);
                })
              ]),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Paragraph(text: 'CoE Office, @ JPbroadvision.')
            ]),
  );

  Directory documentDirectory = await getExternalStorageDirectory();

  String documentPath = documentDirectory.path;

  File file = File("$documentPath/coe-attendance.pdf");

  await file.writeAsBytes(await doc.save());

  return await doc.save();
}
