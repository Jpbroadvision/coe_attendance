part of 'proctor_bloc.dart';

abstract class ProctorsEvent extends Equatable {
  const ProctorsEvent();

  @override
  List<Object> get props => [];
}

class GetProctors extends ProctorsEvent {
  GetProctors();
}
