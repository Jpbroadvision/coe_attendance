import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sqlitetoexcel/sqlitetoexcel.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:coe_attendance/service/database_service.dart';
import 'package:coe_attendance/models/inivigilators_details_model.dart';
// import 'package:coe_attendance/service/database_service.dart';

class ExportFile extends StatefulWidget {
  @override
  ExportFile({Key key}) : super(key: key);
  _ExportFileState createState() => _ExportFileState();
}

class _ExportFileState extends State<ExportFile> {
  DatabaseService databaseService;
  Future<List<InvigilatorsDetailsModel>> _invigilatorsDetails;

  // ignore: unused_field
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    databaseService = DatabaseService();

    setState(() {
      _invigilatorsDetails = databaseService.getAllInvigilators();
    });
    _invigilatorsDetails.then((result) => print(result.map((i) => i.name)));
    getPermission();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var dbName = "inivigilators_database.db";
  var path, dbPath, dir;

  getPermission() async {
    if (await Permission.storage.request().isDenied) {
      await Permission.contacts.request();
    }
  }

  // Export All tables
  Future<String> _exportAll() async {
    var excludes = new List<dynamic>();
    var prettify = new Map<dynamic, dynamic>();
    var finalpath = "";
    _invigilatorsDetails.then((result) => print(result.map((i) => i.name)));
    // Prettifies columns name
    prettify[
            "${_invigilatorsDetails.then((result) => result.map((i) => i.id))}"] =
        "ID";
    prettify[
            "${_invigilatorsDetails.then((result) => result.map((i) => i.name))}"] =
        "FULL NAME";
    prettify[
            "${_invigilatorsDetails.then((result) => result.map((i) => i.session))}"] =
        "SESSION";
    prettify[
            "${_invigilatorsDetails.then((result) => result.map((i) => i.startTime))}"] =
        "START_TIME";
    prettify[
            "${_invigilatorsDetails.then((result) => result.map((i) => i.endTime))}"] =
        "END_TIME";
    prettify[
            "${_invigilatorsDetails.then((result) => result.map((i) => i.room))}"] =
        "ROOM";
    prettify[
            "${_invigilatorsDetails.then((result) => result.map((i) => i.day))}"] =
        "DAY";
    prettify[
            "${_invigilatorsDetails.then((result) => result.map((i) => i.dateTime))}"] =
        "DATE";

    final directory = await getExternalStorageDirectory();
    path = directory.path;
    dbPath = join(directory.path, dbName);
    try {
      finalpath = await Sqlitetoexcel.exportAll(
          dbPath, "documents", "", "Export All.xls", excludes, prettify);
      return finalpath;
    } on PlatformException catch (e) {
      print("exception" + e.message.toString());
    }
    return finalpath;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Export Data'),
        ),
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Container(
                  child: RaisedButton(
                    onPressed: () {
                      _exportAll().then((path) {
                        showSnackBar(path.toString());
                      });
                    },
                    child: Text("Export All"),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  void showSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Your excel file is saved in ' + message),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: scaffoldKey.currentState.hideCurrentSnackBar,
      ),
    ));
  }
}
