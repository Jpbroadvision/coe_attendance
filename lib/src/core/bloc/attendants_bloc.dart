import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../locator.dart';
import '../models/attendant_model.dart';
import '../service/database_service.dart';

part 'attendants_event.dart';
part 'attendants_state.dart';

class AttendantsBloc extends Bloc<AttendantsEvent, AttendantsState> {
  AttendantsBloc() : super(AttendantsInitial());
  final DatabaseService _databaseService = locator<DatabaseService>();

  @override
  Stream<AttendantsState> mapEventToState(
    AttendantsEvent event,
  ) async* {
    if (event is GetAttendants) {
      yield AttendantsLoading();

      final List<AttendantModel> result =
          await _databaseService.getAllAttendants();

      yield AttendantsLoaded(attendants: result);
    }
  }
}
