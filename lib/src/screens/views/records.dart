import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../../locator.dart';
import '../../../utils/date_time.dart';
import '../../../utils/flash_helper.dart';
import '../../core/models/attendance_records_model.dart';
import '../../core/service/database_service.dart';
import '../components/custom_appbar.dart';
import '../components/custom_dropdown.dart';
import '../components/drawer.dart';
import '../components/loading.dart';
import '../components/proctor_card.dart';
import '../components/toast_message.dart';

class Records extends StatefulWidget {
  Records({Key key}) : super(key: key);
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  Future<List<AttendanceRecordModel>> _attendanceRecords;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTimeHelper dateTimeHelper;

  String _selectedCategory;
  List<String> _categories = ['All', 'TAs', 'Proctors', 'Others'];
  List<DropdownMenuItem<String>> _categoriesDropdownList;

  String _selectedSession;
  List<String> _sessions = ['All', '1', '2', '3'];
  List<DropdownMenuItem<String>> _sessionsDropdownList;

  String _selectedDate;

  bool _toggleFilters = false;

  @override
  void initState() {
    super.initState();

    getListOfProctors();

    _categoriesDropdownList = _buildDropdownList(_categories);
    _selectedCategory = _categories[0];

    _sessionsDropdownList = _buildDropdownList(_sessions);
    _selectedSession = _sessions[0];

    // set date
    dateTimeHelper = DateTimeHelper();
    setState(() => _selectedDate = dateTimeHelper.formattedDate);
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

  listProctors() {
    return FutureBuilder(
      future: _attendanceRecords,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildProctorsCard(snapshot.data);
        }

        return Loading();
      },
    );
  }

  Column buildProctorsCard(List<AttendanceRecordModel> attendanceRecords) {
    if (attendanceRecords.isEmpty)
      return Column(children: [Text("No record saved.")]);

    return Column(
        children: attendanceRecords
            .map((attendanceRecord) => ProctorCard(
                  attendanceRecord: attendanceRecord,
                  deleteFunction: removeAttendanceRecord,
                ))
            .toList());
  }

  getListOfProctors() {
    setState(() {
      _attendanceRecords = _databaseService.getAttendanceRecords();
    });
  }

  removeAttendanceRecord(id) {
    _databaseService.deleteInivigilator(id);
    // refresh list of Proctors
    getListOfProctors();
    toastMessage(_scaffoldKey.currentContext, "Delete successful");
  }

  @override
  void dispose() {
    FlashHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(_scaffoldKey),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CustomAppBar(
              title: 'Attendance Records',
              scaffoldKey: _scaffoldKey,
              trailing: PopupMenuButton(
                  itemBuilder: (_) => <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                            child: const Text('Share'), value: 'Share'),
                        PopupMenuItem<String>(
                            child: const Text('Export'), value: 'Export'),
                      ],
                  onSelected: (value) {
                    switch (value) {
                      case 'Share':
                        _showShareExportDialog(
                          title: 'Share as',
                          onTapCSV: () {},
                          onTapPDF: () {},
                        );
                        break;
                      case 'Export':
                        _showShareExportDialog(
                          title: 'Export as',
                          onTapCSV: () {},
                          onTapPDF: () {},
                        );
                        break;
                    }
                  }),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filters",
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                          icon: Icon(
                            _toggleFilters
                                ? Icons.remove_circle
                                : Icons.add_circle,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() => _toggleFilters = !_toggleFilters);
                          }),
                    ],
                  ),
                  if (_toggleFilters) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category"),
                        SizedBox(height: 5.0),
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
                        SizedBox(height: 15),
                        Text("Session"),
                        SizedBox(height: 5.0),
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
                        SizedBox(height: 15),
                        Text("Date"),
                        SizedBox(height: 5.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 4.0,
                          ),
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                theme: DatePickerTheme(
                                  containerHeight: 210.0,
                                ),
                                showTitleActions: true,
                                minTime: DateTime(2020, 1, 1),
                                maxTime: DateTime(2030, 12, 31),
                                onConfirm: (date) {
                              String dateToStr = date.toString();

                              setState(() {
                                _selectedDate = dateToStr.split(' ')[0];
                              });
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Color(0xff244e98),
                                ),
                                Text(
                                  " $_selectedDate",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ],
                  Text(
                    "Filter result",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(child: listProctors())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareExportDialog(
      {String title, Function onTapCSV, Function onTapPDF}) {
    FlashHelper.customDialog(
      context,
      titleBuilder: (context, controller, setState) {
        return Text(title);
      },
      messageBuilder: (context, controller, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text('PDF'),
              onPressed: () {
                onTapPDF();
                controller.dismiss();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text('CSV'),
              onPressed: () {
                onTapCSV();
                controller.dismiss();
              },
            ),
          ],
        );
      },
      negativeAction: (context, controller, setState) {
        return TextButton(
          child: Text('Cancel'),
          onPressed: () => controller.dismiss(),
        );
      },
    );
  }

  generateCSVFile() async {
    String path = await _databaseService.generateCSV();

    String message = "Failed to generate CSV file";

    if (path == null)
      toastMessage(_scaffoldKey.currentContext, message, Colors.red);
    else {
      message = "File saved at $path";
      toastMessage(_scaffoldKey.currentContext, message);
    }
  }
}
