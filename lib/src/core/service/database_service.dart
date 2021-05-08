import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/attendance_records_model.dart';
import '../models/attendant_model.dart';
import '../models/available_rooms_model.dart';
import '../models/inivigilator_model.dart';
import '../models/teaching_assistant_model.dart';

class DatabaseService {
  static Database _db;

  /// database name
  static const String DB_NAME = 'coe_attendance_database.db';

  /// PROFILE_ID can be used for all tables as a unique id
  static const String PROFILE_ID = 'id';

  // All tables
  static const String ATTENDANCE_RECORDS_TABLE = 'attendance_records';
  static const String INVIGILATORS_TABLE = 'invigilators';
  static const String ATTENDANT_TABLE = 'attendants';
  static const String TEACHING_ASSISTANT_TABLE = 'teaching_assistants';
  static const String AVAILABLE_ROOMS_TABLE = 'available_rooms';

  // Available Rooms Table fields
  static const String ROOM_ALLOCATIONS = 'roomAllocations';

  // Attendance Records Table fields
  static const String NAME = 'name';
  static const String SESSION = 'session';
  static const String CATEGORY = 'category';
  static const String DURATION = 'duration';
  static const String ROOM = 'room';
  static const String DATETIME = 'dateTime';
  static const String SIGN_IMAGE_PATH = 'signImagePath';

  // Teaching Assistant Table fields
  static const String TA_NAME = 'taName';
  static const String TA_ROOM_ALLOC = 'taRoomAlloc';

  // Invigilators Table fields
  static const String INVIGI_NAME = 'invigiName';

  // Attendants Table fields
  static const String ATT_NAME = 'attName';

  //getting todays date
  String dateTime = DateTime.now().toString().split(".")[0];

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
    /// creating various database tables
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $ATTENDANCE_RECORDS_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $NAME TEXT, $SESSION TEXT, $CATEGORY TEXT, $DURATION TEXT, $ROOM TEXT, $DATETIME TEXT, $SIGN_IMAGE_PATH TEXT )");

    /// creating databases for import of names
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $INVIGILATORS_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $INVIGI_NAME TEXT )");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $ATTENDANT_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $ATT_NAME TEXT )");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $TEACHING_ASSISTANT_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $TA_NAME TEXT, $TA_ROOM_ALLOC  TEXT )");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $AVAILABLE_ROOMS_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $ROOM_ALLOCATIONS  TEXT )");

    /// return db;
  }

  // ---------------------------------------------------------------------------------
  //                      INSERT QUERIES
  // ---------------------------------------------------------------------------------
  /// insert data into the ATTENDANCE_RECORDS_TABLE
  Future<AttendanceRecordsModel> insertInvigilatorsData(
      AttendanceRecordsModel attendanceRecord) async {
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
    await dbClient.delete(TEACHING_ASSISTANT_TABLE);

    for (var item in csvData) {
      final teachingAssistant = TeachingAssistantModel(
          taName: "${item[1]}", taRoomAlloc: "${item[0]}");

      teachingAssistant.id = await dbClient.insert(
          TEACHING_ASSISTANT_TABLE, teachingAssistant.toMap());

      listOfTAs.add(teachingAssistant);
    }

    return listOfTAs;
  }

  /// insert data into the Attendants table from CSV file
  Future<List<AttendantModel>> insertAttendantCSV(String csvFilePath) async {
    List<List<dynamic>> csvData = await getCSVData(csvFilePath);

    var dbClient = await db;

    List<AttendantModel> listOfAttendants = [];

    // delete entries in attendants table
    await dbClient.delete(ATTENDANT_TABLE);

    for (var item in csvData) {
      final attendant = AttendantModel(attName: "${item[0]}");

      attendant.id = await dbClient.insert(ATTENDANT_TABLE, attendant.toMap());

      listOfAttendants.add(attendant);
    }

    return listOfAttendants;
  }

  /// insert data into the Invigilators table from CSV file
  Future<List<InvigilatorsModel>> insertInvigilatorsCSV(
      String csvFilePath) async {
    List<List<dynamic>> csvData = await getCSVData(csvFilePath);

    var dbClient = await db;

    List<InvigilatorsModel> listOfInvigilators = [];

    // delete entries in invigilators table
    await dbClient.delete(INVIGILATORS_TABLE);

    for (var item in csvData) {
      final invigilator = InvigilatorsModel(invigiName: "${item[0]}");

      invigilator.id =
          await dbClient.insert(INVIGILATORS_TABLE, invigilator.toMap());

      listOfInvigilators.add(invigilator);
    }

    return listOfInvigilators;
  }

  /// insert data into the AVAILABLE_ROOMS_TABLE table from CSV file
  Future<List<AvailableRoomsModel>> insertAvailableRoomsCSV(
      String csvFilePath) async {
    List<List<dynamic>> csvData = await getCSVData(csvFilePath);

    var dbClient = await db;

    List<AvailableRoomsModel> listOfAvailableRooms = [];

    // delete entries in available rooms table
    await dbClient.delete(AVAILABLE_ROOMS_TABLE);

    for (var item in csvData) {
      final availableRooms = AvailableRoomsModel(roomAllocations: "${item[0]}");

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

  // ---------------------------------------------------------------------------------
  //                      FETCH ALL QUERIES
  // ---------------------------------------------------------------------------------
  // get all attendance records from ATTENDANCE_RECORDS_TABLE
  Future<List<AttendanceRecordsModel>> getAllAttendanceRecords() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(ATTENDANCE_RECORDS_TABLE,
        columns: [
          PROFILE_ID,
          NAME,
          SESSION,
          CATEGORY,
          DURATION,
          ROOM,
          DATETIME,
          SIGN_IMAGE_PATH
        ],
        orderBy: "$NAME ASC");

    List<AttendanceRecordsModel> listOfRecords = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfRecords.add(AttendanceRecordsModel.fromMap(maps[i]));
      }
    }

    return listOfRecords;
  }

  /// get all Invigilators from INVIGILATORS_TABLE
  Future<List<InvigilatorsModel>> getAllInvigilators() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(INVIGILATORS_TABLE,
        columns: [PROFILE_ID, INVIGI_NAME], orderBy: "$INVIGI_NAME ASC");

    List<InvigilatorsModel> listOfInvigilators = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfInvigilators.add(InvigilatorsModel.fromMap(maps[i]));
      }
    }

    return listOfInvigilators;
  }

  /// get all Teaching Assistant from TEACHING_ASSISTANT_TABLE
  Future<List<TeachingAssistantModel>> getAllTeachingAssistants() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(TEACHING_ASSISTANT_TABLE,
        columns: [PROFILE_ID, TA_NAME, TA_ROOM_ALLOC], orderBy: "$TA_NAME ASC");

    List<TeachingAssistantModel> listOfTeachingAssistants = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfTeachingAssistants.add(TeachingAssistantModel.fromMap(maps[i]));
      }
    }

    return listOfTeachingAssistants;
  }

  /// get all Attendants from ATTENDANT_TABLE
  Future<List<AttendantModel>> getAllAttendants() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(ATTENDANT_TABLE,
        columns: [PROFILE_ID, ATT_NAME], orderBy: "$ATT_NAME ASC");

    List<AttendantModel> listOfAttendants = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfAttendants.add(AttendantModel.fromMap(maps[i]));
      }
    }

    return listOfAttendants;
  }

  /// get a Available rooms from AVAILABLE_ROOMS_TABLE
  Future<List<AvailableRoomsModel>> getAvailableRooms() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(AVAILABLE_ROOMS_TABLE, columns: [
      PROFILE_ID,
      ROOM_ALLOCATIONS,
    ]);

    List<AvailableRoomsModel> listOfRooms = [];

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfRooms.add(AvailableRoomsModel.fromMap(maps[i]));
      }
    }

    return listOfRooms;
  }

  /// ---------------------------------------------------------------------------------
  ///                      FETCH ONE QUERIES
  /// ---------------------------------------------------------------------------------
  /// get a INIVIGILATORS names from INVIGILFATORS_TABLE
  Future<List<InvigilatorsModel>> getInvigilatorNames() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(
      INVIGILATORS_TABLE,
      columns: [
        INVIGI_NAME,
      ],
    );
    List<InvigilatorsModel> listOfInvigilatorsNames = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfInvigilatorsNames.add(InvigilatorsModel.fromMap(maps[i]));
      }
    }
    return listOfInvigilatorsNames;
  }

  /// get a ATTENDANTS names from ATT_NAME
  Future<List<AttendantModel>> getAttNames() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(
      ATT_NAME,
      columns: [
        INVIGI_NAME,
      ],
    );
    List<AttendantModel> listOfAttendantNames = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfAttendantNames.add(AttendantModel.fromMap(maps[i]));
      }
    }

    return listOfAttendantNames;
  }

  /// get a TAS names from TEACHING_ASSISTANT_TABLE
  Future<List<TeachingAssistantModel>> getTasNames(
      String getTasClassroom) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(TEACHING_ASSISTANT_TABLE,
        columns: [
          TA_NAME,
        ],
        where: '$TA_ROOM_ALLOC = ?',
        whereArgs: [getTasClassroom]);
    List<TeachingAssistantModel> listOfTasNames = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfTasNames.add(TeachingAssistantModel.fromMap(maps[i]));
      }
    }

    return listOfTasNames;
  }

  // get data per day
  Future<List<AttendanceRecordsModel>> getInigilatorsPerDay() async {
    var dbClient = await db;
    String todaysDate = dateTime.split(" ")[0];
    List<Map> maps = await dbClient.query(ATTENDANCE_RECORDS_TABLE,
        columns: [
          PROFILE_ID,
          NAME,
          SESSION,
          CATEGORY,
          DURATION,
          ROOM,
          DATETIME
        ],
        where: '${DATETIME.split(".")[0].split(" ")[0]} = ?',
        whereArgs: [todaysDate],
        orderBy: "$NAME ASC");
    List<AttendanceRecordsModel> listOfTodaysRecords = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfTodaysRecords.add(AttendanceRecordsModel.fromMap(maps[i]));
      }
    }

    return listOfTodaysRecords;
  }

  // ---------------------------------------------------------------------------------
  //                      DELETE QUERIES
  // ---------------------------------------------------------------------------------
  /// delete INIVIGILATORS from ATTENDANCE_RECORDS_TABLE
  Future<int> deleteInivigilator(int id) async {
    var dbClient = await db;

    return await dbClient.delete(ATTENDANCE_RECORDS_TABLE,
        where: '$PROFILE_ID = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------------
  //                      UPDATE QUERIES
  // ---------------------------------------------------------------------------------
  /// update customer info
  Future<int> updateInivigilator(
      AttendanceRecordsModel inivigilatorModel, int id) async {
    var dbClient = await db;

    return await dbClient.update(
        ATTENDANCE_RECORDS_TABLE, inivigilatorModel.toMap(),
        where: '$PROFILE_ID = ?', whereArgs: [id]);
  }

  // --------------------------------------------------------------------------------
  //                      EXPORT DATABASE INVIGILATORS DATA
  // ---------------------------------------------------------------------------------
  /// generate csv file with ALL data from invigilators table
  Future<String> generateCSV() async {
    List<AttendanceRecordsModel> attendanceRecords;

    await getAllAttendanceRecords()
        .then((invigilators) => attendanceRecords = invigilators);

    if (attendanceRecords.isEmpty) return null;

    List<List<String>> csvData = [
      <String>[
        "ID #",
        "NAME",
        "SESSION",
        "CATEGORY",
        "DURATION",
        "ROOM",
        "DATE TIME"
      ],
      ...attendanceRecords.map((attendantRecord) => [
            "${attendantRecord.id}",
            attendantRecord.name,
            attendantRecord.session,
            attendantRecord.category,
            attendantRecord.duration,
            attendantRecord.room,
            attendantRecord.dateTime
          ])
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    String reportDate = DateTime.now().toString();

    final String dirPath = (await getExternalStorageDirectory()).path;
    final String filePath = "$dirPath/invigilators-$reportDate.csv";

    /// create file
    final File file = File(filePath);

    /// save csv file
    await file.writeAsString(csv);

    return filePath;
  }

  /// generate csv file with PER DAY data from invigilators table
//////////////////////////////////////////////////////////////////
  Future<String> generateCSVPerDay() async {
    List<AttendanceRecordsModel> attendanceRecords;

    await getAllAttendanceRecords()
        .then((invigilators) => attendanceRecords = invigilators);

    if (attendanceRecords.isEmpty) return null;

    String reportDate = DateTime.now().toString().split(" ")[0];

    List<AttendanceRecordsModel> filterByDay = attendanceRecords
        .where((attendanceRecord) =>
            attendanceRecord.dateTime.split(" ")[0] == reportDate)
        .toList();

    List<List<String>> csvData = [
      <String>[
        "ID #",
        "NAME",
        "SESSION",
        "CATEGORY",
        "DURATION",
        "ROOM",
        "DATE TIME"
      ],
      ...filterByDay.map((attendantRecord) => [
            "${attendantRecord.id}",
            attendantRecord.name,
            attendantRecord.session,
            attendantRecord.category,
            attendantRecord.duration,
            attendantRecord.room,
            attendantRecord.dateTime
          ])
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    final String dirPath = (await getExternalStorageDirectory()).path;
    final String filePath = "$dirPath/invigilators-today-$reportDate.csv";

    /// create file
    final File file = File(filePath);

    /// save csv file
    await file.writeAsString(csv);

    return filePath;
  }

  // ---------------------------------------------------------------------------------
  //                      FINALLY CLOSE DATABASE
  // ---------------------------------------------------------------------------------
  /// close database
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
