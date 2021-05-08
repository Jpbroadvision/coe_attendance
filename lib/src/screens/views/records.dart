import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../core/models/attendance_records_model.dart';
import '../../core/service/database_service.dart';
import '../components/drawer.dart';
import '../components/invigilator_card.dart';
import '../components/loading.dart';
import '../components/toast_message.dart';

class Records extends StatefulWidget {
  Records({Key key}) : super(key: key);
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  Future<List<AttendanceRecordsModel>> _attendanceRecords;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    getListOfInvigilators();
  }

  listInvigilators() {
    return FutureBuilder(
      future: _attendanceRecords,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildInvigilatorsCard(snapshot.data);
        }

        return Loading();
      },
    );
  }

  Column buildInvigilatorsCard(List<AttendanceRecordsModel> attendanceRecords) {
    if (attendanceRecords.isEmpty)
      return Column(children: [Text("No record saved.")]);

    return Column(
        children: attendanceRecords
            .map((attendanceRecord) => InvigilatorCard(
                  attendanceRecord: attendanceRecord,
                  deleteFunction: removeAttendanceRecord,
                ))
            .toList());
  }

  getListOfInvigilators() {
    setState(() {
      _attendanceRecords = _databaseService.getAllAttendanceRecords();
    });
  }

  removeAttendanceRecord(id) {
    _databaseService.deleteInivigilator(id);
    // refresh list of invigilators
    getListOfInvigilators();
    toastMessage(_scaffoldKey.currentContext, "Delete successful");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(_scaffoldKey),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(253, 192, 41, 1.0),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          'Records',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Colors.white,
            ),
            onPressed: () async {
              String path = await _databaseService.generateCSV();

              String message = "Failed to generate CSV file";

              if (path == null)
                toastMessage(_scaffoldKey.currentContext, message, Colors.red);
              else {
                message = "File saved at $path";
                toastMessage(_scaffoldKey.currentContext, message);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[listInvigilators()]),
      ),
    );
  }
}
