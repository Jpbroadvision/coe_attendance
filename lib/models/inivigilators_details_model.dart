import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class InvigilatorsDetailsModel extends Equatable {
  int id;
  String name;
  String session;
  String startTime;
  String endTime;
  String room;
  String day;
  String dateTime;
  String signImage;

  InvigilatorsDetailsModel(
      {this.id,
      this.name,
      this.session,
      this.startTime,
      this.endTime,
      this.room,
      this.day,
      this.dateTime,
      this.signImage});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'session': session,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'day': day,
      'dateTime': dateTime,
      'signImage': signImage
    };

    return map;
  }

  // destruct map of inivigilators
  InvigilatorsDetailsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    session = map['session'];
    startTime = map['startTime'];
    endTime = map['endTime'];
    room = map['room'];
    day = map['day'];
    dateTime = map['dateTime'];
    signImage = map['signImage'];
  }

  @override
  List<Object> get props =>
      [id, name, session, startTime, endTime, day, dateTime, signImage];
}
