import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/flash_helper.dart';
import '../components/custom_appbar.dart';
import '../components/drawer.dart';
import '../components/toast_message.dart';
import '../providers/service_providers.dart';

class SettingsScreen extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final databaseService = watch(dbServiceProvider);

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
              title: 'Settings',
              scaffoldKey: _scaffoldKey,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Import data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: "Teaching Assistants(TAs)",
                    icon: Icon(
                      Icons.file_upload,
                      color: Theme.of(context).primaryColor,
                    ),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'Import Teaching Assistants',
                        description:
                            'NB: The file you are going to import must be a CSV file.\nIt must have two columns with the first column classrooms and second TA names assigned\nDO NOT add any headings to the columns',
                        onTap: () async {
                          String csvFilePath = await getCSVFilePath();

                          try {
                            await databaseService
                                .insertTeachingAssistantsCSV(csvFilePath);
                            toastMessage(
                                context, "TAs CSV file import was a success");
                          } catch (e) {
                            toastMessage(context, "Failed to get TAs CSV file.",
                                Colors.red);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: "Proctors",
                    icon: Icon(
                      Icons.file_upload,
                      color: Theme.of(context).primaryColor,
                    ),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'Import Invigilators and Attendants',
                        description:
                            'NB: The file you are going to import must be a CSV file. It must have two columns with the first column consists names and second column consists categories(Invigilators or Attendant).\nDO NOT add any headings to the columns',
                        onTap: () async {
                          String csvFilePath = await getCSVFilePath();

                          try {
                            await databaseService
                                .insertProctorsCSV(csvFilePath);
                            toastMessage(context,
                                "Proctors CSV file import was a success");
                          } catch (e) {
                            toastMessage(
                                context,
                                "Failed to import Proctors CSV file.",
                                Colors.red);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: "Available Rooms",
                    icon: Icon(
                      Icons.file_upload,
                      color: Theme.of(context).primaryColor,
                    ),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'Import Available Rooms',
                        description:
                            'NB: The file you are going to import must be a CSV file. It must have only one column with their room numbers or names.\nDO NOT add any headings to the column',
                        onTap: () async {
                          String csvFilePath = await getCSVFilePath();

                          try {
                            await databaseService
                                .insertAvailableRoomsCSV(csvFilePath);
                            toastMessage(context,
                                "Available Rooms CSV file import was a success");
                          } catch (e) {
                            toastMessage(
                                context,
                                "Failed to import Available Rooms CSV file.",
                                Colors.red);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Delete data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: "Teaching Assistants(TAs)",
                    icon: Icon(Icons.delete, color: Colors.red),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'DELETE?',
                        description: 'Delete Teaching Assistants(TAs) data',
                        onTap: () async {
                          try {
                            await databaseService.dropTeachingAssistantsTable();
                            toastMessage(
                              context,
                              "Operation was a success",
                            );
                          } catch (e) {
                            toastMessage(
                                context, "Failed delete data", Colors.red);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: "Proctors",
                    icon: Icon(Icons.delete, color: Colors.red),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'DELETE?',
                        description: 'Delete Proctors data',
                        onTap: () async {
                          try {
                            await databaseService.dropProctorsTable();
                            toastMessage(
                              context,
                              "Operation was a success",
                            );
                          } catch (e) {
                            toastMessage(
                                context, "Failed delete data", Colors.red);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: "Available Rooms",
                    icon: Icon(Icons.delete, color: Colors.red),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'DELETE?',
                        description: 'Delete Available Rooms data',
                        onTap: () async {
                          try {
                            await databaseService.dropRoomsTable();
                            toastMessage(
                              context,
                              "Operation was a success",
                            );
                          } catch (e) {
                            toastMessage(
                                context, "Failed delete data", Colors.red);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Delete Attendance records',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: 'All',
                    icon: Icon(Icons.delete, color: Colors.red),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'DELETE?',
                        description: 'Delete all attendance records',
                        onTap: () async {
                          try {
                            final result =
                                await databaseService.getAttendanceRecords();

                            for (var attendanceRecord in result) {
                              await databaseService.deleteAttendanceRecordById(
                                  attendanceRecord.id);
                            }

                            toastMessage(
                              context,
                              "Operation was a success",
                            );
                          } catch (e) {
                            toastMessage(
                                context, "Failed delete data", Colors.red);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: "Invigilators only",
                    icon: Icon(Icons.delete, color: Colors.red),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'DELETE?',
                        description: 'Delete invigilators attendance records',
                        onTap: () async {
                          try {
                            final result = await databaseService
                                .getAttendanceRecordsByCategory('Invigilator');

                            for (var attendanceRecord in result) {
                              await databaseService.deleteAttendanceRecordById(
                                  attendanceRecord.id);
                            }

                            toastMessage(
                              context,
                              "Operation was a success",
                            );
                          } catch (e) {
                            toastMessage(
                                context, "Failed delete data", Colors.red);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: "Attendants only",
                    icon: Icon(Icons.delete, color: Colors.red),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'DELETE?',
                        description: 'Delete invigilators attendance records',
                        onTap: () async {
                          try {
                            final result = await databaseService
                                .getAttendanceRecordsByCategory('Attendant');

                            for (var attendanceRecord in result) {
                              await databaseService.deleteAttendanceRecordById(
                                  attendanceRecord.id);
                            }

                            toastMessage(
                              context,
                              "Operation was a success",
                            );
                          } catch (e) {
                            toastMessage(
                                context, "Failed delete data", Colors.red);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: "Teaching Assistants only",
                    icon: Icon(Icons.delete, color: Colors.red),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'DELETE?',
                        description:
                            'Delete traching assistants attendance records',
                        onTap: () async {
                          try {
                            final result = await databaseService
                                .getAttendanceRecordsByCategory(
                                    'Teaching Assistant');

                            for (var attendanceRecord in result) {
                              await databaseService.deleteAttendanceRecordById(
                                  attendanceRecord.id);
                            }

                            toastMessage(
                              context,
                              "Operation was a success",
                            );
                          } catch (e) {
                            toastMessage(
                                context, "Failed delete data", Colors.red);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildListTile(
                    title: "Others only",
                    icon: Icon(Icons.delete, color: Colors.red),
                    onIconTap: () {
                      _showImportDialog(
                        context,
                        title: 'DELETE?',
                        description: 'Delete others attendance records',
                        onTap: () async {
                          try {
                            final result = await databaseService
                                .getAttendanceRecordsByCategory('Other');

                            for (var attendanceRecord in result) {
                              await databaseService.deleteAttendanceRecordById(
                                  attendanceRecord.id);
                            }

                            toastMessage(
                              context,
                              "Operation was a success",
                            );
                          } catch (e) {
                            toastMessage(
                                context, "Failed delete data", Colors.red);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> getCSVFilePath() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      print("Import file path: ${result.files.single.path}");
      return result.files.single.path;
    } else {
      return null;
    }
  }

  Widget _buildListTile({String title, Widget icon, Function onIconTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        GestureDetector(
          onTap: onIconTap,
          child: icon,
        ),
      ],
    );
  }

  buildBtn({Function onPressed}) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        height: 40,
        width: 100,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text("OK",
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
    );
  }

  void _showImportDialog(BuildContext context,
      {String title, String description, Function onTap}) {
    FlashHelper.customDialog(
      context,
      titleBuilder: (context, controller, setState) {
        return Text(title);
      },
      messageBuilder: (context, controller, setState) {
        return Text(description);
      },
      negativeAction: (context, controller, setState) {
        return TextButton(
          child: Text('Cancel'),
          onPressed: () => controller.dismiss(),
        );
      },
      positiveAction: (context, controller, setState) {
        return TextButton(
          child: Text('Okay'),
          onPressed: () {
            onTap();
            controller.dismiss();
          },
        );
      },
    );
  }
}
