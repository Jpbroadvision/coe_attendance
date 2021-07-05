import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../src/core/models/attendance_records_model.dart';

Future<String> generatePDF(
    List<AttendanceRecordModel> attendanceRecords) async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);
  final dateTimeNow = DateTime.now().year;
  final dateTimeLastYear = (dateTimeNow - 1);

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
                    bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey))),
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
                  pw.Text('CoE Examination Attendance', textScaleFactor: 1.2),
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
                  child: pw.Text("DATE"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(2),
                  child: pw.Text("SIGNATURE"),
                ),
              ],
            ),
            ...attendanceRecords.map(
              (attendantRecord) {
                final File file = File(attendantRecord.signImagePath);

                var data = file.readAsBytesSync();

                return pw.TableRow(
                  children: [
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
                  ],
                );
              },
            )
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Paragraph(
                text: 'KNUST- College of Engineering, Examination Office')
          ],
        )
      ],
    ),
  );

  String dirPath = (await getExternalStorageDirectory()).path;
  final String filePath =
      "$dirPath/coe-attendance-${DateTime.now().toString()}.pdf";

  File file = File(filePath);

  await file.writeAsBytes(await doc.save());

  await doc.save();

  return filePath;
}
