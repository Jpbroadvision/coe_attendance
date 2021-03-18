import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TaNamesModel extends Equatable {
  int id;
  String taName;
  String taRoomAlloc;

  TaNamesModel({this.id, this.taName, this.taRoomAlloc});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'taName': taName,
      'taRoomAlloc': taRoomAlloc
    };

    return map;
  }

  // destruct map of inivigilators
  TaNamesModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    taName = map['taName'];
    taRoomAlloc = map['taRoomAlloc'];
  }

  @override
  List<Object> get props => [id, taName, taRoomAlloc];
}
