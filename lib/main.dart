import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:path_provider/path_provider.dart';

import 'package:coe_attendance/bloc/attendants_bloc.dart';
import 'package:coe_attendance/bloc/invigilators_bloc.dart';
import 'package:coe_attendance/bloc/rooms_bloc.dart';
import 'package:coe_attendance/bloc/teaching_assistants_bloc.dart';
import 'package:coe_attendance/components/drawer.dart';
import 'package:coe_attendance/components/footer.dart';
import 'package:coe_attendance/components/loading.dart';
import 'package:coe_attendance/components/toast_message.dart';
import 'package:coe_attendance/locator.dart';
import 'package:coe_attendance/models/attendance_records_model.dart';
import 'package:coe_attendance/models/attendant_model.dart';
import 'package:coe_attendance/models/available_rooms_model.dart';
import 'package:coe_attendance/models/inivigilator_model.dart';
import 'package:coe_attendance/models/teaching_assistant_model.dart';
import 'package:coe_attendance/service/database_service.dart';
import 'package:coe_attendance/service/permission_service.dart';

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

  TextEditingController _otherNameCtrl;

  String _selectedRoom;
  String _selectedAttendant;
  String _selectedInvigilator;
  TeachingAssistantModel _selectedTA;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // signatures parameters declarations
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 3.0;
  final _sign = GlobalKey<SignatureState>();
  // signatures parameters declarations ENDS

  @override
  void initState() {
    super.initState();

    PermissionService.getPermission();

    _otherNameCtrl = TextEditingController(text: "");
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
                                  fontSize: 15.0,
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
                                  fontSize: 15.0,
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

                                BlocProvider.of<TeachingAssistantsBloc>(context)
                                    .add(GetTeachingAssistants(
                                        room: _selectedRoom));
                              },
                              value: _selectedDuration,
                              style: TextStyle(
                                  fontSize: 15.0,
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
                            _buildRoomsBloc(),
                            SizedBox(
                              height: 20.0,
                            ),
                            if (_selectedCategory == "TAs") ...[
                              Text("Select Teaching Assistant"),
                              _buildTABloc()
                            ],
                            if (_selectedCategory == "Invigilators") ...[
                              Text("Select Invigilator"),
                              _buildInvigilatorsBloc()
                            ],
                            if (_selectedCategory == "Others") ...[
                              Text("Enter name"),
                              _buildOtherTextField(context),
                            ],
                            if (_selectedCategory == "Attendants") ...[
                              Text("Select Attendant"),
                              _buildAttendantsBloc(),
                            ],
                            SizedBox(
                              height: 20.0,
                            ),
                            Text("Signature/Initials"),
                            SizedBox(
                              height: 10.0,
                            ),
                            // SIGNATURE implementations
                            Wrap(
                              children: [
                                Container(
                                  // width: 270.0,
                                  height: 300.0,
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
                                IconButton(
                                    icon: Icon(Icons.dangerous,
                                        color: Colors.red, size: 30),
                                    onPressed: () {
                                      final sign = _sign.currentState;
                                      sign.clear();
                                      setState(() {
                                        _img = ByteData(0);
                                      });
                                    })
                              ],
                            ),

                            SizedBox(
                            height: 10.0,
                          ),
                          MaterialButton(
                              color: Colors.blueAccent,
                              onPressed: () async {
                                String signImagePath = await _getImagePath();

                                String dateTime =
                                    DateTime.now().toString().split(".")[0];

                                String invigilator;
                                switch (_selectedCategory) {
                                  case "TAs":
                                    invigilator = _selectedTA.taName;
                                    break;
                                  case "Invigilators":
                                    invigilator = _selectedInvigilator;
                                    break;
                                  case "Attendants":
                                    invigilator = _selectedAttendant;
                                    break;
                                  case "Others":
                                    invigilator = _otherNameCtrl.text;
                                    break;
                                }

                                if (_selectedRoom.isEmpty ||
                                    invigilator.isEmpty) {
                                  toastMessage(
                                      context, "Import CSV data.", Colors.red);
                                  return;
                                }

                                // set Invigilators details to be save
                                AttendanceRecordsModel attendanceRecords =
                                    AttendanceRecordsModel(
                                        name: invigilator,
                                        session: _selectedSession,
                                        category: _selectedCategory,
                                        duration: _selectedDuration,
                                        room: _selectedRoom,
                                        dateTime: dateTime,
                                        signImagePath: signImagePath);

                                // save details to database
                                try {
                                  await _databaseService.insertInvigilatorsData(
                                      attendanceRecords);

                                  toastMessage(
                                      context, "Successfully saved data.");
                                } catch (e) {
                                  toastMessage(
                                      context,
                                      "Error occured while saving data.",
                                      Colors.red);
                                }
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

  _getImagePath() async {
    //Signature image saving
    final sign = _sign.currentState;
    //retrieve image data, do whatever you want with it (send to server, save locally...)
    final image = await sign.getData();

    sign.clear();

    String reportDate = DateTime.now().toString();

    final String dirPath = (await getExternalStorageDirectory()).path;
    final String filePath = "$dirPath/sign-image-$reportDate.png";

    var data = await image.toByteData(format: ui.ImageByteFormat.png);

    /// create file
    final File file = File(filePath);

    /// save image file
    await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    return filePath;
  }

  TextField _buildOtherTextField(BuildContext context) {
    return TextField(
      controller: _otherNameCtrl,
      style: TextStyle(color: null),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Other",
        hintStyle: Theme.of(context).textTheme.bodyText2.merge(
              TextStyle(color: Colors.black87),
            ), //shape: StadiumBorder(),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.black12)),
        filled: false,
        // fillColor: Theme.of(context).primaryColor,
        contentPadding: EdgeInsets.all(12),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.yellowAccent)),
      ),
    );
  }

  BlocConsumer<TeachingAssistantsBloc, TeachingAssistantsState> _buildTABloc() {
    return BlocConsumer<TeachingAssistantsBloc, TeachingAssistantsState>(
      listener: (context, state) {
        if (state is TeachingAssistantsLoaded) {
          _selectedTA = state.teachingAssistants == null
              ? TeachingAssistantModel()
              : state.teachingAssistants[0];
        }
      },
      builder: (context, state) {
        if (state is TeachingAssistantsInitial) {
          BlocProvider.of<TeachingAssistantsBloc>(context)
              .add(GetTeachingAssistants(room: _selectedRoom ?? ""));
          return Loading();
        } else if (state is TeachingAssistantsLoading) {
          return Loading();
        } else if (state is TeachingAssistantsLoaded) {
          return DropdownButton<TeachingAssistantModel>(
            onChanged: (value) {
              setState(() {
                _selectedTA = value;
              });
            },
            value: _selectedTA,
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.black87,
                // fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
            items: state.teachingAssistants
                    ?.map((TeachingAssistantModel teachingAssistant) {
                  return DropdownMenuItem<TeachingAssistantModel>(
                    value: teachingAssistant,
                    child: Text(teachingAssistant.taName),
                  );
                })?.toList() ??
                [],
          );
        } else {
          return Loading();
        }
      },
    );
  }

  BlocConsumer<InvigilatorsBloc, InvigilatorsState> _buildInvigilatorsBloc() {
    return BlocConsumer<InvigilatorsBloc, InvigilatorsState>(
      listener: (context, state) {
        if (state is InvigilatorsLoaded) {
          _selectedInvigilator = state.invigilators == null
              ? ""
              : state.invigilators[0].invigiName;
        }
      },
      builder: (context, state) {
        if (state is InvigilatorsInitial) {
          BlocProvider.of<InvigilatorsBloc>(context).add(GetInvigilators());
          return Loading();
        } else if (state is InvigilatorsLoading) {
          return Loading();
        } else if (state is InvigilatorsLoaded) {
          return DropdownButton<String>(
            onChanged: (value) {
              setState(() {
                _selectedInvigilator = value;
              });
            },
            value: _selectedInvigilator,
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.black87,
                // fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
            items: state.invigilators?.map((InvigilatorsModel invigilator) {
                  return DropdownMenuItem<String>(
                    value: invigilator.invigiName,
                    child: Text(invigilator.invigiName),
                  );
                })?.toList() ??
                [],
          );
        } else {
          return Loading();
        }
      },
    );
  }

  BlocConsumer<RoomsBloc, RoomsState> _buildRoomsBloc() {
    return BlocConsumer<RoomsBloc, RoomsState>(
      listener: (context, state) {
        if (state is RoomsLoaded) {
          _selectedRoom =
              state.rooms.isEmpty ? "" : state.rooms[0]?.roomAllocations;

          // get TAs with the selected room
          BlocProvider.of<TeachingAssistantsBloc>(context)
              .add(GetTeachingAssistants(room: _selectedRoom));
        }
      },
      builder: (context, state) {
        if (state is RoomsInitial) {
          BlocProvider.of<RoomsBloc>(context).add(GetRooms());
          return Loading();
        } else if (state is RoomsLoading) {
          return Loading();
        } else if (state is RoomsLoaded) {
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
                fontSize: 15.0,
                color: Colors.black87,
                // fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
            items: state.rooms?.map((AvailableRoomsModel room) {
                  return DropdownMenuItem<String>(
                    value: room.roomAllocations,
                    child: Text(room.roomAllocations),
                  );
                })?.toList() ??
                [],
          );
        } else {
          return Loading();
        }
      },
    );
  }

  BlocConsumer<AttendantsBloc, AttendantsState> _buildAttendantsBloc() {
    return BlocConsumer<AttendantsBloc, AttendantsState>(
      listener: (context, state) {
        if (state is AttendantsLoaded) {
          _selectedAttendant =
              state.attendants == null ? "" : state.attendants[0].attName;
        }
      },
      builder: (context, state) {
        if (state is AttendantsInitial) {
          BlocProvider.of<AttendantsBloc>(context).add(GetAttendants());
          return Loading();
        } else if (state is AttendantsLoading) {
          return Loading();
        } else if (state is AttendantsLoaded) {
          return DropdownButton<String>(
            onChanged: (value) {
              setState(() {
                _selectedAttendant = value;
              });

              BlocProvider.of<TeachingAssistantsBloc>(context)
                  .add(GetTeachingAssistants(room: _selectedAttendant));
            },
            value: _selectedAttendant,
            style: TextStyle(
                fontSize: 15.0, color: Colors.black87, fontFamily: "Roboto"),
            items: state.attendants.map((AttendantModel attendant) {
              return DropdownMenuItem<String>(
                value: attendant.attName,
                child: Text(attendant.attName),
              );
            }).toList(),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
