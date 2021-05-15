import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../locator.dart';
import '../../../utils/teaching_assistant_allocation.dart';
import '../models/teaching_assistant_model.dart';
import '../service/database_service.dart';

part 'teaching_assistants_event.dart';
part 'teaching_assistants_state.dart';

class TeachingAssistantsBloc
    extends Bloc<TeachingAssistantsEvent, TeachingAssistantsState> {
  TeachingAssistantsBloc() : super(TeachingAssistantsInitial());
  final DatabaseService _databaseService = locator<DatabaseService>();

  @override
  Stream<TeachingAssistantsState> mapEventToState(
    TeachingAssistantsEvent event,
  ) async* {
    if (event is GetTeachingAssistants) {
      yield TeachingAssistantsLoading();

      final Map<String, List<TeachingAssistantModel>> result =
          await TeachingAssistantAllocation(_databaseService).getAllocations();

      yield TeachingAssistantsLoaded(teachingAssistants: result[event.room]);
    }
  }
}
