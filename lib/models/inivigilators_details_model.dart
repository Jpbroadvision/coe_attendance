import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class InvigilatorsDetailsModel extends Equatable {
  int id;
  String name;
  String session;
  String startTime;
  String endTime;
  String room;
  String date;
  String signatureImg;

  InvigilatorsDetailsModel(
      {this.id,
      this.name,
      this.session,
      this.startTime,
      this.endTime,
      this.room,
      this.date,
      this.signatureImg});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'session': session,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'date': date,
      'signatureImagePath': signatureImg,
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
    date = map['date'];
    signatureImg = map['signatureImagePath'];
  }

  @override
  List<Object> get props =>
      [id, name, session, startTime, endTime, date, signatureImg];
}
