import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String format({String formatter = 'dd/MM/y'}) {
    return DateFormat(formatter).format(this);
  }
}