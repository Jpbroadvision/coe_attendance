import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/attendance_records_model.dart';
import '../models/available_rooms_model.dart';
import '../models/proctor_model.dart';
import '../models/teaching_assistant_model.dart';

class DatabaseService {
  static Database _db;

  /// database name
  static const String DB_NAME = 'coe_attendance_database.db';

  // All tables
  static const String ATTENDANCE_RECORDS_TABLE = 'attendance_records';
  static const String PROCTORS_TABLE = 'proctors';
  static const String TEACHING_ASSISTANTS_TABLE = 'teaching_assistants';
  static const String AVAILABLE_ROOMS_TABLE = 'available_rooms';

  /// [ID] field for all tables as a unique id
  static const String ID = 'id';

  /// [ROOM] field for ATTENDANCE_RECORDS_TABLE, AVAILABLE_ROOMS_TABLE and
  /// TEACHING_ASSISTANTS_TABLE,
  static const String ROOM = 'room';

  /// [NAME] field for all tables
  static const String NAME = 'name';

  /// [CATEGORY] field for ATTENDANCE_RECORDS_TABLE and PROCTOR_TABLE
  static const String CATEGORY = 'category';
  // Attendance Records Table fields
  static const String SESSION = 'session';
  static const String DURATION = 'duration';
  static const String DATE = 'date';
  static const String DATE_TIME = 'dateTime';
  static const String SIGN_IMAGE_PATH = 'signImagePath';

  /// get database
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDB();
    return _db;
  }

  /// initialize the database with DB_NAME
  initDB() async {
    Directory documentsDirectory = await getExternalStorageDirectory();
    String path = join(documentsDirectory.path, DB_NAME);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  /// creates a database table
  _onCreate(Database db, int version) async {
    // create attendance records table
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $ATTENDANCE_RECORDS_TABLE($ID INTEGER PRIMARY KEY, $NAME TEXT, $SESSION TEXT, $CATEGORY TEXT, $DURATION TEXT, $ROOM TEXT, $DATE TEXT, $DATE_TIME TEXT, $SIGN_IMAGE_PATH TEXT )");
    // create proctors table
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $PROCTORS_TABLE($ID INTEGER PRIMARY KEY, $NAME TEXT, $CATEGORY TEXT )");
    // create teaching assistants table
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $TEACHING_ASSISTANTS_TABLE($ID INTEGER PRIMARY KEY, $NAME TEXT, $ROOM TEXT )");
    // create available rooms table
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $AVAILABLE_ROOMS_TABLE($ID INTEGER PRIMARY KEY, $ROOM TEXT )");

    // return db;
  }

  /// insert data into the ATTENDANCE_RECORDS_TABLE
  Future<AttendanceRecordModel> addAttendanceRecord(
      AttendanceRecordModel attendanceRecord) async {
    var dbClient = await db;

    attendanceRecord.id = await dbClient.insert(
        ATTENDANCE_RECORDS_TABLE, attendanceRecord.toMap());

    return attendanceRecord;
  }

  /// insert data into the Teaching Assistant table from CSV file
  Future<List<TeachingAssistantModel>> insertTeachingAssistantsCSV(
      String csvFilePath) async {
    List<List<dynamic>> csvData = await getCSVData(csvFilePath);

    var dbClient = await db;

    List<TeachingAssistantModel> listOfTAs = [];

    // delete entries in teaching assistant table
    await dropTeachingAssistantsTable();

    for (var item in csvData) {
      final teachingAssistant =
          TeachingAssistantModel(name: "${item[1]}", room: "${item[0]}");

      teachingAssistant.id = await dbClient.insert(
          TEACHING_ASSISTANTS_TABLE, teachingAssistant.toMap());

      listOfTAs.add(teachingAssistant);
    }

    return listOfTAs;
  }

  /// insert data into the Proctors table from CSV file
  Future<List<ProctorModel>> insertProctorsCSV(String csvFilePath) async {
    List<List<dynamic>> csvData = await getCSVData(csvFilePath);

    var dbClient = await db;

    List<ProctorModel> listOfProctors = [];

    // delete entries in Proctors table
    await dropProctorsTable();

    for (var item in csvData) {
      final proctor = ProctorModel(name: "${item[0]}", category: "${item[1]}");

      proctor.id = await dbClient.insert(PROCTORS_TABLE, proctor.toMap());

      listOfProctors.add(proctor);
    }

    return listOfProctors;
  }

  /// insert data into the AVAILABLE_ROOMS_TABLE table from CSV file
  Future<List<AvailableRoomsModel>> insertAvailableRoomsCSV(
      String csvFilePath) async {
    List<List<dynamic>> csvData = await getCSVData(csvFilePath);

    var dbClient = await db;

    List<AvailableRoomsModel> listOfAvailableRooms = [];

    // delete entries in available rooms table
    await dropRoomsTable();

    for (var item in csvData) {
      final availableRooms = AvailableRoomsModel(room: "${item[0]}");

      availableRooms.id =
          await dbClient.insert(AVAILABLE_ROOMS_TABLE, availableRooms.toMap());

      listOfAvailableRooms.add(availableRooms);
    }

    return listOfAvailableRooms;
  }

  /// helper function to get a CSV file data from a given path
  Future<List<List<dynamic>>> getCSVData(String csvFilePath) async {
    final csvFileInput = File(csvFilePath).openRead();

    List<List<dynamic>> csvData = await csvFileInput
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();

    return csvData;
  }

  /// delete entries in teaching assistant table
  Future<int> dropTeachingAssistantsTable() async {
    var dbClient = await db;

    return await dbClient.delete(TEACHING_ASSISTANTS_TABLE);
  }

  /// delete entries in Proctors table
  Future<int> dropProctorsTable() async {
    var dbClient = await db;

    return await dbClient.delete(PROCTORS_TABLE);
  }

  /// delete entries in available rooms table
  Future<int> dropRoomsTable() async {
    var dbClient = await db;

    return await dbClient.delete(AVAILABLE_ROOMS_TABLE);
  }

  /// get all attendance records from ATTENDANCE_RECORDS_TABLE
  Future<List<AttendanceRecordModel>> getAttendanceRecords() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(ATTENDANCE_RECORDS_TABLE,
        columns: [
          ID,
          NAME,
          SESSION,
          CATEGORY,
          DURATION,
          ROOM,
          DATE,
          DATE_TIME,
          SIGN_IMAGE_PATH
        ],
        orderBy: "$NAME ASC");

    List<AttendanceRecordModel> listOfRecords = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfRecords.add(AttendanceRecordModel.fromMap(maps[i]));
      }
    }

    return listOfRecords;
  }

  /// get all attendance records from ATTENDANCE_RECORDS_TABLE by category
  Future<List<AttendanceRecordModel>> getAttendanceRecordsByCategory(String category) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(ATTENDANCE_RECORDS_TABLE,
        columns: [
          ID,
          NAME,
          SESSION,
          CATEGORY,
          DURATION,
          ROOM,
          DATE,
          DATE_TIME,
          SIGN_IMAGE_PATH
        ], where: '$CATEGORY = ?',
        whereArgs: [category],
        orderBy: "$NAME ASC");

    List<AttendanceRecordModel> listOfRecords = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfRecords.add(AttendanceRecordModel.fromMap(maps[i]));
      }
    }

    return listOfRecords;
  }

  /// get all attendance records by date from ATTENDANCE_RECORDS_TABLE
  Future<List<AttendanceRecordModel>> getAttendanceRecordsByDate(
      String date) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(ATTENDANCE_RECORDS_TABLE,
        columns: [
          ID,
          NAME,
          SESSION,
          CATEGORY,
          DURATION,
          ROOM,
          DATE,
          DATE_TIME,
          SIGN_IMAGE_PATH
        ],
        where: '$DATE = ?',
        whereArgs: [date],
        orderBy: "$NAME ASC");

    List<AttendanceRecordModel> listOfRecords = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfRecords.add(AttendanceRecordModel.fromMap(maps[i]));
      }
    }

    return listOfRecords;
  }

  /// get all Proctors from PROCTORS_TABLE
  Future<List<ProctorModel>> getProctors() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(PROCTORS_TABLE,
        columns: [ID, NAME, CATEGORY], orderBy: "$NAME ASC");

    List<ProctorModel> listOfProctors = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfProctors.add(ProctorModel.fromMap(maps[i]));
      }
    }

    return listOfProctors;
  }

  /// get all Teaching Assistant from TEACHING_ASSISTANTS_TABLE
  Future<List<TeachingAssistantModel>> getTeachingAssistants() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(TEACHING_ASSISTANTS_TABLE,
        columns: [ID, NAME, ROOM], orderBy: "$NAME ASC");

    List<TeachingAssistantModel> listOfTeachingAssistants = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfTeachingAssistants.add(TeachingAssistantModel.fromMap(maps[i]));
      }
    }

    return listOfTeachingAssistants;
  }

  /// get all available rooms from AVAILABLE_ROOMS_TABLE
  Future<List<AvailableRoomsModel>> getAvailableRooms() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(AVAILABLE_ROOMS_TABLE, columns: [
      ID,
      ROOM,
    ]);

    List<AvailableRoomsModel> listOfRooms = [];

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfRooms.add(AvailableRoomsModel.fromMap(maps[i]));
      }
    }

    return listOfRooms;
  }

  /// get a proctor from PROCTOR_TABLE
  Future<ProctorModel> getProctorById(int id) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(
      PROCTORS_TABLE,
      columns: [
        ID,
        CATEGORY,
        NAME,
      ],
    );

    if (maps.length > 0) {
      return ProctorModel.fromMap(maps.first);
    }
    return null;
  }

  /// get all teaching assistants based on room allocated from TEACHING_ASSISTANTS_TABLE
  Future<List<TeachingAssistantModel>> getTeachingAssistantByRoomAllocated(
      String room) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(TEACHING_ASSISTANTS_TABLE,
        columns: [ID, NAME, ROOM], where: '$ROOM = ?', whereArgs: [room]);

    List<TeachingAssistantModel> teachingAssistantList = [];

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        teachingAssistantList.add(TeachingAssistantModel.fromMap(maps[i]));
      }
    }

    return teachingAssistantList;
  }

  /// get all teaching assistants based on room allocated from TEACHING_ASSISTANTS_TABLE
  Future<TeachingAssistantModel> getTeachingAssistantById(int id) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(TEACHING_ASSISTANTS_TABLE,
        columns: [ID, NAME, ROOM], where: '$ID = ?', whereArgs: [id]);

    if (maps.length > 0) {
      return TeachingAssistantModel.fromMap(maps.first);
    }

    return null;
  }

  // get attendant record
  Future<AttendanceRecordModel> getAttendantRecordById(int id) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(ATTENDANCE_RECORDS_TABLE,
        columns: [
          ID,
          NAME,
          SESSION,
          CATEGORY,
          DURATION,
          ROOM,
          DATE,
          DATE_TIME,
          SIGN_IMAGE_PATH
        ],
        where: '$ID = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return AttendanceRecordModel.fromMap(maps.first);
    }
    return null;
  }

  /// get all attendance record by date
  Future<List<AttendanceRecordModel>> getAttendanceRecordByDate(
      String date) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(ATTENDANCE_RECORDS_TABLE,
        columns: [
          ID,
          NAME,
          SESSION,
          CATEGORY,
          DURATION,
          ROOM,
          DATE,
          DATE_TIME,
          SIGN_IMAGE_PATH
        ],
        where: '$DATE = ?',
        whereArgs: [date],
        orderBy: "$NAME ASC");

    List<AttendanceRecordModel> listOfTodaysRecords = [];

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfTodaysRecords.add(AttendanceRecordModel.fromMap(maps[i]));
      }
    }

    return listOfTodaysRecords;
  }

  /// delete record from ATTENDANCE_RECORDS_TABLE by id
  Future<int> deleteAttendanceRecordById(int id) async {
    var dbClient = await db;

    // get attendant record with id
    final result = await getAttendantRecordById(id);

    if (result == null) {
      throw Exception();
    }

    // delete image file
    await deleteFile(result.signImagePath);

    return await dbClient
        .delete(ATTENDANCE_RECORDS_TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  /// delete file with filePath
  Future<int> deleteFile(String filePath) async {
    try {
      final file = File(filePath);

      await file.delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> countAttendanceRecords() async {
    final result = await getAttendanceRecords();

    return result.length;
  }

  Future<int> countInvigilatorRecords() async {
    final result = await getAttendanceRecords();

    return result
        .where((record) => record.category == 'Invigilator')
        .toList()
        .length;
  }

  Future<int> countAttendantRecords() async {
    final result = await getAttendanceRecords();

    return result
        .where((record) => record.category == 'Attendant')
        .toList()
        .length;
  }

  Future<int> countTARecords() async {
    final result = await getAttendanceRecords();

    return result
        .where((record) => record.category == 'Teaching Assistant')
        .toList()
        .length;
  }

  Future<int> countOtherRecords() async {
    final result = await getAttendanceRecords();

    return result.where((record) => record.category == 'Other').toList().length;
  }

  Future<int> countRooms() async {
    final result = await getAvailableRooms();

    return result.length;
  }

  /// update attendance record by id
  Future<int> updateAttendanceRecord(
      AttendanceRecordModel attendanceRecord, int id) async {
    var dbClient = await db;

    return await dbClient.update(
        ATTENDANCE_RECORDS_TABLE, attendanceRecord.toMap(),
        where: '$ID = ?', whereArgs: [id]);
  }

  /// close database
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
