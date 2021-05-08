import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../locator.dart';
import '../models/proctor_model.dart';
import '../service/database_service.dart';

part 'proctor_event.dart';
part 'proctor_state.dart';

class ProctorsBloc extends Bloc<ProctorsEvent, ProctorsState> {
  ProctorsBloc() : super(ProctorsInitial());
  final DatabaseService _databaseService = locator<DatabaseService>();

  @override
  Stream<ProctorsState> mapEventToState(
    ProctorsEvent event,
  ) async* {
    if (event is GetProctors) {
      yield ProctorsLoading();

      final List<ProctorModel> result =
          await _databaseService.getProctors();

      yield ProctorsLoaded(proctors: result);
    }
  }
}
