import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class InvigiNamesModel extends Equatable {
  int id;
  String invigiName;

  InvigiNamesModel({this.id, this.invigiName});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'name': invigiName};

    return map;
  }

  // destruct map of inivigilators
  InvigiNamesModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    invigiName = map['name'];
  }

  @override
  List<Object> get props => [id, invigiName];
}
