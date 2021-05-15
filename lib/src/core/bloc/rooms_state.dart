part of 'rooms_bloc.dart';

abstract class RoomsState extends Equatable {
  const RoomsState();

  @override
  List<Object> get props => [];
}

class RoomsInitial extends RoomsState {
  const RoomsInitial();
}

class RoomsLoading extends RoomsState {
  const RoomsLoading();
}

class RoomsLoaded extends RoomsState {
  final List<AvailableRoomsModel> rooms;
  const RoomsLoaded({this.rooms});
}
