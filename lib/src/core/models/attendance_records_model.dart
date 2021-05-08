import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class AttendanceRecordModel extends Equatable {
  int id;
  String name;
  String session;
  String category;
  String duration;
  String room;
  String date;
  int timestamp;
  String signImagePath;

  AttendanceRecordModel(
      {this.id,
      this.name,
      this.session,
      this.category,
      this.duration,
      this.room,
      this.date,
      this.timestamp,
      this.signImagePath});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'session': session,
      'category': category,
      'duration': duration,
      'room': room,
      'date': date,
      'timestamp': timestamp,
      'signImagePath': signImagePath
    };

    return map;
  }

  // destruct map of inivigilators
  AttendanceRecordModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    session = map['session'];
    category = map['category'];
    duration = map['duration'];
    room = map['room'];
    date = map['date'];
    timestamp = map['timestamp'];
    signImagePath = map['signImagePath'];
  }

  @override
  List<Object> get props =>
      [id, name, session, category, duration, date, timestamp, signImagePath];
}
