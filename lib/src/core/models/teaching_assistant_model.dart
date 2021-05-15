import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TeachingAssistantModel extends Equatable {
  int id;
  String name;
  String room;

  TeachingAssistantModel({this.id, this.name, this.room});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'room': room
    };

    return map;
  }

  // destruct map of inivigilators
  TeachingAssistantModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    room = map['room'];
  }

  @override
  List<Object> get props => [id, name, room];
}
