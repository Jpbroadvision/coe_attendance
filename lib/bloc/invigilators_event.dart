part of 'invigilators_bloc.dart';

abstract class InvigilatorsEvent extends Equatable {
  const InvigilatorsEvent();

  @override
  List<Object> get props => [];
}

class GetInvigilators extends InvigilatorsEvent {
  GetInvigilators();
}
