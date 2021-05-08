import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../locator.dart';
import '../src/core/models/attendance_records_model.dart';
import '../src/core/service/database_service.dart';

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
                        pw.Text('CoE Examination Attendance',
                            textScaleFactor: 1.2),
                        pw.Text(
                          '${dateTimeLastYear.toString()}/${dateTimeNow.toString()} Academic Year',
                        ),
                      ])),
              pw.Table(
                  defaultColumnWidth: pw.IntrinsicColumnWidth(flex: 10.0),
                  border: pw.TableBorder.all(width: 1),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text("NAME"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text("SESSION"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text("DURATION"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text("ROOM"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text("DATE/TIME"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text("SIGNATURE"),
                        ),
                      ],
                    ),
                    ...attendanceRecords.map((attendantRecord) {
                      final File file = File(attendantRecord.signImagePath);

                      var data = file.readAsBytesSync();

                      return pw.TableRow(children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(attendantRecord.name,
                              style: pw.TextStyle(fontSize: 10.0)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(attendantRecord.session,
                              style: pw.TextStyle(fontSize: 10.0)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(attendantRecord.duration,
                              style: pw.TextStyle(fontSize: 10.0)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(attendantRecord.room,
                              style: pw.TextStyle(fontSize: 10.0)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(attendantRecord.dateTime,
                              style: pw.TextStyle(fontSize: 10.0)),
                        ),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Image(
                                pw.MemoryImage(data.buffer.asUint8List()))),
                      ]);
                    })
                  ]),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Paragraph(
                        text:
                            'KNUST- College of Engineering, Examination Office')
                  ])
            ]),
  );

  Directory documentDirectory = await getExternalStorageDirectory();

  String documentPath = documentDirectory.path;

  File file = File("$documentPath/coe-attendance.pdf");

  await file.writeAsBytes(await doc.save());

  return await doc.save();
}
