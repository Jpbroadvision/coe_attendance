import 'package:coe_attendance/components/attendance_import_card.dart';
import 'package:flutter/material.dart';
import 'package:coe_attendance/components/drawer.dart';

class ImportAttendance extends StatefulWidget {
  ImportAttendance({Key key}) : super(key: key);
  @override
  _ImportAttendanceState createState() => _ImportAttendanceState();
}

class _ImportAttendanceState extends State<ImportAttendance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(_scaffoldKey),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(253,192,41,1.0),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          'Import Attendance List',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AttendanceImportCard(
                title: "Teaching Assistance(TAs)",
                description:
                    "NB: The file you are going to import must be a CSV file.\nIt must have two columns with the first column names and second classrooms assigned",
                category: "TEACHING_ASSISTANCE",
              ),
              AttendanceImportCard(
                title: "Attendants",
                description:
                    'NB: The file you are going to import must be a CSV file. It must have two columns with the first column names and second classrooms assigned',
                category: "ATTENDANTS",
              ),
              AttendanceImportCard(
                title: "Invigilators",
                description:
                    "NB: The file you are going to import must be a CSV file. It must have only one column with their names.",
                category: "INVIGILATORS",
              ),
              AttendanceImportCard(
                title: "Available Rooms",
                description:
                    "NB: The file you are going to import must be a CSV file. It must have only one column with their room numbers or names.",
                category: "AVAILABLE_ROOMS",
              )
            ]),
      ),
    );
  }
}
