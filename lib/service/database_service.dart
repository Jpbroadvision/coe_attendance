import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/inivigilators_details_model.dart';

class DatabaseService {
  static Database _db;
  static const String DB_NAME =
      'inivigilators_database.db'; // database invigiName
  // INIVIGILATORS_ID can be used for all tables as a foreign key
  static const String INIVIGILATORS_ID = 'inivigilatorId';

  // Invigilators Table
  static const String INVIGILATORS_TABLE = 'Invigilators';
  static const String INVIGI_NAMES_TABLE = 'invigi_names_table';
  static const String ATT_NAMES_TABLE = 'att_names_table';
  static const String TA_NAMES_TABLE = 'ta_names_table';
  static const String PROFILE_ID = 'id';
  static const String INVIGI_NAME = 'invigiName';
  static const String ATT_NAME = 'attName';
  static const String TA_NAME = 'taName';
  static const String SESSION = 'session';
  static const String CATEGORY = 'category';
  static const String DURATION = 'duration';
  static const String ROOM = 'room';
  static const String TA_ROOM_ALLOC = 'taRoomAlloc';
  static const String DATETIME = 'dateTime';
  static const String SIGN_IMAGE = 'signImage';

  // signatures parameters declarations ENDS
  final _sign = GlobalKey<SignatureState>();
  // signatures parameters declarations ENDS

  // get database
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDB();
    return _db;
  }

  // initialize the database with DB_NAME
  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // creates a database table
  _onCreate(Database db, int version) async {
    // creating various database tables
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $INVIGILATORS_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $INVIGI_NAME TEXT, $SESSION TEXT, $CATEGORY TEXT, $DURATION TEXT, $ROOM TEXT, $DATETIME TEXT, $SIGN_IMAGE TEXT )");
    // creating databases for import of names
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $INVIGI_NAMES_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $INVIGI_NAME TEXT )");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $ATT_NAMES_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $ATT_NAME TEXT )");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $TA_NAMES_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $TA_NAME TEXT, $TA_ROOM_ALLOC  TEXT )");
    // return db;
  }

  // ---------------------------------------------------------------------------------
  //                      INSERT QUERIES
  // ---------------------------------------------------------------------------------
  // insert data into the INVIGILATORS_TABLE
  Future<InvigilatorsDetailsModel> insertInvigilatorsData(
      InvigilatorsDetailsModel inivigilatorModel) async {
    var dbClient = await db;
    inivigilatorModel.id =
        await dbClient.insert(INVIGILATORS_TABLE, inivigilatorModel.toMap());

    return inivigilatorModel;

    // another way
    // await dbClient.transaction((txn) async {
    //   var query =
    //       "INSERT INTO $TABLE($INVIGI_NAME) VALUES ('" + inivigilatorModel.invigiName + "')";
    //   return await txn.rawInsert(query);
    // });
  }

  // INVIGI_NAMES_TABLE
  // ATT_NAMES_TABLE
  // TA_NAMES_TABLE
  // insert data into the INVIGI_NAMES_TABLE from excel
  Future<InvigiNamesModel> insertInvigiNames(
      InvigiNamesModel inivigiNames) async {
    var dbClient = await db;
    inivigiNames.id =
        await dbClient.insert(INVIGI_NAMES_TABLE, inivigiNames.toMap());

    return inivigiNames;
  }

  Future<AttNamesModel> insertAttNames(AttNamesModel attNames) async {
    var dbClient = await db;
    attNames.id = await dbClient.insert(ATT_NAMES_TABLE, attNames.toMap());

    return attNames;
  }

  Future<TaNamesModel> insertInvigiNames(TaNamesModel taNames) async {
    var dbClient = await db;
    taNames.id = await dbClient.insert(TA_NAMES_TABLE, taNames.toMap());

    return taNames;
  }

  // ---------------------------------------------------------------------------------
  //                      FETCH ALL QUERIES
  // ---------------------------------------------------------------------------------
  // get all iNVIGILATORS from INVIGILATORS_TABLE
  Future<List<InvigilatorsDetailsModel>> getAllInvigilators() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(INVIGILATORS_TABLE,
        columns: [
          PROFILE_ID,
          INVIGI_NAME,
          SESSION,
          CATEGORY,
          DURATION,
          ROOM,
          DATETIME,
          SIGN_IMAGE
        ],
        orderBy: "$INVIGI_NAME ASC"); // similar to...
    // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");

    List<InvigilatorsDetailsModel> listOfInvigilators = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfInvigilators.add(InvigilatorsDetailsModel.fromMap(maps[i]));
      }
    }

    return listOfInvigilators;
  }

  // get delivery by inivigilatorId from DELIVERIES_TABLE
  // Future<List<DeliveryModel>> getAllDeliveriesByCustomerId(
  //     int inivigilatorId) async {
  //   var dbClient = await db;

  //   List<Map> maps = await dbClient.query(DELIVERIES_TABLE,
  //       columns: [
  //         DELIVERY_ID,
  //         INIVIGILATORS_ID,
  //         TOTAL_PRICE,
  //         SMALL_BREAD_QTY,
  //         BIG_BREAD_QTY,
  //         BIGGER_BREAD_QTY,
  //         BIGGEST_BREAD_QTY,
  //         ROUND_BREAD_QTY,
  //         DELIVERY_DATE,
  //       ],
  //       where: '$INIVIGILATORS_ID = ?',
  //       whereArgs: [inivigilatorId]);

  //   List<DeliveryModel> listOfDeliveries = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       listOfDeliveries.add(DeliveryModel.fromMap(maps[i]));
  //     }
  //   }

  //   return listOfDeliveries;
  // }

  // ---------------------------------------------------------------------------------
  //                      FETCH ONE QUERIES
  // ---------------------------------------------------------------------------------
  // get a INIVIGILATORS from INVIGILATORS_TABLE TO DELETE
  Future<InvigilatorsDetailsModel> getInvigilator(int id) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(INVIGILATORS_TABLE,
        columns: [
          PROFILE_ID,
          INVIGI_NAME,
          SESSION,
          CATEGORY,
          DURATION,
          ROOM,
          DATETIME,
          SIGN_IMAGE
        ],
        where: '$PROFILE_ID = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return InvigilatorsDetailsModel.fromMap(maps.first);
    }

    return null;
  }

  // ---------------------------------------------------------------------------------
  //                      DELETE QUERIES
  // ---------------------------------------------------------------------------------
  // delete INIVIGILATORS from INVIGILATORS_TABLE
  Future<int> deleteInivigilator(int id) async {
    var dbClient = await db;

    return await dbClient
        .delete(INVIGILATORS_TABLE, where: '$PROFILE_ID = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------------
  //                      UPDATE QUERIES
  // ---------------------------------------------------------------------------------
  // update customer info
  Future<int> updateInivigilator(
      InvigilatorsDetailsModel inivigilatorModel, int id) async {
    var dbClient = await db;

    return await dbClient.update(INVIGILATORS_TABLE, inivigilatorModel.toMap(),
        where: '$PROFILE_ID = ?', whereArgs: [id]);
  }

  // --------------------------------------------------------------------------------
  //                      EXPORT DATABASE INVIGILATORS DATA
  // ---------------------------------------------------------------------------------
  // generate csv file with data from invigilators table
  Future<String> generateCSV() async {
    List<InvigilatorsDetailsModel> invigilatorsDetails;

    await getAllInvigilators()
        .then((invigilators) => invigilatorsDetails = invigilators);

    if (invigilatorsDetails.isEmpty) return null;

    // signatures parameters declarations ENDS
    // final sign = _sign.currentState;
    // final image = await sign.getData();
    // var data = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List _realImage;
    // signatures parameters declarations ENDS

    List<List<String>> csvData = [
      <String>[
        "PROFILE ID",
        "INVIGI_NAME",
        "SESSION",
        "CATEGORY",
        "DURATION",
        "ROOM",
        "DATE TIME",
        "SIGNATURE"
      ],
      ...invigilatorsDetails.map((invigilator) => [
            "${invigilator.id}",
            invigilator.invigiName,
            invigilator.session,
            invigilator.category,
            invigilator.duration,
            invigilator.room,
            invigilator.dateTime,
            "${Base64Decoder().convert(invigilator.signImage)}"
          ])
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    String reportDate = DateTime.now().toString();

    final String dirPath = (await getExternalStorageDirectory()).path;
    final String filePath = "$dirPath/invigilators-$reportDate.csv";

    // create file
    final File file = File(filePath);
    // save csv file
    await file.writeAsString(csv);

    return filePath;
  }

  // ---------------------------------------------------------------------------------
  //                      FINALLY CLOSE DATABASE
  // ---------------------------------------------------------------------------------
  // close database
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
