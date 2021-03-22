part of 'attendants_bloc.dart';

abstract class AttendantsEvent extends Equatable {
  const AttendantsEvent();

  @override
  List<Object> get props => [];
}


class GetAttendants extends AttendantsEvent {
  GetAttendants();
}
