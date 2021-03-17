import 'package:coe_attendance/models/inivigilators_details_model.dart';
import 'package:flutter/material.dart';

class ImportCard extends StatelessWidget {
  // final InvigilatorsDetailsModel invigilatorsDetails;
  // final Function deleteFunction;

  // ImportCard({@required this.invigilatorsDetails, this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(bottom: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          elevation: 2.0,
          child: ExpansionTile(
            backgroundColor: Colors.white,
            childrenPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
            title: _importTypeTitleTAs(),
            children: [
              Row(
                children: [
                  Text('NOTICE:'),
                  Text(
                    'The file you are going to import must be a CSV file.\nIt must have two columns with the first column names and second classrooms assigned',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.only(bottom: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          elevation: 2.0,
          child: ExpansionTile(
            backgroundColor: Colors.white,
            childrenPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
            title: _importTypeTitleAttendants(),
            children: [
              Row(
                children: [
                  Text('NOTICE:'),
                  Text(
                    'The file you are going to import must be a CSV file.\nIt must have two columns with the first column names and second classrooms assigned',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.only(bottom: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          elevation: 2.0,
          child: ExpansionTile(
            backgroundColor: Colors.white,
            childrenPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
            title: _importTypeTitleInvigilators(),
            children: [
              Row(
                children: [
                  Text('NOTICE:'),
                  Text(
                    'The file you are going to import must be a CSV file.\nIt must have only one column with their names',
                    style: TextStyle(fontSize: 12),
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
            color: Colors.white,
          ),
          onPressed: () async {
            debugPrint("Import TAs list clicked");
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
            color: Colors.white,
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
            color: Colors.white,
          ),
          onPressed: () async {
            debugPrint("Import Iniligialtors list clicked");
          },
        )
      ],
    );
  }
}
