import 'package:get/get.dart';

import '../../../data/models/transaksi_model.dart';
import '../../transaksi/controllers/transaksi_controller.dart';

class LaporanController extends GetxController {
  final transaksiController = Get.find<TransaksiController>();

  final selectedMonth = 0.obs; // 0 = Semua Bulan
  final selectedYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    setDefaultCurrentYear();

    ever<List<TransaksiModel>>(transaksiController.transaksiList, (_) {
      applyFilter();
    });

    applyFilter();
  }

  void setDefaultCurrentYear() {
    selectedMonth.value = 0;
    selectedYear.value = DateTime.now().year;
  }

  Future<void> loadData() async {
    await transaksiController.loadTransaksi();
    applyFilter();
  }

  void setMonth(int month) {
    selectedMonth.value = month;
    applyFilter();
  }

  void setYear(int year) {
    selectedYear.value = year;
    applyFilter();
  }

  void resetFilter() {
    setDefaultCurrentYear();
    applyFilter();
  }

  List<TransaksiModel> get filteredTransaksi {
    final result = transaksiController.transaksiList.where((item) {
      final matchYear = item.tanggal.year == selectedYear.value;

      final matchMonth = selectedMonth.value == 0
          ? true
          : item.tanggal.month == selectedMonth.value;

      return matchYear && matchMonth;
    }).toList();

    result.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return result;
  }

  List<LaporanBulanan> get laporanBulanan {
    final Map<String, List<TransaksiModel>> grouped = {};

    for (final item in filteredTransaksi) {
      final key = '${item.tanggal.year}-${item.tanggal.month}';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }

    final result = grouped.entries.map((entry) {
      final items = entry.value;
      final firstDate = items.first.tanggal;

      final pemasukan = items
          .where((e) => e.tipe == 'pemasukan')
          .fold(0.0, (sum, item) => sum + item.nominal);

      final pengeluaran = items
          .where((e) => e.tipe == 'pengeluaran')
          .fold(0.0, (sum, item) => sum + item.nominal);

      return LaporanBulanan(
        year: firstDate.year,
        month: firstDate.month,
        totalPemasukan: pemasukan,
        totalPengeluaran: pengeluaran,
      );
    }).toList();

    result.sort((a, b) {
      final dateA = DateTime(a.year, a.month);
      final dateB = DateTime(b.year, b.month);
      return dateB.compareTo(dateA);
    });

    return result;
  }

  double get totalPemasukan {
    return filteredTransaksi
        .where((e) => e.tipe == 'pemasukan')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get totalPengeluaran {
    return filteredTransaksi
        .where((e) => e.tipe == 'pengeluaran')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get saldoSaatIni => totalPemasukan - totalPengeluaran;

  String get periodeText {
    if (selectedMonth.value == 0) {
      return 'Tahun ${selectedYear.value}';
    }

    return '${monthName(selectedMonth.value)} ${selectedYear.value}';
  }

  String get headerTitle {
    if (selectedMonth.value == 0) {
      return 'Laporan Tahun ${selectedYear.value}';
    }

    return 'Laporan ${monthName(selectedMonth.value)} ${selectedYear.value}';
  }

  List<int> get monthOptions {
    return List.generate(13, (index) => index);
  }

  List<int> get yearOptions {
    final now = DateTime.now().year;
    return List.generate(11, (index) => now - 5 + index);
  }

  String monthFilterName(int month) {
    if (month == 0) return 'Semua Bulan';
    return monthName(month);
  }

  String monthName(int month) {
    const bulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return bulan[month];
  }

  void applyFilter() {
    update();
  }
}

class LaporanBulanan {
  final int year;
  final int month;
  final double totalPemasukan;
  final double totalPengeluaran;

  const LaporanBulanan({
    required this.year,
    required this.month,
    required this.totalPemasukan,
    required this.totalPengeluaran,
  });

  double get sisaSaldo => totalPemasukan - totalPengeluaran;
}
