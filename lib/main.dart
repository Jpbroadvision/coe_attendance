import 'package:coe_attendance/bloc/attendants_bloc.dart';
import 'package:coe_attendance/bloc/invigilators_bloc.dart';
import 'package:coe_attendance/bloc/rooms_bloc.dart';
import 'package:coe_attendance/bloc/teaching_assistants_bloc.dart';
import 'package:coe_attendance/components/loading.dart';
import 'package:coe_attendance/locator.dart';
import 'package:coe_attendance/models/available_rooms_model.dart';
import 'package:coe_attendance/models/inivigilator_model.dart';
import 'package:coe_attendance/models/teaching_assistant_model.dart';
import 'package:coe_attendance/service/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:coe_attendance/components/teaching_assistant_allocation.dart';
import 'package:coe_attendance/components/drawer.dart';
import 'package:coe_attendance/components/footer.dart';
import 'package:coe_attendance/models/inivigilators_details_model.dart';
import 'package:coe_attendance/service/database_service.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

void main() {
  // setup getIt service locator
  setupLocator();
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

// class for signature
class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 0.0,
        Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}
// class for signature ENDS

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  List<String> _categories = ['TAs', 'Invigilators', 'Attendants', 'Others'];
  String _selectedCategory = "TAs";

  List<String> _sessions = ['1', '2', '3'];
  String _selectedSession = "1";

  List<AvailableRoomsModel> _availableRooms;
  String _selectedRoom;

  TextEditingController _nameCtrl;

  List<String> _duration = [
    '1:15',
    '1:30',
    '1:45',
    '2:00',
    '2:15',
    '2:30',
    '2:45',
    '3:00'
  ];
  String _selectedDuration = "1:15";

  Map<String, List<String>> _allocations;

  List<InvigilatorsModel> _invigilators;
  String _selectedInvigilator;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // signatures parameters declarations
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 1.0;
  final _sign = GlobalKey<SignatureState>();
  // signatures parameters declarations ENDS

  @override
  void initState() {
    super.initState();

    PermissionService.getPermission();

    _nameCtrl = TextEditingController(text: "");
  }

  buildTACategory() {
    return Column(
      children: [
        Text("Select Teaching Assistant"),
        // get names per room
        DropdownButton<String>(
            onChanged: (value) {
              setState(() {
                _selectedInvigilator = value;
              });
            },
            value: _selectedInvigilator,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.black87,
                // fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
            items: _allocations[_selectedRoom].map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => InvigilatorsBloc(),
          ),
          BlocProvider(
            create: (context) => AttendantsBloc(),
          ),
          BlocProvider(
            create: (context) => RoomsBloc(),
          ),
          BlocProvider(
            create: (context) => TeachingAssistantsBloc(),
          ),
        ],
        child: Scaffold(
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
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white)),
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
                          Text("Select Category"),
                          DropdownButton<String>(
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                            value: _selectedCategory,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black87,
                                fontFamily: "Roboto"),
                            items: _categories.map((String dropDownStringItem) {
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
                          ),
                          Text("Select Duration"),
                          DropdownButton<String>(
                            onChanged: (value) {
                              setState(() {
                                _selectedDuration = value;
                              });
                            },
                            value: _selectedDuration,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black87,
                                fontFamily: "Roboto"),
                            items: _duration.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text("Select Room"),
                          buildRoomsBlocBuilder(),
                          SizedBox(
                            height: 20.0,
                          ),

                          buildInvigilatorsBlocBuilder(),

                          /* BlocBuilder<TeachingAssistantsBloc,
                              TeachingAssistantsState>(
                            builder: (context, state) {
                              if (state is TeachingAssistantsInitial) {
                                BlocProvider.of<TeachingAssistantsBloc>(context)
                                    .add(GetTeachingAssistants(
                                        room: _selectedRoom));
                                return Loading();
                              } else if (state is TeachingAssistantsLoading) {
                                return Loading();
                              } else if (state is TeachingAssistantsLoaded) {
                                _selectedInvigilator =
                                    state.teachingAssistants[0];

                                return DropdownButton<String>(
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRoom = value;
                                    });
                                  },
                                  value: _selectedRoom,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black87,
                                      // fontWeight: FontWeight.w200,
                                      fontFamily: "Roboto"),
                                  items: state.teachingAssistants
                                      .map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(dropDownStringItem),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Loading();
                              }
                            },
                          ), */

                          SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                            controller: _nameCtrl,
                            style: TextStyle(color: null),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: "Other",
                              hintStyle:
                                  Theme.of(context).textTheme.bodyText2.merge(
                                        TextStyle(color: Colors.black87),
                                      ), //shape: StadiumBorder(),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.black12)),
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
                            height: 20.0,
                          ),
                          Text("Signature/Initials"),
                          SizedBox(
                            height: 10.0,
                          ),
                          // SIGNATURE implementations
                          Column(
                            children: [
                              Container(
                                width: 300.0,
                                height: 50.0,
                                child: Signature(
                                  color: color,
                                  key: _sign,
                                  // onSign: () {
                                  //   final sign = _sign.currentState;
                                  //   debugPrint(
                                  //       '${sign.points.length} points in the signature');
                                  // },
                                  backgroundPainter:
                                      _WatermarkPaint("2.0", "2.0"),
                                  strokeWidth: strokeWidth,
                                ),
                                color: Colors.black12,
                              ),
                              Text(
                                "clear if you dont like current signature. Cannot be undone after save",
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: Colors.redAccent,
                                      onPressed: () {
                                        final sign = _sign.currentState;
                                        sign.clear();
                                        setState(() {
                                          _img = ByteData(0);
                                        });
                                      },
                                      child: Text(
                                        "Clear Signature",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 10.0,
                          ),
                          MaterialButton(
                              color: Colors.blueAccent,
                              onPressed: () async {
                                //Signature image saving
                                final sign = _sign.currentState;
                                //retrieve image data, do whatever you want with it (send to server, save locally...)
                                final image = await sign.getData();

                                var data = await image.toByteData(
                                    format: ui.ImageByteFormat.png);
                                // final byteInts = data.buffer.asUint8List().toList();
                                // _save(data);
                                sign.clear();
                                final encoded =
                                    base64.encode(data.buffer.asUint8List());
                                setState(() {
                                  _img = data;
                                });
                                debugPrint("This is the encoded " + encoded);
                                //Signature image saving ENDS

                                String dateTime = DateTime.now().toString();

                                // set Invigilators details to be save
                                InvigilatorsDetailsModel invigilatorsDetails =
                                    InvigilatorsDetailsModel(
                                        invigiName: _nameCtrl.text,
                                        session: _selectedSession,
                                        category: _selectedCategory,
                                        duration: _selectedDuration,
                                        room: _selectedRoom,
                                        dateTime: dateTime,
                                        signImage: encoded);
                                // save details to database
                                try {
                                  _databaseService.insertInvigilatorsData(
                                      invigilatorsDetails);
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Error occured while saving data."),
                                  ));
                                }

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
        ));
  }

  BlocConsumer<InvigilatorsBloc, InvigilatorsState>
      buildInvigilatorsBlocBuilder() {
    return BlocConsumer<InvigilatorsBloc, InvigilatorsState>(
      listener: (context, state) {
        print(state);
      },
      builder: (context, state) {
        if (state is InvigilatorsInitial) {
          BlocProvider.of<InvigilatorsBloc>(context).add(GetInvigilators());
          return Loading();
        } else if (state is InvigilatorsLoading) {
          return Loading();
        } else if (state is InvigilatorsLoaded) {
          _selectedInvigilator = state.invigilators[0].invigiName;

          return DropdownButton<String>(
            onChanged: (value) {
              setState(() {
                _selectedInvigilator = value;
              });
              print(_selectedInvigilator);
            },
            value: _selectedInvigilator,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.black87,
                // fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
            items:
                state.invigilators.map((InvigilatorsModel dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem.invigiName,
                child: Text(dropDownStringItem.invigiName),
              );
            }).toList(),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  BlocBuilder<RoomsBloc, RoomsState> buildRoomsBlocBuilder() {
    return BlocBuilder<RoomsBloc, RoomsState>(
      builder: (context, state) {
        if (state is RoomsInitial) {
          BlocProvider.of<RoomsBloc>(context).add(GetRooms());
          return Loading();
        } else if (state is RoomsLoading) {
          return Loading();
        } else if (state is RoomsLoaded) {
          _selectedRoom = state.rooms[0].roomAllocations;

          return DropdownButton<String>(
            onChanged: (value) {
              setState(() {
                _selectedRoom = value;
              });

              BlocProvider.of<TeachingAssistantsBloc>(context)
                  .add(GetTeachingAssistants(room: _selectedRoom));
            },
            value: _selectedRoom,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.black87,
                // fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
            items: state.rooms.map((AvailableRoomsModel dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem.roomAllocations,
                child: Text(dropDownStringItem.roomAllocations),
              );
            }).toList(),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  // void ponButtonPressed() {}

  // Future<void> callSignatureDialog(BuildContext context) {
  //   print("sAVE IS clicked");

  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         // bool isChecked = false;
  //         return StatefulBuilder(builder: (context, setState) {
  //           return AlertDialog(
  //             content: SignatureScreen(),
  //             title: Text(
  //               'Kindly Sign And Save',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 20.0),
  //             ),
  //             actions: <Widget>[
  //               InkWell(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Text('OK   '),
  //                 ),
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         });
  //       });
  // }
}
