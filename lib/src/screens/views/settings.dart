import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../utils/flash_helper.dart';
import '../../core/service/database_service.dart';
import '../components/custom_appbar.dart';
import '../components/drawer.dart';
import '../components/toast_message.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                        title: 'Import Teaching Assistants',
                        description:
                            'NB: The file you are going to import must be a CSV file.\nIt must have two columns with the first column names and second classrooms assigned',
                        onTap: () async {
                          String csvFilePath = await getCSVFilePath();

                          try {
                            await _databaseService
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
                        title: 'Import Invigilators and Attendants',
                        description:
                            'NB: The file you are going to import must be a CSV file. It must have two columns with the first column consists names and second column consists categories',
                        onTap: () async {
                          String csvFilePath = await getCSVFilePath();

                          try {
                            await _databaseService
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
                        title: 'Import Available Rooms',
                        description:
                            'NB: The file you are going to import must be a CSV file. It must have only one column with their room numbers or names.',
                        onTap: () async {
                          String csvFilePath = await getCSVFilePath();

                          try {
                            await _databaseService
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
                        title: 'DELETE?',
                        description: 'Delete Teaching Assistants(TAs) data',
                        onTap: () async {
                          try {
                            await _databaseService
                                .dropTeachingAssistantsTable();
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
                        title: 'DELETE?',
                        description: 'Delete Proctors data',
                        onTap: () async {
                          try {
                            await _databaseService.dropProctorsTable();
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
                        title: 'DELETE?',
                        description: 'Delete Available Rooms data',
                        onTap: () async {
                          try {
                            await _databaseService.dropRoomsTable();
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
                        title: 'DELETE?',
                        description: 'Delete all attendance records',
                        onTap: () async {
                          try {
                            final result =
                                await _databaseService.getAttendanceRecords();

                            for (var attendanceRecord in result) {
                              await _databaseService.deleteAttendanceRecordById(
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
                        title: 'DELETE?',
                        description: 'Delete invigilators attendance records',
                        onTap: () async {
                          try {
                            final result = await _databaseService
                                .getAttendanceRecordsByCategory('Invigilator');

                            for (var attendanceRecord in result) {
                              await _databaseService.deleteAttendanceRecordById(
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
                        title: 'DELETE?',
                        description: 'Delete invigilators attendance records',
                        onTap: () async {
                          try {
                            final result = await _databaseService
                                .getAttendanceRecordsByCategory('Attendant');

                            for (var attendanceRecord in result) {
                              await _databaseService.deleteAttendanceRecordById(
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
                        title: 'DELETE?',
                        description:
                            'Delete traching assistants attendance records',
                        onTap: () async {
                          try {
                            final result = await _databaseService
                                .getAttendanceRecordsByCategory(
                                    'Teaching Assistant');

                            for (var attendanceRecord in result) {
                              await _databaseService.deleteAttendanceRecordById(
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
                        title: 'DELETE?',
                        description: 'Delete others attendance records',
                        onTap: () async {
                          try {
                            final result = await _databaseService
                                .getAttendanceRecordsByCategory('Other');

                            for (var attendanceRecord in result) {
                              await _databaseService.deleteAttendanceRecordById(
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

  void _showImportDialog({String title, String description, Function onTap}) {
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
