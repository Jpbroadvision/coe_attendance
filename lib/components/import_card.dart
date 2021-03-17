import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

class ImportCard extends StatelessWidget {
  // final InvigilatorsDetailsModel invigilatorsDetails;
  // final Function deleteFunction;

  // ImportCard({@required this.invigilatorsDetails, this.deleteFunction});

// Call this function to get the results
  pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      final input = new File(file.path).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      print(fields);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(bottom: 5.0),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            childrenPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
            title: _importTypeTitleTAs(),
            children: [
              Row(
                children: [
                  Text(
                    'NB: The file you are going to import must be a CSV file.\nIt must have two columns with the first column names and second classrooms assigned',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.only(bottom: 5.0),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            childrenPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
            title: _importTypeTitleAttendants(),
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'NB: The file you are going to import must be a CSV file. It must have two columns with the first column names and second classrooms assigned',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.only(bottom: 10.0),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            childrenPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
            title: _importTypeTitleInvigilators(),
            children: [
              Row(
                children: [
                  Container(
                    child: Text(
                      'NB: The file you are going to import must be a CSV file.\nIt must have only one column with their names.',
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
  Widget _importTypeTitleTAs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Teaching Assistance (TAs)",
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Attendance List',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )
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
            pickFile();
          },
        )
      ],
    );
  }

  Widget _importTypeTitleAttendants() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attendants",
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Attendants List',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )
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
            debugPrint("Import attandats list clicked");
          },
        )
      ],
    );
  }

  Widget _importTypeTitleInvigilators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Invigilators",
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Attendance List',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )
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
            debugPrint("Import Iniligialtors list clicked");
          },
        )
      ],
    );
  }
}
