import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class InvigilatorsDetailsModel extends Equatable {
  int id;
  String invigiName;
  String session;
  String category;
  String duration;
  String room;
  String dateTime;
  String signImage;

  InvigilatorsDetailsModel(
      {this.id,
      this.invigiName,
      this.session,
      this.category,
      this.duration,
      this.room,
      this.dateTime,
      this.signImage});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': invigiName,
      'session': session,
      'category': category,
      'duration': duration,
      'room': room,
      'dateTime': dateTime,
      'signImage': signImage
    };

    return map;
  }

  // destruct map of inivigilators
  InvigilatorsDetailsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    invigiName = map['name'];
    session = map['session'];
    category = map['category'];
    duration = map['duration'];
    room = map['room'];
    dateTime = map['dateTime'];
    signImage = map['signImage'];
  }

  @override
  List<Object> get props =>
      [id, invigiName, session, category, duration, dateTime, signImage];
}
