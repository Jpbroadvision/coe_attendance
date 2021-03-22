import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coe_attendance/locator.dart';
import 'package:coe_attendance/models/available_rooms_model.dart';
import 'package:coe_attendance/service/database_service.dart';
import 'package:equatable/equatable.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  RoomsBloc() : super(RoomsInitial());
  final DatabaseService _databaseService = locator<DatabaseService>();

  @override
  Stream<RoomsState> mapEventToState(
    RoomsEvent event,
  ) async* {
    if (event is GetRooms) {
      yield RoomsLoading();

      final List<AvailableRoomsModel> result =
          await _databaseService.getAvailableRooms();

      yield RoomsLoaded(rooms: result);
    }
  }
}
