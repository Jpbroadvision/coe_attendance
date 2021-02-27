import 'dart:convert';

import 'package:coe_attendance/components/signature.dart';
import 'package:flutter/material.dart';
import 'package:coe_attendance/components/footer.dart';
import 'package:coe_attendance/components/allocations.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:coe_attendance/components/callDialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoE INVIGILTORS ATTENDANCE',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFFFFF),
        accentColor: const Color(0xFF9c27b0),
        canvasColor: const Color(0xFFECEFF1),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _day = "Select Day";
  String _session = "Select Session";
  String _room = "Select Room";

  @override
  Widget build(BuildContext context) {
    //   String jsonString;
    //       Map allocateMap = jsonDecode(jsonString);
    // var allocate = Alocations.fromJson(allocateMap);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('CoE INVIGILTORS ATTENDANCE', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        offset: Offset(0, 5),
                        blurRadius: 10)
                  ],
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      DropdownButton<String>(
                        onChanged: (value) {
                          setState(() {
                            _day = value;
                          });
                        },
                        value: _day,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                            fontFamily: "Roboto"),
                        items: <DropdownMenuItem<String>>[
                          const DropdownMenuItem<String>(
                              value: "Select Day",
                              child: const Text("Select Day")),
                          const DropdownMenuItem<String>(
                              value: "Monday", child: const Text("Monday")),
                          const DropdownMenuItem<String>(
                              value: "Tuesday", child: const Text("Tuesday")),
                          const DropdownMenuItem<String>(
                              value: "Wednesday",
                              child: const Text("Wednesday")),
                          const DropdownMenuItem<String>(
                              value: "Thursday", child: const Text("Thursday")),
                          const DropdownMenuItem<String>(
                              value: "Friday", child: const Text("Friday")),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      DropdownButton<String>(
                        onChanged: (value) {
                          setState(() {
                            _session = value;
                          });
                        },
                        value: _session,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                            fontFamily: "Roboto"),
                        items: <DropdownMenuItem<String>>[
                          const DropdownMenuItem<String>(
                              value: "Select Session",
                              child: const Text("Select Session")),
                          const DropdownMenuItem<String>(
                              value: "Session 1",
                              child: const Text("Session 1")),
                          const DropdownMenuItem<String>(
                              value: "Session 2",
                              child: const Text("Session 2")),
                          const DropdownMenuItem<String>(
                              value: "Session 4",
                              child: const Text("Session 4")),
                          const DropdownMenuItem<String>(
                              value: "Session 5",
                              child: const Text("Session 5")),
                          const DropdownMenuItem<String>(
                              value: "Session 6",
                              child: const Text("Session 6")),
                          const DropdownMenuItem<String>(
                              value: "Session 7",
                              child: const Text("Session 7")),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                        child: SizedBox(
                          height: 100.0,
                        ),
                      ),
                      DropdownButton<String>(
                        onChanged: (value) {
                          setState(() {
                            _room = value;
                          });
                        },
                        value: _room,
                        style: TextStyle(
                            fontSize: 20.0,
                            color:  Colors.black87,
                            // fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                        items: <DropdownMenuItem<String>>[
                          const DropdownMenuItem<String>(
                              value: "Select Room",
                              child: const Text("Select Room")),
                          const DropdownMenuItem<String>(
                              value: "Child 2", child: const Text("Child 2")),
                          const DropdownMenuItem<String>(
                              value: "Child 3", child: const Text("Child 3")),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        style: TextStyle(color: null),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'Enter Name',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .merge(
                                TextStyle(color: Colors.black87),
                              ), //shape: StadiumBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.black12)),
                          filled: false,
                          // fillColor: Theme.of(context).primaryColor,
                          contentPadding: EdgeInsets.all(12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.yellowAccent)),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      
                      IconButton(
                        onPressed: () {
                          // call the dialog
                          // print("SIGN clicked");

                          callSignatureDialog(context);
                        },
                        icon: Text(
                          "Sign",
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.redAccent),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      MaterialButton(
                      color: Colors.blueAccent,
                      onPressed: () {
                          // call the dialog
                          // print("SIGN clicked");

                          // callSignatureDialog(context);
                        },
                      child: Text("SAVE DETAILS",style: TextStyle(color: Colors.white))),
                      
                      SizedBox(height: 20),
                      Footer()
                    ]),

                // alignment: Alignment.center,
              )
            ]),
      ),
    );
  }

  void popupButtonSelected(String value) {}

  void iconButtonPressed() {}

  Future<void> callSignatureDialog(BuildContext context) {
    print("sAVE IS clicked");

    return showDialog(
        context: context,
        builder: (context) {
          // bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: SignatureScreen(),
                
              title: Text('Kindly Sign And Save', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0),),
              actions: <Widget>[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('OK   '),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }
}
