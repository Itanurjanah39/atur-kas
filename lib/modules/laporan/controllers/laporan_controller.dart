import 'package:get/get.dart';

import '../../../data/models/transaksi_model.dart';
import '../../transaksi/controllers/transaksi_controller.dart';

class LaporanController extends GetxController {
  final TransaksiController transaksiController =
      Get.find<TransaksiController>();

  final selectedJenis = 'semua'.obs;
  final selectedPeriode = 'semua'.obs;
  final selectedKategori = 'semua'.obs;

  void setJenis(String value) {
    selectedJenis.value = value;
  }

  void setPeriode(String value) {
    selectedPeriode.value = value;
  }

  void setKategori(String value) {
    selectedKategori.value = value;
  }

  List<String> get kategoriList {
    final categories = transaksiController.transaksiList
        .map((e) => (e.kategori ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    categories.sort();
    return ['semua', ...categories];
  }

  List<TransaksiModel> get filteredTransaksi {
    final now = DateTime.now();

    return transaksiController.transaksiList.where((item) {
      final matchJenis = selectedJenis.value == 'semua'
          ? true
          : item.tipe == selectedJenis.value;

      final matchKategori = selectedKategori.value == 'semua'
          ? true
          : item.kategori == selectedKategori.value;

      bool matchPeriode = true;

      if (selectedPeriode.value == 'harian') {
        matchPeriode =
            item.tanggal.year == now.year &&
            item.tanggal.month == now.month &&
            item.tanggal.day == now.day;
      } else if (selectedPeriode.value == 'bulanan') {
        matchPeriode =
            item.tanggal.year == now.year && item.tanggal.month == now.month;
      } else if (selectedPeriode.value == 'tahunan') {
        matchPeriode = item.tanggal.year == now.year;
      }

      return matchJenis && matchKategori && matchPeriode;
    }).toList()..sort((a, b) => b.tanggal.compareTo(a.tanggal));
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

  double get saldo => totalPemasukan - totalPengeluaran;
}
