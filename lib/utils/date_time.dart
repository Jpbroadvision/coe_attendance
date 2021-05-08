import 'package:intl/intl.dart';

class DateTimeHelper {
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String _formattedDate = formatter.format(now);

  int _timestamp = now.microsecondsSinceEpoch;

  String get formattedDate => _formattedDate;

  int get timestamp => _timestamp;
}