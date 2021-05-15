part of 'teaching_assistants_bloc.dart';

abstract class TeachingAssistantsEvent extends Equatable {
  const TeachingAssistantsEvent();

  @override
  List<Object> get props => [];
}

class GetTeachingAssistants extends TeachingAssistantsEvent {
  final String room;
  GetTeachingAssistants({this.room});
}
