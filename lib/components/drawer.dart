import 'package:flutter/material.dart';
import 'package:coe_attendance/main.dart';
import 'package:coe_attendance/records.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MyHomePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Records"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Records()));
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Export Data"),
            onTap: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (_) => ExportFile())
              //     );
            },
          )
        ],
      ),
    );
  }
}
