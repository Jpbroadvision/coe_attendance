import 'dart:io';
import 'dart:ui' as ui;

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/teaching_assistant_allocation.dart';
import '../../../utils/watermark_paint.dart';
import '../../core/models/attendance_records_model.dart';
import '../../core/models/available_rooms_model.dart';
import '../../core/models/proctor_model.dart';
import '../../core/models/teaching_assistant_model.dart';
import '../components/custom_appbar.dart';
import '../components/custom_dropdown.dart';
import '../components/drawer.dart';
import '../components/footer.dart';
import '../components/loading.dart';
import '../components/toast_message.dart';
import '../providers/service_providers.dart';

final selectedCategoryProvider = StateProvider<String>((ref) {
  final categories = ref.watch(categoriesProvider);

  return categories.first;
});

final categoriesProvider =
    Provider<List<String>>((ref) => ['Teaching Assistant', 'Proctor', 'Other']);

final selectedSessionProvider = StateProvider<String>((ref) {
  final sessions = ref.watch(sessionsProvider);

  return sessions.first;
});

final sessionsProvider =
    Provider<List<String>>((ref) => ['1', '2', '3', '4', '5', '6', '7']);

final selectedDurationProvider = StateProvider<String>((ref) {
  final durations = ref.watch(durationsProvider);

  return durations.first;
});

final durationsProvider = Provider<List<String>>((ref) =>
    ['1:00', '1:15', '1:30', '1:45', '2:00', '2:15', '2:30', '2:45', '3:00']);

final selectedRoomProvider =
    StateProvider.autoDispose<AvailableRoomsModel>((ref) {
  final availableRooms = ref.watch(availableRoomsProvider);

  return availableRooms.maybeWhen(
      data: (rooms) => rooms.length > 0 ? rooms.first : AvailableRoomsModel(),
      orElse: () => AvailableRoomsModel());
});

final availableRoomsProvider =
    FutureProvider.autoDispose<List<AvailableRoomsModel>>((ref) {
  final dbService = ref.watch(dbServiceProvider);

  return dbService.getAvailableRooms();
});

final selectedProctorProvider = StateProvider.autoDispose<ProctorModel>((ref) {
  final proctors = ref.watch(proctorsProvider);

  return proctors.maybeWhen(
      data: (proctorList) =>
          proctorList.length > 0 ? proctorList.first : ProctorModel(),
      orElse: () => ProctorModel());
});

final proctorsProvider = FutureProvider.autoDispose<List<ProctorModel>>((ref) {
  final dbService = ref.watch(dbServiceProvider);

  return dbService.getProctors();
});

final roomPerTAListProvider =
    FutureProvider.autoDispose<Map<String, List<TeachingAssistantModel>>>(
        (ref) {
  final teachingAssistantAllocation =
      ref.watch(teachingAssistantAllocationProvider);

  return teachingAssistantAllocation.getAllocations();
});

final tAsOfSelectedRoomProvider =
    StateProvider.autoDispose<List<TeachingAssistantModel>>((ref) {
  final roomPerTAs = ref.watch(roomPerTAListProvider);
  final selectedRoom = ref.watch(selectedRoomProvider);

  return roomPerTAs.maybeWhen(
      data: (roomForTAs) =>
          roomForTAs.isEmpty ? [] : roomForTAs[selectedRoom.state.room],
      orElse: () => []);
});

final selectedTAProvider =
    StateProvider.autoDispose<TeachingAssistantModel>((ref) {
  final tAs = ref.watch(tAsOfSelectedRoomProvider);
  // if (tAs.state == null) return TeachingAssistantModel();
  return tAs.state.length > 0 ? tAs.state.first : TeachingAssistantModel();
});

final teachingAssistantAllocationProvider =
    Provider.autoDispose<TeachingAssistantAllocation>((ref) {
  final dbService = ref.watch(dbServiceProvider);

  return TeachingAssistantAllocation(dbService);
});

final otherNameProvider = StateProvider<String>((ref) => '');

final searchProctorProvider = StateProvider<TextEditingController>(
    (ref) => TextEditingController(text: ''));

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

class AddRecordPage extends ConsumerWidget {
  AddRecordPage({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _taAutoCompleteKey =
      GlobalKey<AutoCompleteTextFieldState<ProctorModel>>();

  final _sign = GlobalKey<SignatureState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final categories = watch(categoriesProvider);
    final selectedCategory = watch(selectedCategoryProvider);
    List<DropdownMenuItem<String>> categoriesDropdownList =
        _buildDropdownList(categories);

    final sessions = watch(sessionsProvider);
    final selectedSession = watch(selectedSessionProvider);
    List<DropdownMenuItem<String>> sessionsDropdownList =
        _buildDropdownList(sessions);

    final durations = watch(durationsProvider);
    final selectedDuration = watch(selectedDurationProvider);
    List<DropdownMenuItem<String>> durationsDropdownList =
        _buildDropdownList(durations);

    final availableRooms = watch(availableRoomsProvider);
    final selectedRoom = watch(selectedRoomProvider);
    final tAsOfSelectedRoom = watch(tAsOfSelectedRoomProvider);
    final selectedTA = watch(selectedTAProvider);

    final proctors = watch(proctorsProvider);
    final selectedProctor = watch(selectedProctorProvider);
    final searchProctor = watch(searchProctorProvider);
    final otherName = watch(otherNameProvider);
    void clearFields() {
      searchProctor.state.clear();
    }

    return Scaffold(
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
                  dropdownMenuItemList: categoriesDropdownList,
                  onChanged: (value) => selectedCategory.state = value,
                  value: selectedCategory.state,
                ),
                SizedBox(height: 20.0),

                Text("Session"), SizedBox(height: 5.0),
                CustomDropdown(
                  dropdownMenuItemList: sessionsDropdownList,
                  onChanged: (value) => selectedSession.state = value,
                  value: selectedSession.state,
                ),
                SizedBox(height: 20.0),

                Text("Duration"), SizedBox(height: 5.0),
                CustomDropdown(
                  dropdownMenuItemList: durationsDropdownList,
                  onChanged: (value) => selectedDuration.state = value,
                  value: selectedDuration.state,
                ),
                SizedBox(height: 20.0),
                Text("Room"), SizedBox(height: 5.0),
                // shows available rooms
                availableRooms.map(
                  data: (data) {
                    // show import message if no data exist
                    if (data.value.isEmpty)
                      return InfoMessage(
                          message:
                              'No data for available rooms. Import data at Settings screen.');

                    List<DropdownMenuItem<AvailableRoomsModel>>
                        roomsDropdownList = _buildRoomsDropdownList(data.value);

                    return CustomDropdown(
                      dropdownMenuItemList: roomsDropdownList,
                      onChanged: (value) {
                        selectedRoom.state = value;
                      },
                      value: selectedRoom.state,
                    );
                  },
                  error: (error) => Text('oops an Error occured'),
                  loading: (_) => Loading(),
                ),
                SizedBox(height: 20.0),
                if (selectedCategory.state == "Teaching Assistant") ...[
                  Text("Teaching Assistant"),
                  SizedBox(height: 5.0),
                  buildTasWidget(tAsOfSelectedRoom, selectedTA)
                ],
                if (selectedCategory.state == "Proctor") ...[
                  Text("proctor"),
                  SizedBox(height: 5.0),
                  proctors.map(
                    data: (proctorsList) {
                      if (proctorsList.value.isEmpty)
                        return InfoMessage(
                            message:
                                'No data for proctors. Import data at Settings screen.');

                      return AutoCompleteTextField<ProctorModel>(
                        controller: searchProctor.state,
                        clearOnSubmit: false,
                        suggestionsAmount: 10,
                        decoration: InputDecoration(
                          hintText: "Search proctor:",
                          suffixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          enabledBorder: enabledBorder,
                          focusedBorder: focusedBorder,
                        ),
                        itemSubmitted: (item) {
                          selectedProctor.state = item;

                          searchProctor.state.text = selectedProctor.state.name;
                        },
                        key: _taAutoCompleteKey,
                        suggestions: proctorsList.value,
                        itemBuilder: (context, proctor) => Padding(
                          child: Text(proctor.name),
                          padding: EdgeInsets.all(5.0),
                        ),
                        itemSorter: (a, b) => a.id == b.id
                            ? 0
                            : a.id > b.id
                                ? -1
                                : 1,
                        itemFilter: (suggestion, input) => suggestion.name
                            .toLowerCase()
                            .contains(input.toLowerCase()),
                      );
                    },
                    error: (error) => Text('oops an Error occured'),
                    loading: (_) => Loading(),
                  )
                ],
                if (selectedCategory.state == "Other") ...[
                  Text("Enter name"),
                  SizedBox(height: 5.0),
                  TextField(
                    onChanged: (value) => otherName.state = value,
                    decoration: InputDecoration(
                      hintText: "Other",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                    ),
                  ),
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
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: 50,
              width: 150,
            ),
            child: ElevatedButton(
              onPressed: () {
                saveRecord(context);
                clearFields();
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
    );
  }

  buildTasWidget(StateController<List<TeachingAssistantModel>> tAs,
      StateController<TeachingAssistantModel> selectedTA) {
    if (tAs.state.isEmpty)
      return InfoMessage(
          message:
              'No data available for teaching assistants. Import data at Settings screen.');

    List<DropdownMenuItem<TeachingAssistantModel>> tAsDropdownList =
        _buildTAsDropdownList(tAs.state);
    return Column(
      children: [
        CustomDropdown(
          dropdownMenuItemList: tAsDropdownList,
          onChanged: (value) => selectedTA.state = value,
          value: selectedTA.state,
        ),
      ],
    );
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

  List<DropdownMenuItem<String>> _buildDropdownList(List<String> pItems) {
    List<DropdownMenuItem<String>> items = [];
    for (String item in pItems) {
      items.add(DropdownMenuItem(
        value: item,
        child: Text(item),
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

  saveRecord(BuildContext context) async {
    final selectedProctor = context.read(selectedProctorProvider);
    final selectedTA = context.read(selectedTAProvider);
    final otherName = context.read(otherNameProvider);
    final selectedRoom = context.read(selectedRoomProvider);
    final datetimeHelper = context.read(datetimeHelperProvider);
    final databaseService = context.read(dbServiceProvider);
    final selectedCategory = context.read(selectedCategoryProvider);
    final selectedSession = context.read(selectedSessionProvider);
    final selectedDuration = context.read(selectedDurationProvider);

    // temp holder for  selectedCategory.state
    String tempCategory = selectedCategory.state;

    String name;
    switch (selectedCategory.state) {
      case "Teaching Assistant":
        name = selectedTA.state.name;
        break;
      case "Proctor":
        name = selectedProctor.state.name;
        tempCategory = selectedProctor.state.category;
        break;
      case "Other":
        name = otherName.state;
        otherName.state = '';
        break;
    }

    if (selectedRoom.state == null || name == null || name.isEmpty) {
      toastMessage(context, "Kindly provide all inputs.", Colors.red);
      return;
    }

    String signImagePath = await _getImagePath();

    // set Proctors details to be save
    AttendanceRecordModel attendanceRecords = AttendanceRecordModel(
      name: name,
      session: selectedSession.state,
      category: tempCategory,
      duration: selectedDuration.state,
      room: selectedRoom.state.room,
      date: datetimeHelper.formattedDate,
      dateTime: DateTime.now().toString(),
      signImagePath: signImagePath,
    );

    // save details to database
    try {
      await databaseService
          .addAttendanceRecord(attendanceRecords)
          .then((value) {
        context.refresh(searchProctorProvider);
        context.refresh(selectedProctorProvider);
        context.refresh(selectedTAProvider);
        context.refresh(otherNameProvider);
        // context.refresh(selectedRoomProvider);
        context.refresh(datetimeHelperProvider);
        // context.refresh(selectedCategoryProvider);
        // context.refresh(selectedSessionProvider);
        // context.refresh(selectedDurationProvider);

        toastMessage(context, "Successfully saved data.");
      });

      return "Done";
    } catch (e) {
      toastMessage(context, "Error occured while saving data.", Colors.red);
      return "Failed";
    }
  }
}

class InfoMessage extends StatelessWidget {
  const InfoMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
