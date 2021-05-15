import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import '../src/core/models/attendance_records_model.dart';

/// generate csv file from attendance record table
Future<String> generateCSV(
    List<AttendanceRecordModel> attendanceRecords) async {
  List<List<String>> csvData = [
    <String>["ID #", "NAME", "SESSION", "CATEGORY", "DURATION", "ROOM", "DATE"],
    ...attendanceRecords.map((attendantRecord) => [
          "${attendantRecord.id}",
          attendantRecord.name,
          attendantRecord.session,
          attendantRecord.category,
          attendantRecord.duration,
          attendantRecord.room,
          attendantRecord.date
        ])
  ];

  String csv = const ListToCsvConverter().convert(csvData);

  final String dirPath = (await getExternalStorageDirectory()).path;
  final String filePath = "$dirPath/coe-attendance-${DateTime.now().toString()}.csv";

  // create file
  final File file = File(filePath);

  // save csv file
  await file.writeAsString(csv);

  return filePath;
}
