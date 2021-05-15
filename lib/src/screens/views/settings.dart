import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../core/service/database_service.dart';
import '../components/custom_appbar.dart';
import '../components/custom_dialog.dart';
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 10),
                  buildImportTile(
                    title: "Teaching Assistants(TAs)",
                    onIconTap: () {
                      showCustomDialog(
                        context: context,
                        title: 'Import Teaching Assistants',
                        body: Text(
                            'NB: The file you are going to import must be a CSV file.\nIt must have two columns with the first column names and second classrooms assigned'),
                        action: buildBtn(
                          onPressed: () async {
                            String csvFilePath = await getCSVFilePath();

                            try {
                              await _databaseService
                                  .insertTeachingAssistantsCSV(csvFilePath);
                              toastMessage(
                                  context, "TAs CSV file import was a success");
                            } catch (e) {
                              toastMessage(context,
                                  "Failed to get TAs CSV file.", Colors.red);
                            }
                          },
                        ),
                      );
                    },
                  ),
                  buildImportTile(
                    title: "Proctors",
                    onIconTap: () {
                      showCustomDialog(
                        context: context,
                        title: 'Import Invigilators and Attendants',
                        body: Text(
                          'NB: The file you are going to import must be a CSV file. It must have two columns with the first column consists names and second column consists categories',
                        ),
                        action: buildBtn(
                          onPressed: () async {
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
                        ),
                      );
                    },
                  ),
                  buildImportTile(
                    title: "Available Rooms",
                    onIconTap: () {
                      showCustomDialog(
                        context: context,
                        title: 'Import Available Rooms',
                        body: Text(
                            'NB: The file you are going to import must be a CSV file. It must have only one column with their room numbers or names.'),
                        action: buildBtn(
                          onPressed: () async {
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
                        ),
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

  Widget buildImportTile({String title, Function onIconTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        GestureDetector(
          onTap: onIconTap,
          child: Icon(
            Icons.file_upload,
            color: Theme.of(context).primaryColor,
          ),
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
}