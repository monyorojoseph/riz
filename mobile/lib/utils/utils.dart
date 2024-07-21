import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('MMMM d, yyyy').format(date);
}
