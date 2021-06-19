import 'dart:io';

import 'package:coe_proctors_attendance/src/core/models/attendance_records_model.dart';
import 'package:flutter/material.dart';

class ProctorCard extends StatelessWidget {
  final AttendanceRecordModel attendanceRecord;
  final Function deleteFunction;

  ProctorCard({@required this.attendanceRecord, this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 1.0,
      child: ExpansionTile(
        backgroundColor: Colors.white,
        childrenPadding: EdgeInsets.fromLTRB(25, 0, 25, 10),
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
              Text('Date'),
              Text(
                '${attendanceRecord.date}',
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
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: ClipOval(
        child: Material(
          shadowColor: Colors.grey.withOpacity(0.5),
          child: Image.file(
            File(attendanceRecord.signImagePath),
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        attendanceRecord.name,
        overflow: TextOverflow.clip,
        maxLines: 1,
        style: TextStyle(fontSize: 15),
      ),
      subtitle: Text(
        '${attendanceRecord.category}',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: deleteFunction,
      ),
    );
  }
}
