import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class CurrencyFormatter {
  static String format(double amount, {bool showSign = false}) {
    final formatter = NumberFormat('#,##0.00');
    final formattedAmount = formatter.format(amount.abs());

    if (showSign) {
      return '${amount >= 0 ? '+' : '-'}${AppConstants.currency} $formattedAmount';
    }

    return '${AppConstants.currency} $formattedAmount';
  }

  static String formatWithType(double amount, String type) {
    final formatter = NumberFormat('#,##0.00');
    final formattedAmount = formatter.format(amount);

    if (type == 'expense') {
      return '-${AppConstants.currency} $formattedAmount';
    } else {
      return '+${AppConstants.currency} $formattedAmount';
    }
  }
}
