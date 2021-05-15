import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../locator.dart';
import '../models/available_rooms_model.dart';
import '../service/database_service.dart';

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
