import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../locator.dart';
import '../models/attendance_records_model.dart';
import '../service/database_service.dart';

part 'records_event.dart';
part 'records_state.dart';

class RecordsBloc extends Bloc<RecordsEvent, RecordsState> {
  RecordsBloc() : super(RecordsInitial());
  final DatabaseService _databaseService = locator<DatabaseService>();

  @override
  Stream<RecordsState> mapEventToState(
    RecordsEvent event,
  ) async* {
    if (event is GetRecords) {
      yield RecordsLoading();

      final List<AttendanceRecordModel> attendanceRecords =
          await _databaseService.getAttendanceRecords();

      List<AttendanceRecordModel> result;

      if (event.session == 'All' && event.category == 'All') {
        result = attendanceRecords.where((record) => record.date == event.date).toList();

        yield RecordsLoaded(attendanceRecords: result);
      } else if (event.session == 'All') {
        result = attendanceRecords.where((record) =>
            record.category == event.category && record.date == event.date).toList();

        yield RecordsLoaded(attendanceRecords: result);
      } else if (event.category == 'All') {
        result = attendanceRecords.where((record) =>
            record.session == event.session && record.date == event.date).toList();

        yield RecordsLoaded(attendanceRecords: result);
      } else {
        result = attendanceRecords.where((record) =>
            record.category == event.category &&
            record.session == event.session &&
            record.date == event.date).toList();

        yield RecordsLoaded(attendanceRecords: result);
      }
    }
  }
}
