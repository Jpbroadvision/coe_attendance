part of 'invigilators_bloc.dart';

abstract class InvigilatorsState extends Equatable {
  const InvigilatorsState();

  @override
  List<Object> get props => [];
}

class InvigilatorsInitial extends InvigilatorsState {
  const InvigilatorsInitial();
}

class InvigilatorsLoading extends InvigilatorsState {
  const InvigilatorsLoading();
}

class InvigilatorsLoaded extends InvigilatorsState {
  final List<InvigilatorsModel> invigilators;
  const InvigilatorsLoaded({this.invigilators});
}
