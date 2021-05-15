part of 'records_bloc.dart';

abstract class RecordsEvent extends Equatable {
  const RecordsEvent();

  @override
  List<Object> get props => [];
}

class GetRecords extends RecordsEvent {
  final String category;
  final String session;
  final String date;

  GetRecords({this.category, this.session, this.date});
}
