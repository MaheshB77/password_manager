import 'package:intl/intl.dart';

String getMMYY(DateTime? date) {
  if (date == null) return '';
  return DateFormat('MM-yy').format(date);
}

String getDDMMYYYY(DateTime? date) {
  if (date == null) return '';
  return DateFormat('dd-MM-yyyy').format(date);
}