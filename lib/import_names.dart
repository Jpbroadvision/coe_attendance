import 'package:coe_attendance/components/import_card.dart';
import 'package:flutter/material.dart';
import 'package:coe_attendance/components/drawer.dart';

class ImportNames extends StatefulWidget {
  ImportNames({Key key}) : super(key: key);
  @override
  _ImportNamesState createState() => _ImportNamesState();
}

class _ImportNamesState extends State<ImportNames> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          'Import Names',
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
            children: <Widget>[ImportCard()]),
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
