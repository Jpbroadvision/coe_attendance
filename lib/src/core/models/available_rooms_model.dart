import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class AvailableRoomsModel extends Equatable {
  int id;
  String room;

  AvailableRoomsModel({this.id, this.room});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'room': room};

    return map;
  }

  // destruct map of inivigilators
  AvailableRoomsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    room = map['room'];
  }

  @override
  List<Object> get props => [id, room];
}
