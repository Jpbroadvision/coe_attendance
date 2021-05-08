import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../locator.dart';
import '../models/inivigilator_model.dart';
import '../service/database_service.dart';

part 'invigilators_event.dart';
part 'invigilators_state.dart';

class InvigilatorsBloc extends Bloc<InvigilatorsEvent, InvigilatorsState> {
  InvigilatorsBloc() : super(InvigilatorsInitial());
  final DatabaseService _databaseService = locator<DatabaseService>();

  @override
  Stream<InvigilatorsState> mapEventToState(
    InvigilatorsEvent event,
  ) async* {
    if (event is GetInvigilators) {
      yield InvigilatorsLoading();

      final List<InvigilatorsModel> result =
          await _databaseService.getAllInvigilators();

      yield InvigilatorsLoaded(invigilators: result);
    }
  }
}
