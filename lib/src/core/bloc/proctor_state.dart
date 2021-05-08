part of 'proctor_bloc.dart';

abstract class ProctorsState extends Equatable {
  const ProctorsState();

  @override
  List<Object> get props => [];
}

class ProctorsInitial extends ProctorsState {
  const ProctorsInitial();
}

class ProctorsLoading extends ProctorsState {
  const ProctorsLoading();
}

class ProctorsLoaded extends ProctorsState {
  final List<ProctorModel> proctors;
  const ProctorsLoaded({this.proctors});
}
