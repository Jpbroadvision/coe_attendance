part of 'teaching_assistants_bloc.dart';

abstract class TeachingAssistantsState extends Equatable {
  const TeachingAssistantsState();

  @override
  List<Object> get props => [];
}

class TeachingAssistantsInitial extends TeachingAssistantsState {
  const TeachingAssistantsInitial();
}

class TeachingAssistantsLoading extends TeachingAssistantsState {
  const TeachingAssistantsLoading();
}

class TeachingAssistantsLoaded extends TeachingAssistantsState {
  final List<TeachingAssistantModel> teachingAssistants;
  const TeachingAssistantsLoaded({this.teachingAssistants});
}
