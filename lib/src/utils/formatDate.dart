import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatMonth(DateTime date) {
  return DateFormat('MM/yyyy').format(date);
}

String formatYear(DateTime date) {
  return DateFormat('yyyy').format(date);
}

DateTime formatTimeStamp(date) {
  return DateFormat('dd/MM/yyyy').parse(date);
}
