part of 'attendants_bloc.dart';

abstract class AttendantsState extends Equatable {
  const AttendantsState();
  
  @override
  List<Object> get props => [];
}


class AttendantsInitial extends AttendantsState {
  const AttendantsInitial();
}

class AttendantsLoading extends AttendantsState {
  const AttendantsLoading();
}

class AttendantsLoaded extends AttendantsState {
  final List<AttendantModel> attendants;
  const AttendantsLoaded({this.attendants});
}