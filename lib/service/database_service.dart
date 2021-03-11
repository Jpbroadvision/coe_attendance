import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'dart:ui' as ui;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/inivigilators_details_model.dart';

class DatabaseService {
  static Database _db;
  static const String DB_NAME = 'inivigilators_database.db'; // database name
  // INIVIGILATORS_ID can be used for all tables as a foreign key
  static const String INIVIGILATORS_ID = 'inivigilatorId';

  // Invigilators Table
  static const String INIVIGILATORS_TABLE = 'Invigilators';
  static const String PROFILE_ID = 'id';
  static const String NAME = 'name';
  static const String SESSION = 'session';
  static const String START_TIME = 'startTime';
  static const String END_TIME = 'endTime';
  static const String ROOM = 'room';
  static const String DAY = 'day';
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
        "CREATE TABLE $INIVIGILATORS_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $NAME TEXT, $SESSION TEXT, $START_TIME TEXT, $END_TIME TEXT, $ROOM TEXT, $DAY TEXT, $DATETIME TEXT, $SIGN_IMAGE BLOOB )");
    // return db;
  }

  // ---------------------------------------------------------------------------------
  //                      INSERT QUERIES
  // ---------------------------------------------------------------------------------
  // insert data into the INIVIGILATORS_TABLE
  Future<InvigilatorsDetailsModel> insertInvigilatorsData(
      InvigilatorsDetailsModel inivigilatorModel) async {
    var dbClient = await db;
    inivigilatorModel.id =
        await dbClient.insert(INIVIGILATORS_TABLE, inivigilatorModel.toMap());

    return inivigilatorModel;

    // another way
    // await dbClient.transaction((txn) async {
    //   var query =
    //       "INSERT INTO $TABLE($NAME) VALUES ('" + inivigilatorModel.name + "')";
    //   return await txn.rawInsert(query);
    // });
  }

  // insert data into the DELIVERIES_TABLE
  // Future<DeliveryModel> insertDeliveryData(DeliveryModel deliveryModel) async {
  //   var dbClient = await db;
  //   deliveryModel.id =
  //       await dbClient.insert(DELIVERIES_TABLE, deliveryModel.toMap());

  //   return deliveryModel;
  // }

  // insert data into the PAYMENTS_TABLE
  // Future<PaymentModel> insertPaymentData(PaymentModel paymentModel) async {
  //   var dbClient = await db;
  //   paymentModel.id =
  //       await dbClient.insert(PAYMENTS_TABLE, paymentModel.toMap());

  //   return paymentModel;
  // }

  // ---------------------------------------------------------------------------------
  //                      FETCH ALL QUERIES
  // ---------------------------------------------------------------------------------
  // get all iNVIGILATORS from INIVIGILATORS_TABLE
  Future<List<InvigilatorsDetailsModel>> getAllInvigilators() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(INIVIGILATORS_TABLE,
        columns: [
          PROFILE_ID,
          NAME,
          SESSION,
          START_TIME,
          END_TIME,
          ROOM,
          DAY,
          DATETIME,
          SIGN_IMAGE
        ],
        orderBy: "$NAME ASC"); // similar to...
    // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");

    List<InvigilatorsDetailsModel> listOfInvigilators = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfInvigilators.add(InvigilatorsDetailsModel.fromMap(maps[i]));
      }
    }

    return listOfInvigilators;
  }

  // // get all deliveries from DELIVERIES_TABLE
  // Future<List<DeliveryModel>> getAllDeliveries() async {
  //   var dbClient = await db;

  //   List<Map> maps = await dbClient.query(DELIVERIES_TABLE, columns: [
  //     DELIVERY_ID,
  //     INIVIGILATORS_ID,
  //     TOTAL_PRICE,
  //     SMALL_BREAD_QTY,
  //     BIG_BREAD_QTY,
  //     BIGGER_BREAD_QTY,
  //     BIGGEST_BREAD_QTY,
  //     ROUND_BREAD_QTY,
  //     DELIVERY_DATE,
  //   ]);

  //   List<DeliveryModel> listOfDeliveries = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       listOfDeliveries.add(DeliveryModel.fromMap(maps[i]));
  //     }
  //   }

  //   return listOfDeliveries;
  // }

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

  // // get all payments from PAYMENTS_TABLE
  // Future<List<PaymentModel>> getAllPayments() async {
  //   var dbClient = await db;

  //   List<Map> maps = await dbClient.query(PAYMENTS_TABLE, columns: [
  //     PAYMENTS_ID,
  //     INIVIGILATORS_ID,
  //     AMOUNT,
  //     PAYMENT_DATE,
  //   ]);

  //   List<PaymentModel> listOfPayments = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       listOfPayments.add(PaymentModel.fromMap(maps[i]));
  //     }
  //   }

  //   return listOfPayments;
  // }

  // get payments by inivigilatorId from  PAYMENTS_TABLE
  // Future<List<PaymentModel>> getAllPaymentsByCustomerId(int inivigilatorId) async {
  //   var dbClient = await db;

  //   List<Map> maps = await dbClient.query(PAYMENTS_TABLE,
  //       columns: [
  //         PAYMENTS_ID,
  //         INIVIGILATORS_ID,
  //         AMOUNT,
  //         PAYMENT_DATE,
  //       ],
  //       where: '$INIVIGILATORS_ID = ?',
  //       whereArgs: [inivigilatorId]);

  //   List<PaymentModel> listOfPayments = [];
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       listOfPayments.add(PaymentModel.fromMap(maps[i]));
  //     }
  //   }

  //   return listOfPayments;
  // }

  // ---------------------------------------------------------------------------------
  //                      FETCH ONE QUERIES
  // ---------------------------------------------------------------------------------
  // get a INIVIGILATORS from INIVIGILATORS_TABLE
  Future<InvigilatorsDetailsModel> getInvigilator(int id) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(INIVIGILATORS_TABLE,
        columns: [
          PROFILE_ID,
          NAME,
          SESSION,
          START_TIME,
          END_TIME,
          ROOM,
          DAY,
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

  // // get a delivery by customer from DELIVERIES_TABLE
  // Future<DeliveryModel> getDelivery(int id) async {
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
  //       where: '$DELIVERY_ID = ?',
  //       whereArgs: [id]);

  //   if (maps.length > 0) {
  //     return DeliveryModel.fromMap(maps.first);
  //   }

  //   return null;
  // }

  // // get a payment by customerPAYMENTS_TABLE
  // Future<PaymentModel> getPayment(int id) async {
  //   var dbClient = await db;

  //   List<Map> maps = await dbClient.query(PAYMENTS_TABLE,
  //       columns: [
  //         PAYMENTS_ID,
  //         INIVIGILATORS_ID,
  //         AMOUNT,
  //         PAYMENT_DATE,
  //       ],
  //       where: '$INIVIGILATORS_ID = ?',
  //       whereArgs: [id]);

  //   if (maps.length > 0) {
  //     return PaymentModel.fromMap(maps.first);
  //   }

  //   return null;
  // }

  // ---------------------------------------------------------------------------------
  //                      DELETE QUERIES
  // ---------------------------------------------------------------------------------
  // delete INIVIGILATORS from INIVIGILATORS_TABLE
  Future<int> deleteInivigilator(int id) async {
    var dbClient = await db;

    return await dbClient
        .delete(INIVIGILATORS_TABLE, where: '$PROFILE_ID = ?', whereArgs: [id]);
  }

  // // delete delivery from DELIVERIES_TABLE
  // Future<int> deleteDelivery(int id) async {
  //   var dbClient = await db;

  //   return await dbClient.delete(DELIVERIES_TABLE,
  //       where: '$INIVIGILATORS_ID = ?', whereArgs: [id]);
  // }

  // // delete payment from PAYMENTS_TABLE
  // Future<int> deletePayment(int id) async {
  //   var dbClient = await db;

  //   return await dbClient.delete(PAYMENTS_TABLE,
  //       where: '$INIVIGILATORS_ID = ?', whereArgs: [id]);
  // }

  // ---------------------------------------------------------------------------------
  //                      UPDATE QUERIES
  // ---------------------------------------------------------------------------------
  // update customer info
  Future<int> updateInivigilator(
      InvigilatorsDetailsModel inivigilatorModel, int id) async {
    var dbClient = await db;

    return await dbClient.update(INIVIGILATORS_TABLE, inivigilatorModel.toMap(),
        where: '$PROFILE_ID = ?', whereArgs: [id]);
  }

  // // update delivery
  // Future<int> updateDelivery(DeliveryModel deliveryModel, int id) async {
  //   var dbClient = await db;

  //   return await dbClient.update(DELIVERIES_TABLE, deliveryModel.toMap(),
  //       where: '$DELIVERY_ID = ?', whereArgs: [id]);
  // }

  // update payment
  // Future<int> updatePayment(PaymentModel paymentModel, int id) async {
  //   var dbClient = await db;

  //   return await dbClient.update(PAYMENTS_TABLE, paymentModel.toMap(),
  //       where: '$PAYMENTS_ID = ?', whereArgs: [id]);
  // }

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
    final sign = _sign.currentState;
    final image = await sign.getData();
    var data = await image.toByteData(format: ui.ImageByteFormat.png);
    // signatures parameters declarations ENDS

    List<List<String>> csvData = [
      <String>[
        "PROFILE ID",
        "NAME",
        "SESSION",
        "START TIME",
        "END TIME",
        "ROOM",
        "DAY",
        "DATE TIME",
        "SIGNATURE"
      ],
      ...invigilatorsDetails.map((invigilator) => [
            "${invigilator.id}",
            invigilator.name,
            invigilator.session,
            invigilator.startTime,
            invigilator.endTime,
            invigilator.room,
            invigilator.day,
            invigilator.dateTime,
            invigilator.signImage
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
