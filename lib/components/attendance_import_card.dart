import 'package:coe_attendance/components/toast_message.dart';
import 'package:coe_attendance/service/database_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AttendanceImportCard extends StatelessWidget {
  final String title;
  final String description;
  final String category;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseService databaseService = DatabaseService();

  AttendanceImportCard({this.title, this.description, this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(bottom: 10.0),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            childrenPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
            title: buildCardTitle(),
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // title with arrow icon for expanded card
  Widget buildCardTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.file_upload,
            color: Colors.blueAccent,
          ),
          onPressed: () async {
            String csvFilePath = await getCSVFilePath();

            if (csvFilePath == "FAILED_TO_GET_FILE_PATH") {
              toastMessage(scaffoldKey.currentContext,
                  "Failed to get CSV file.", Colors.red);

              return;
            }

            switch (category) {
              case "TEACHING_ASSISTANCE":
                print("Importing TA");
                print(csvFilePath);
                databaseService.insertTeachingAssistantsCSV(csvFilePath);
                break;
              case "ATTENDANTS":
                print("Importing Attendants");
                print(csvFilePath);
                databaseService.insertAttendantCSV(csvFilePath);
                break;
              case "INVIGILATORS":
                print("Importing Invigilators");
                print(csvFilePath);
                databaseService.insertAttendantCSV(csvFilePath);
                break;
            }
          },
        )
      ],
    );
  }

  Future<String> getCSVFilePath() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      print("Import file path: ${result.files.single.path}");
      return result.files.single.path;
    } else {
      return "FAILED_TO_GET_FILE_PATH";
    }
  }
}
