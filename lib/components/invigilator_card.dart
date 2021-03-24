import 'dart:io';

import 'package:flutter/material.dart';

import 'package:coe_attendance/models/attendance_records_model.dart';

class InvigilatorCard extends StatelessWidget {
  final AttendanceRecordsModel attendanceRecord;
  final Function deleteFunction;

  InvigilatorCard({@required this.attendanceRecord, this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 2.0,
      child: ExpansionTile(
        backgroundColor: Colors.white,
        childrenPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
        title: _buildTitle(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Session'),
              Text(
                '${attendanceRecord.session}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Duration'),
              Text(
                '${attendanceRecord.duration}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Room'),
              Text(
                '${attendanceRecord.room}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date/Time'),
              Text(
                '${attendanceRecord.dateTime}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  // title with arrow icon for expanded card
  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            ClipOval(
              child: Image.file(
                File(attendanceRecord.signImagePath), //assets/user-profile.png
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendanceRecord.name,
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '${attendanceRecord.category}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            deleteFunction(attendanceRecord.id);
          },
        ),
      ],
    );
  }
}
