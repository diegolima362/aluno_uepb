import 'package:intl/intl.dart';

class Format {
  static String hours(DateTime date) {
    return DateFormat.Hm().format(date);
  }

  static String date(DateTime date) {
    return DateFormat.MMMEd('pt_Br').format(date);
  }

  static String dayOfWeek(DateTime date) {
    return DateFormat.E('pt_Br').format(date);
  }

  static String currency(double pay) {
    if (pay != 0.0) {
      final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
      return formatter.format(pay);
    }
    return '';
  }

  static dateFirebase(DateTime date) {
    return DateFormat('dMMMy').format(date).replaceAll('/', ' ');
  }
}
