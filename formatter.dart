import 'package:intl/intl.dart';

class Formatter {
  static String formatDate({required String dateString}) {
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(dateString));
    return formattedDate;
  }

  static String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(symbol: 'Rp. ', decimalDigits: 0);
    return formatter.format(amount);
  }

  static String formatNumber(num amount) {
    final formatter = NumberFormat.decimalPattern('id');
    return formatter.format(amount);
  }
}