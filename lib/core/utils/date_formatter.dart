import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy h:mm a').format(date);
  }

  static String formatDateLong(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  static String formatDateForInput(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatChartLabel(DateTime date) {
    return DateFormat('M/d').format(date);
  }
}
