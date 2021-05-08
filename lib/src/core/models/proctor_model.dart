import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ProctorModel extends Equatable {
  int id;
  String name;
  String category;

  ProctorModel({this.id, this.name, this.category});

  // converts inivigilators details to a Map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'name': name, 'category': category};

    return map;
  }

  // destruct map of inivigilators
  ProctorModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    category = map['category'];
  }

  @override
  List<Object> get props => [id, name, category];
}
