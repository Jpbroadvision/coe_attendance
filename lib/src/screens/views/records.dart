import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';

import '../../../utils/csv_generator.dart';
import '../../../utils/flash_helper.dart';
import '../../../utils/pdf_document.dart';
import '../../core/models/attendance_records_model.dart';
import '../components/custom_appbar.dart';
import '../components/custom_dropdown.dart';
import '../components/drawer.dart';
import '../components/proctor_card.dart';
import '../components/toast_message.dart';
import '../providers/service_providers.dart';

final selectedDateProvider = StateProvider.autoDispose<String>((ref) {
  final datetimeHelper = ref.watch(datetimeHelperProvider);

  return datetimeHelper.formattedDate;
});

final categoriesProvider = Provider.autoDispose<List<String>>((ref) => [
      'Select category',
      'All',
      'Teaching Assistant',
      'Invigilator',
      'Attendant',
      'Other'
    ]);

final selectedCategoryProvider = StateProvider.autoDispose<String>((ref) {
  final categories = ref.watch(categoriesProvider);

  return categories.first;
});

final sessionsProvider = Provider.autoDispose<List<String>>(
    (ref) => ['Select session', 'All', '1', '2', '3', '4', '5', '6', '7']);

final selectedSessionProvider = StateProvider.autoDispose<String>((ref) {
  final sessions = ref.watch(sessionsProvider);

  return sessions.first;
});

final toggleFilterProvider = StateProvider.autoDispose<bool>((ref) => false);

final attendanceRecordFilterProvider =
    StateProvider.autoDispose<AttendanceRecordFilter>((ref) {
  final session = ref.watch(selectedSessionProvider);
  final category = ref.watch(selectedCategoryProvider);
  final datetime = ref.watch(selectedDateProvider);

  return AttendanceRecordFilter(
      category: category.state, session: session.state, date: datetime.state);
});

final attendanceRecordsProvider =
    FutureProvider.autoDispose<List<AttendanceRecordModel>>((ref) {
  final dbService = ref.watch(dbServiceProvider);
  return dbService.getAttendanceRecords();
});

final filteredAttendanceRecordsProvider =
    Provider.autoDispose<List<AttendanceRecordModel>>((ref) {
  final attendanceRecords = ref.watch(attendanceRecordsProvider);

  final attendanceRecordFilter = ref.watch(attendanceRecordFilterProvider);
  List<AttendanceRecordModel> result = [];

  attendanceRecords.whenData((value) {
    if (attendanceRecordFilter.state.session == 'All' &&
        attendanceRecordFilter.state.category == 'All') {
      result = value
          .where((record) => record.date == attendanceRecordFilter.state.date)
          .toList();
    } else if (attendanceRecordFilter.state.session == 'All') {
      result = value
          .where((record) =>
              record.category == attendanceRecordFilter.state.category &&
              record.date == attendanceRecordFilter.state.date)
          .toList();
    } else if (attendanceRecordFilter.state.category == 'All') {
      result = value
          .where((record) =>
              record.session == attendanceRecordFilter.state.session &&
              record.date == attendanceRecordFilter.state.date)
          .toList();
    } else {
      result = value
          .where((record) =>
              record.category == attendanceRecordFilter.state.category &&
              record.session == attendanceRecordFilter.state.session &&
              record.date == attendanceRecordFilter.state.date)
          .toList();
    }
  });

  return result;
});

class AttendanceRecordFilter extends Equatable {
  final String category;
  final String date;
  final String session;

  AttendanceRecordFilter(
      {@required this.category, @required this.session, @required this.date});

  @override
  List<Object> get props => [category, session, date];
}

class Records extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                          context,
                          title: 'Share as',
                          onTapCSV: () {
                            final completer = Completer();

                            createCSVFile(context).then((filePath) {
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

                            createPdfFile(context).then((filePath) {
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
                          context,
                          title: 'Export as',
                          onTapCSV: () {
                            final completer = Completer();

                            createCSVFile(context).then((filePath) {
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

                            createPdfFile(context).then((filePath) {
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
                      Consumer(
                        builder: (contex, watch, child) {
                          final toggleFilter = watch(toggleFilterProvider);

                          return IconButton(
                              icon: Icon(
                                toggleFilter.state
                                    ? Icons.remove_circle
                                    : Icons.add_circle,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                              onPressed: () {
                                toggleFilter.state = !toggleFilter.state;
                              });
                        },
                      ),
                    ],
                  ),
                  buildFilterWidget(context),
                  Text(
                    "Filter result",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  _buildFilterResult(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterWidget(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final selectedDate = watch(selectedDateProvider);
        final selectedCategory = watch(selectedCategoryProvider);
        final selectedSession = watch(selectedSessionProvider);
        final categories = watch(categoriesProvider);
        final sessions = watch(sessionsProvider);
        final toggleFilter = watch(toggleFilterProvider);

        List<DropdownMenuItem<String>> categoriesDropdownList =
            _buildDropdownList(categories);

        List<DropdownMenuItem<String>> sessionsDropdownList =
            _buildDropdownList(sessions);

        return toggleFilter.state
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category"),
                  SizedBox(height: 5.0),
                  CustomDropdown(
                    dropdownMenuItemList: categoriesDropdownList,
                    onChanged: (value) {
                      selectedCategory.state = value;

                      /* refreshRecords(_recordsContext); */
                    },
                    value: selectedCategory.state,
                    isEnabled: true,
                  ),
                  SizedBox(height: 15),
                  Text("Session"),
                  SizedBox(height: 5.0),
                  CustomDropdown(
                    dropdownMenuItemList: sessionsDropdownList,
                    onChanged: (value) {
                      selectedSession.state = value;

                      // refreshRecords(_recordsContext);
                    },
                    value: selectedSession.state,
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
                          maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
                        String dateToStr = date.toString();

                        selectedDate.state = dateToStr.split(' ')[0];

                        // refreshRecords(_recordsContext);
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
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
                            " ${selectedDate.state}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              )
            : SizedBox();
      },
    );
  }

  _buildFilterResult(BuildContext context) {

    return SingleChildScrollView(
      child: Consumer(
        builder: (context, watch, child) {
          final dbService = watch(dbServiceProvider);
          final filteredAttendanceRecords =
              watch(filteredAttendanceRecordsProvider);

          return Column(
              children: filteredAttendanceRecords.isEmpty
                  ? [Text("No record saved.")]
                  : filteredAttendanceRecords
                      .map(
                        (attendanceRecord) => ProctorCard(
                          attendanceRecord: attendanceRecord,
                          deleteFunction: () async {
                            await dbService.deleteAttendanceRecordById(
                                attendanceRecord.id);

                            //refresh list of Proctors

                            toastMessage(_scaffoldKey.currentContext,
                                "Delete successful");
                          },
                        ),
                      )
                      .toList());
        },
      ),
    );
  }

  void _showShareExportDialog(BuildContext context,
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

  createPdfFile(BuildContext context) async {
    final attendanceRecords = context.read(filteredAttendanceRecordsProvider);
    return await generatePDF(attendanceRecords);
  }

  createCSVFile(BuildContext context) async {
    final attendanceRecords = context.read(filteredAttendanceRecordsProvider);
    return await generateCSV(attendanceRecords);
  }
}
