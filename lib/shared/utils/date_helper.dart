import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static String formatTanggal(DateTime value) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(value);
  }

  static String formatTanggalPendek(DateTime value) {
    return DateFormat('dd MMM', 'id_ID').format(value);
  }

  static String formatBulanTahun(DateTime value) {
    return DateFormat('MMMM yyyy', 'id_ID').format(value);
  }
}
