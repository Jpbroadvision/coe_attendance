import 'package:coe_attendance/components/invigilator_card.dart';
import 'package:coe_attendance/models/inivigilators_details_model.dart';
import 'package:flutter/material.dart';
import 'package:coe_attendance/components/drawer.dart';
import 'package:coe_attendance/service/database_service.dart';

class ImportNames extends StatefulWidget {
  ImportNames({Key key}) : super(key: key);
  @override
  _ImportNamesState createState() => _ImportNamesState();
}

class _ImportNamesState extends State<ImportNames> {
  DatabaseService databaseService;
  Future<List<InvigilatorsDetailsModel>> _importedNames;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    databaseService = DatabaseService();

    getListOfInvigilators();
  }

  listInvigilators() {
    return FutureBuilder(
      future: _importedNames,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildInvigilatorsCard(snapshot.data);
        }

        return Container(child: CircularProgressIndicator());
      },
    );
  }

  Column buildInvigilatorsCard(List<InvigilatorsDetailsModel> invigilators) {
    return Column(
        children: invigilators
            .map((invigilator) => InvigilatorCard(
                  invigilatorsDetails: invigilator,
                  deleteFunction: removeInvigilator,
                ))
            .toList());
  }

  getListOfInvigilators() {
    setState(() {
      _importedNames = databaseService.getAllInvigilators();
    });
  }

  removeInvigilator(id) {
    databaseService.deleteInivigilator(id);
    // refresh list of invigilators
    getListOfInvigilators();
    toastMessage("Delete successful");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(_scaffoldKey),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          'Record',
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
              String path = await databaseService.generateCSV();

              String message = "Failed to generate CSV file";

              if (path == null)
                toastMessage(message, Colors.red);
              else {
                message = "File saved at $path";
                toastMessage(message);
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

  toastMessage(String message, [Color color]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color == null ? Colors.green : color,
      content: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    ));
  }
}
