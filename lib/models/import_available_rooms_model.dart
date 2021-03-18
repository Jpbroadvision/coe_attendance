import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class AvailableRoomsModel extends Equatable {
  int id;
  String roomAllocations;

  AvailableRoomsModel({this.id, this.roomAllocations});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'roomAllocations': roomAllocations};

    return map;
  }

  // destruct map of inivigilators
  AvailableRoomsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    roomAllocations = map['roomAllocations'];
  }

  @override
  List<Object> get props => [id, roomAllocations];
}
