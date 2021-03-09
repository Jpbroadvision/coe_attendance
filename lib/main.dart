import 'package:coe_attendance/service/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:coe_attendance/components/data_source.dart';
import 'package:coe_attendance/components/drawer.dart';
import 'package:coe_attendance/components/footer.dart';
import 'package:coe_attendance/components/signature.dart';
import 'package:coe_attendance/models/inivigilators_details_model.dart';
import 'package:coe_attendance/service/database_service.dart';

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
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  String _selectedDay = "Monday";

  List<String> _sessions = ['1', '2', '3', '4', '5', '6', '7'];
  String _selectedSession = "1";

  String _room = "LT";
  String _invigilators = "Alfred Crabbe";
  TextEditingController _nameCtrl;

  Map<String, List<String>> _allocations;

  DatabaseService databaseService;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    PermissionService.getPermission();

    setState(() {
      _allocations = DataSource.getAllocations();
      _nameCtrl = TextEditingController(text: _invigilators);
    });

    databaseService = DatabaseService();
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
        title: Text('CoE INVIGILTORS ATTENDANCE',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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
                      Text("Select Day"),
                      DropdownButton<String>(
                        onChanged: (value) {
                          setState(() {
                            _selectedDay = value;
                            print("The selected day is: " + _selectedDay);
                          });
                        },
                        value: _selectedDay,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                            fontFamily: "Roboto"),
                        items: _days.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Select Session"),
                      DropdownButton<String>(
                        onChanged: (value) {
                          setState(() {
                            _selectedSession = value;
                            print(
                                "The selected session is " + _selectedSession);
                          });
                        },
                        value: _selectedSession,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                            fontFamily: "Roboto"),
                        items: _sessions.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: SizedBox(
                          height: 100.0,
                        ),
                      ),
                      Text("Select Room"),
                      DropdownButton<String>(
                        onChanged: (value) {
                          setState(() {
                            _room = value;
                            _invigilators = _allocations[_room][0];
                            _nameCtrl.text = _invigilators;
                          });
                        },
                        value: _room,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                            // fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                        items:
                            _allocations.keys.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Select Invigilator"),
                      // get names per room
                      DropdownButton<String>(
                        onChanged: (value) {
                          setState(() {
                            _invigilators = value;
                            _nameCtrl.text = _invigilators;
                          });
                        },
                        value: _invigilators,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                            // fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                        items: _allocations[_room]
                            .map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                      ),

                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: _nameCtrl,
                        style: TextStyle(color: null),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: _invigilators,
                          hintStyle:
                              Theme.of(context).textTheme.bodyText2.merge(
                                    TextStyle(color: Colors.black87),
                                  ), //shape: StadiumBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black12)),
                          filled: false,
                          // fillColor: Theme.of(context).primaryColor,
                          contentPadding: EdgeInsets.all(12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.yellowAccent)),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      // SIGNATURE

                      MaterialButton(
                          color: Colors.amber,
                          onPressed: () {
                            callSignatureDialog(context);
                          },
                          child: Text("SAVE DETAILS",
                              style: TextStyle(color: Colors.white))),
                      SizedBox(
                        height: 50.0,
                      ),
                      MaterialButton(
                          color: Colors.blueAccent,
                          onPressed: () {
                            // get session value
                            var session =
                                DataSource.getSession(_selectedSession);

                            String dateTime =
                                DateTime.now().toString().split(" ")[0];

                            // set Invigilators details to be save
                            InvigilatorsDetailsModel invigilatorsDetails =
                                InvigilatorsDetailsModel(
                                    name: _nameCtrl.text,
                                    session: _selectedSession,
                                    startTime: session["startTime"],
                                    endTime: session["endTime"],
                                    room: _room,
                                    day: _selectedDay,
                                    dateTime: dateTime);
                            // save details to database
                            try {
                              databaseService
                                  .insertInvigilatorsData(invigilatorsDetails);
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text("Error occured while saving data."),
                              ));
                            }

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Successfully saved data.",
                                style: TextStyle(color: Colors.white),
                              ),
                            ));
                          },
                          child: Text("SAVE DETAILS",
                              style: TextStyle(color: Colors.white))),
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
              title: Text(
                'Kindly Sign And Save',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
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
