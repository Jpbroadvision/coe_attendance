import 'package:coe_attendance/components/invigilator_card.dart';
import 'package:coe_attendance/models/inivigilators_details_model.dart';
import 'package:flutter/material.dart';
import 'package:coe_attendance/components/drawer.dart';
import 'package:coe_attendance/service/database_service.dart';

class Records extends StatefulWidget {
  Records({Key key}) : super(key: key);
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  DatabaseService databaseService;
  Future<List<InvigilatorsDetailsModel>> _invigilatorsDetails;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    databaseService = DatabaseService();

    setState(() {
      _invigilatorsDetails = databaseService.getAllInvigilators();
    });
    _invigilatorsDetails.then((result) => print(result.map((i) => i.name)));
  }

  listInvigilators() {
    return FutureBuilder(
      future: _invigilatorsDetails,
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
            .map((invigilator) =>
                InvigilatorCard(invigilatorsDetails: invigilator))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text('Record',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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
