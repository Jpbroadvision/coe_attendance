part of 'records_bloc.dart';

abstract class RecordsState extends Equatable {
  const RecordsState();

  @override
  List<Object> get props => [];
}

class RecordsInitial extends RecordsState {
  const RecordsInitial();
}

class RecordsLoading extends RecordsState {
  const RecordsLoading();
}

class RecordsLoaded extends RecordsState {
  final List<AttendanceRecordModel> attendanceRecords;
  const RecordsLoaded({this.attendanceRecords});
}
