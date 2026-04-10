import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static String formatTanggal(DateTime value) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(value);
  }
}
