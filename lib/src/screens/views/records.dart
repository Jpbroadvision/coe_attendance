import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:share/share.dart';

import '../../../locator.dart';
import '../../../utils/csv_generator.dart';
import '../../../utils/date_time.dart';
import '../../../utils/flash_helper.dart';
import '../../../utils/pdf_document.dart';
import '../../core/bloc/records_bloc.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTimeHelper dateTimeHelper;

  String _selectedCategory;
  List<String> _categories = [
    'Select category',
    'All',
    'Teaching Assistant',
    'Invigilator',
    'Attendant',
    'Other'
  ];
  List<DropdownMenuItem<String>> _categoriesDropdownList;

  String _selectedSession;
  List<String> _sessions = ['Select session','All', '1', '2', '3'];
  List<DropdownMenuItem<String>> _sessionsDropdownList;

  String _selectedDate;

  BuildContext _recordsContext;

  List<AttendanceRecordModel> _attendanceRecords;

  bool _toggleFilters = false;

  @override
  void initState() {
    super.initState();

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

  Column buildProctorsCard(
      BuildContext context, List<AttendanceRecordModel> attendanceRecords) {
    if (attendanceRecords.isEmpty)
      return Column(children: [Text("No record saved.")]);

    return Column(
        children: attendanceRecords
            .map(
              (attendanceRecord) => ProctorCard(
                attendanceRecord: attendanceRecord,
                deleteFunction: () async {
                  await _databaseService
                      .deleteAttendanceRecordById(attendanceRecord.id);

                  //refresh list of Proctors
                  refreshRecords(context);

                  toastMessage(
                      _scaffoldKey.currentContext, "Delete successful");
                },
              ),
            )
            .toList());
  }

  @override
  void dispose() {
    FlashHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);

    return BlocProvider(
      create: (context) => RecordsBloc(),
      child: Scaffold(
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
                            onTapCSV: () {
                              final completer = Completer();

                              createCSVFile().then((filePath) {
                                completer.complete();

                                Share.shareFiles(
                                  ['$filePath'],
                                  text: 'CoE Examination Attendance',
                                );
                              });

                              FlashHelper.blockDialog(
                                context,
                                dismissCompleter: completer,
                              );
                            },
                            onTapPDF: () {
                              final completer = Completer();

                              createPdfFile().then((filePath) {
                                completer.complete();

                                Share.shareFiles(
                                  ['$filePath'],
                                  text: 'CoE Examination Attendance',
                                );
                              });

                              FlashHelper.blockDialog(
                                context,
                                dismissCompleter: completer,
                              );
                            },
                          );
                          break;
                        case 'Export':
                          _showShareExportDialog(
                            title: 'Export as',
                            onTapCSV: () {
                              final completer = Completer();

                              createCSVFile().then((filePath) {
                                completer.complete();

                                toastMessage(_scaffoldKey.currentContext,
                                    "File saved at $filePath");
                              });

                              FlashHelper.blockDialog(
                                context,
                                dismissCompleter: completer,
                              );
                            },
                            onTapPDF: () {
                              final completer = Completer();

                              createPdfFile().then((filePath) {
                                completer.complete();

                                toastMessage(_scaffoldKey.currentContext,
                                    "File saved at $filePath");
                              });

                              FlashHelper.blockDialog(
                                context,
                                dismissCompleter: completer,
                              );
                            },
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
                              refreshRecords(_recordsContext);
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
                              refreshRecords(_recordsContext);
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

                                refreshRecords(_recordsContext);
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
                    _buildFilterResult()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BlocConsumer<RecordsBloc, RecordsState> _buildFilterResult() {
    return BlocConsumer<RecordsBloc, RecordsState>(
      listener: (context, state) {
        if (state is RecordsLoaded) {}
      },
      builder: (context, state) {
        if (state is RecordsInitial) {
          _recordsContext = context;
          refreshRecords(_recordsContext);
          return Loading();
        } else if (state is RecordsLoading) {
          return Loading();
        } else if (state is RecordsLoaded) {
          _attendanceRecords = state.attendanceRecords;
          return SingleChildScrollView(
            child: buildProctorsCard(context, _attendanceRecords),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  refreshRecords(BuildContext context) =>
      BlocProvider.of<RecordsBloc>(context).add(GetRecords(
          category: _selectedCategory,
          session: _selectedSession,
          date: _selectedDate));

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

  createPdfFile() async {
    return await generatePDF(_attendanceRecords);
  }

  createCSVFile() async {
    return await generateCSV(_attendanceRecords);
  }
}
