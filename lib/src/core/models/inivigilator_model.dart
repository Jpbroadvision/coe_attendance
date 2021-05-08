import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class InvigilatorsModel extends Equatable {
  int id;
  String invigiName;

  InvigilatorsModel({this.id, this.invigiName});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'invigiName': invigiName};

    return map;
  }

  // destruct map of inivigilators
  InvigilatorsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    invigiName = map['invigiName'];
  }

  @override
  List<Object> get props => [id, invigiName];
}
