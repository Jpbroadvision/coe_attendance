import 'package:coe_attendance/components/toast_message.dart';
import 'package:coe_attendance/service/database_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AttendanceImportCard extends StatelessWidget {
  final String title;
  final String description;
  final String category;

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
            title: buildCardTitle(context),
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
  Widget buildCardTitle(BuildContext context) {
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
              toastMessage(context,
                  "Failed to get CSV file.", Colors.red);

              return;
            }

            switch (category) {
              case "TEACHING_ASSISTANCE":
                try {
                  await databaseService.insertTeachingAssistantsCSV(csvFilePath);
                  toastMessage(context,
                      "TAs CSV file import was a success");
                } catch (e) {
                  toastMessage(context,
                      "Failed to get TAs CSV file.", Colors.red);
                }
                break;
              case "ATTENDANTS":
                try {
                  await databaseService.insertAttendantCSV(csvFilePath);
                  toastMessage(context,
                      "Attendant CSV file import was a success");
                } catch (e) {
                  toastMessage(context,
                      "Failed to get attendant CSV file.", Colors.red);
                }
                break;
              case "INVIGILATORS":
                try {
                  await databaseService.insertInvigilatorsCSV(csvFilePath);
                  toastMessage(context,
                      "Invigilators CSV file import was a success");
                } catch (e) {
                  toastMessage(context,
                      "Failed to import invigilators CSV file.", Colors.red);
                }
                break;
              case "AVAILABLE_ROOMS":
                try {
                  await databaseService.insertAvailableRoomsCSV(csvFilePath);
                  toastMessage(context,
                      "Available Rooms CSV file import was a success");
                } catch (e) {
                  toastMessage(context,
                      "Failed to import Available Rooms CSV file.", Colors.red);
                }
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
