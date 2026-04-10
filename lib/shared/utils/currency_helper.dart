import 'package:intl/intl.dart';

class CurrencyHelper {
  CurrencyHelper._();

  static String toRupiah(num value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }
}
