import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class AttNamesModel extends Equatable {
  int id;
  String attName;

  AttNamesModel({this.id, this.attName});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'attName': attName};

    return map;
  }

  // destruct map of inivigilators
  AttNamesModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    attName = map['attName'];
  }

  @override
  List<Object> get props => [id, attName];
}
