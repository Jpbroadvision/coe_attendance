import 'dart:io';
import 'dart:ui' as ui;

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:path_provider/path_provider.dart';

import '../../../locator.dart';
import '../../../utils/date_time.dart';
import '../../../utils/watermark_paint.dart';
import '../../core/bloc/proctor_bloc.dart';
import '../../core/bloc/rooms_bloc.dart';
import '../../core/bloc/teaching_assistants_bloc.dart';
import '../../core/models/attendance_records_model.dart';
import '../../core/models/available_rooms_model.dart';
import '../../core/models/proctor_model.dart';
import '../../core/models/teaching_assistant_model.dart';
import '../../core/service/database_service.dart';
import '../../core/service/permission_service.dart';
import '../components/custom_appbar.dart';
import '../components/custom_dropdown.dart';
import '../components/drawer.dart';
import '../components/footer.dart';
import '../components/loading.dart';
import '../components/toast_message.dart';

class AddRecordPage extends StatefulWidget {
  AddRecordPage({Key key}) : super(key: key);
  @override
  _AddRecordPageState createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  String _selectedCategory;
  List<String> _categories = ['Teaching Assistant', 'Proctor', 'Other'];
  List<DropdownMenuItem<String>> _categoriesDropdownList;

  String _selectedSession;
  List<String> _sessions = ['1', '2', '3','4', '5', '6','7'];
  List<DropdownMenuItem<String>> _sessionsDropdownList;

  String _selectedDuration;
  List<String> _durations = [
    '1:00',
    '1:15',
    '1:30',
    '1:45',
    '2:00',
    '2:15',
    '2:30',
    '2:45',
    '3:00'
  ];
  List<DropdownMenuItem<String>> _durationsDropdownList;

  TextEditingController _otherNameCtrl;

  AvailableRoomsModel _selectedRoom;
  List<DropdownMenuItem<AvailableRoomsModel>> _roomsDropdownList;

  TeachingAssistantModel _selectedTA;
  List<DropdownMenuItem<TeachingAssistantModel>> _tAsDropdownList;

  ProctorModel _selectedProctor;
  TextEditingController _proctorCtrl;
  List<ProctorModel> _proctorsList;
  GlobalKey _taAutoCompleteKey =
      GlobalKey<AutoCompleteTextFieldState<ProctorModel>>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _sign = GlobalKey<SignatureState>();

  final dateTimeHelper = DateTimeHelper();

  @override
  void initState() {
    super.initState();

    PermissionService.getPermission();

    _otherNameCtrl = TextEditingController(text: "");
    _proctorCtrl = TextEditingController(text: "");

    _categoriesDropdownList = _buildDropdownList(_categories);
    _selectedCategory = _categories[0];

    _sessionsDropdownList = _buildDropdownList(_sessions);
    _selectedSession = _sessions[0];

    _durationsDropdownList = _buildDropdownList(_durations);
    _selectedDuration = _durations[0];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProctorsBloc(),
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
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(0.0),
            child: Column(children: <Widget>[
              CustomAppBar(
                title: 'Add Attendance Record',
                scaffoldKey: _scaffoldKey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text("Category"), SizedBox(height: 5.0),
                      CustomDropdown(
                        dropdownMenuItemList: _categoriesDropdownList,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        value: _selectedCategory,
                        isEnabled: true,
                      ),
                      SizedBox(height: 20.0),
                      Text("Session"), SizedBox(height: 5.0),
                      CustomDropdown(
                        dropdownMenuItemList: _sessionsDropdownList,
                        onChanged: (value) {
                          setState(() {
                            _selectedSession = value;
                          });
                        },
                        value: _selectedSession,
                        isEnabled: true,
                      ),
                      SizedBox(height: 20.0),
                      Text("Duration"), SizedBox(height: 5.0),
                      CustomDropdown(
                        dropdownMenuItemList: _durationsDropdownList,
                        onChanged: (value) {
                          setState(() {
                            _selectedDuration = value;
                          });
                        },
                        value: _selectedDuration,
                        isEnabled: true,
                      ),
                      SizedBox(height: 20.0),
                      Text("Room"), SizedBox(height: 5.0),
                      _buildRoomsBloc(),
                      SizedBox(height: 20.0),
                      if (_selectedCategory == "Teaching Assistant") ...[
                        Text("Teaching Assistant"),
                        SizedBox(height: 5.0),
                        _buildTABloc()
                      ],
                      if (_selectedCategory == "Proctor") ...[
                        Text("proctor"),
                        SizedBox(height: 5.0),
                        _buildProctorsBloc()
                      ],
                      if (_selectedCategory == "Other") ...[
                        Text("Enter name"),
                        SizedBox(height: 5.0),
                        _buildOtherTextField(context),
                      ],
                      SizedBox(height: 20.0),
                      Text("Signature"),
                      SizedBox(height: 5.0),
                      // signature pad
                      Stack(
                        children: [
                          Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Signature(
                              color: Colors.black,
                              key: _sign,
                              backgroundPainter: WatermarkPaint(
                                price: "2.0",
                                watermark: "2.0",
                              ),
                              strokeWidth: 3.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.cancel_presentation_rounded,
                                      color: Colors.red, size: 30),
                                  onPressed: () {
                                    _sign.currentState.clear();
                                  }),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20.0),
                    ]),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  height: 50,
                  width: 150,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    String signImagePath = await _getImagePath();
                    String tempCat =
                        _selectedCategory; // temp holder for _selectedCategory

                    String name;
                    switch (_selectedCategory) {
                      case "Teaching Assistant":
                        name = _selectedTA.name;
                        break;
                      case "Proctor":
                        name = _selectedProctor.name;
                        _selectedCategory = _selectedProctor.category;
                        break;
                      case "Other":
                        name = _otherNameCtrl.text;
                        break;
                    }

                    if (_selectedRoom.room.isEmpty || name.isEmpty) {
                      toastMessage(context, "Import CSV data.", Colors.red);
                      return;
                    }

                    // set Proctors details to be save
                    AttendanceRecordModel attendanceRecords =
                        AttendanceRecordModel(
                      name: name,
                      session: _selectedSession,
                      category: _selectedCategory,
                      duration: _selectedDuration,
                      room: _selectedRoom.room,
                      date: dateTimeHelper.formattedDate,
                      dateTime: DateTime.now().toString(),
                      signImagePath: signImagePath,
                    );

                    // revert selected category
                    _selectedCategory = tempCat;

                    // save details to database
                    try {
                      await _databaseService
                          .addAttendanceRecord(attendanceRecords);

                      toastMessage(context, "Successfully saved data.");
                    } catch (e) {
                      toastMessage(context, "Error occured while saving data.",
                          Colors.red);
                    }
                  },
                  child: Text("SAVE",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Footer()
            ]),
          ),
        ));
  }

  List<DropdownMenuItem<String>> _buildDropdownList(List pItems) {
    List<DropdownMenuItem<String>> items = [];
    for (String item in pItems) {
      items.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<AvailableRoomsModel>> _buildRoomsDropdownList(
      List<AvailableRoomsModel> rooms) {
    List<DropdownMenuItem<AvailableRoomsModel>> items = [];
    for (AvailableRoomsModel room in rooms) {
      items.add(DropdownMenuItem(
        value: room,
        child: Text(room.room),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<TeachingAssistantModel>> _buildTAsDropdownList(
      List<TeachingAssistantModel> taList) {
    List<DropdownMenuItem<TeachingAssistantModel>> items = [];
    for (TeachingAssistantModel ta in taList) {
      items.add(DropdownMenuItem(
        value: ta,
        child: Text(ta.name),
      ));
    }
    return items;
  }

  _getImagePath() async {
    //Signature image saving
    final sign = _sign.currentState;
    //retrieve image data, do whatever you want with it (send to server, save locally...)
    final image = await sign.getData();

    sign.clear();

    final String dirPath = (await getExternalStorageDirectory()).path;
    final String filePath =
        "$dirPath/sign-image-${DateTime.now().toString()}.png";

    var data = await image.toByteData(format: ui.ImageByteFormat.png);

    /// create file
    final File file = File(filePath);

    /// save image file
    await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    return filePath;
  }

  // textfield input decoration
  final enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(width: 1, color: Colors.black),
  );
  final focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 1,
      color: Color(0xFFfdc029),
    ),
  );

  TextField _buildOtherTextField(BuildContext context) {
    return TextField(
      controller: _otherNameCtrl,
      decoration: InputDecoration(
        hintText: "Other",
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
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
              .add(GetTeachingAssistants(room: _selectedRoom?.room ?? ""));
          return Loading();
        } else if (state is TeachingAssistantsLoading) {
          return Loading();
        } else if (state is TeachingAssistantsLoaded) {
          if (state.teachingAssistants == null)
            return buildInfoMessage(
                'No data available for teaching assistants. Import data at Settings screen.');

          _tAsDropdownList = _buildTAsDropdownList(state.teachingAssistants);
          return Column(
            children: [
              CustomDropdown(
                dropdownMenuItemList: _tAsDropdownList,
                onChanged: (value) {
                  setState(() {
                    _selectedTA = value;
                  });
                },
                value: _selectedTA,
                isEnabled: true,
              ),
            ],
          );
        } else {
          return Loading();
        }
      },
    );
  }

  Center buildInfoMessage(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  BlocConsumer<ProctorsBloc, ProctorsState> _buildProctorsBloc() {
    return BlocConsumer<ProctorsBloc, ProctorsState>(
      listener: (context, state) {
        if (state is ProctorsLoaded) {
          _selectedProctor =
              state.proctors.isEmpty ? ProctorModel() : state.proctors?.first;
        }
      },
      builder: (context, state) {
        if (state is ProctorsInitial) {
          BlocProvider.of<ProctorsBloc>(context).add(GetProctors());
          return Loading();
        } else if (state is ProctorsLoading) {
          return Loading();
        } else if (state is ProctorsLoaded) {
          if (state.proctors.isEmpty)
            return buildInfoMessage(
                'No data for proctors. Import data at Settings screen.');

          _proctorsList = state.proctors;
          return AutoCompleteTextField<ProctorModel>(
            controller: _proctorCtrl,
            clearOnSubmit: false,
            decoration: InputDecoration(
              hintText: "Search proctor:",
              suffixIcon: Icon(Icons.search),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
            ),
            itemSubmitted: (item) {
              setState(() {
                _selectedProctor = item;
              });
              _proctorCtrl.text = _selectedProctor.name;
            },
            key: _taAutoCompleteKey,
            suggestions: _proctorsList,
            itemBuilder: (context, proctor) => Padding(
              child: Text(proctor.name),
              padding: EdgeInsets.all(5.0),
            ),
            itemSorter: (a, b) => a.id == b.id
                ? 0
                : a.id > b.id
                    ? -1
                    : 1,
            itemFilter: (suggestion, input) =>
                suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
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
              state.rooms.isEmpty ? AvailableRoomsModel() : state.rooms?.first;

          // get Teaching Assistant with the selected room
          BlocProvider.of<TeachingAssistantsBloc>(context)
              .add(GetTeachingAssistants(room: _selectedRoom.room));
        }
      },
      builder: (context, state) {
        if (state is RoomsInitial) {
          BlocProvider.of<RoomsBloc>(context).add(GetRooms());
          return Loading();
        } else if (state is RoomsLoading) {
          return Loading();
        } else if (state is RoomsLoaded) {
          if (state.rooms.isEmpty)
            return buildInfoMessage(
                'No data for available rooms. Import data at Settings screen.');

          _roomsDropdownList = _buildRoomsDropdownList(state.rooms);
          return CustomDropdown(
            dropdownMenuItemList: _roomsDropdownList,
            onChanged: (value) {
              setState(() {
                _selectedRoom = value;
              });

              // get Teaching Assistant with the selected room
              BlocProvider.of<TeachingAssistantsBloc>(context)
                  .add(GetTeachingAssistants(room: _selectedRoom.room));
            },
            value: _selectedRoom,
            isEnabled: true,
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
