import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class AttendanceRecordsModel extends Equatable {
  int id;
  String name;
  String session;
  String category;
  String duration;
  String room;
  String dateTime;
  String signImagePath;

  AttendanceRecordsModel(
      {this.id,
      this.name,
      this.session,
      this.category,
      this.duration,
      this.room,
      this.dateTime,
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
      'dateTime': dateTime,
      'signImagePath': signImagePath
    };

    return map;
  }

  // destruct map of inivigilators
  AttendanceRecordsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    session = map['session'];
    category = map['category'];
    duration = map['duration'];
    room = map['room'];
    dateTime = map['dateTime'];
    signImagePath = map['signImagePath'];
  }

  @override
  List<Object> get props =>
      [id, name, session, category, duration, dateTime, signImagePath];
}
