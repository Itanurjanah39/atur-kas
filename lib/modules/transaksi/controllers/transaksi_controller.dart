import 'package:get/get.dart';

import '../../../data/models/transaksi_model.dart';
import '../../../data/repositories/transaksi_repository.dart';

class TransaksiController extends GetxController {
  final TransaksiRepository _repository = TransaksiRepository();

  final transaksiList = <TransaksiModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransaksi();
  }

  Future<void> loadTransaksi() async {
    isLoading.value = true;

    final data = _repository.getAll();
    data.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    transaksiList.assignAll(data);

    isLoading.value = false;
  }

  Future<void> tambahTransaksi({
    required DateTime tanggal,
    required String keterangan,
    required double nominal,
    required String tipe,
    String? kategori,
  }) async {
    final now = DateTime.now();

    final transaksi = TransaksiModel(
      id: now.microsecondsSinceEpoch.toString(),
      tanggal: tanggal,
      keterangan: keterangan,
      nominal: nominal,
      tipe: tipe,
      kategori: kategori,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.add(transaksi);
    await loadTransaksi();
  }

  Future<void> editTransaksi(TransaksiModel transaksi) async {
    await _repository.update(transaksi.copyWith(updatedAt: DateTime.now()));
    await loadTransaksi();
  }

  Future<void> hapusTransaksi(String id) async {
    await _repository.delete(id);
    await loadTransaksi();
  }

  double get totalPemasukan {
    return transaksiList
        .where((e) => e.tipe == 'pemasukan')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get totalPengeluaran {
    return transaksiList
        .where((e) => e.tipe == 'pengeluaran')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get saldoSaatIni => totalPemasukan - totalPengeluaran;
  List<TransaksiModel> get transaksiBulanIni {
    final now = DateTime.now();

    final result = transaksiList.where((item) {
      return item.tanggal.year == now.year && item.tanggal.month == now.month;
    }).toList();

    result.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return result;
  }

  double get totalPemasukanBulanIni {
    return transaksiBulanIni
        .where((e) => e.tipe == 'pemasukan')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get totalPengeluaranBulanIni {
    return transaksiBulanIni
        .where((e) => e.tipe == 'pengeluaran')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get saldoBulanIni => totalPemasukanBulanIni - totalPengeluaranBulanIni;

  final selectedDate = DateTime.now().obs;

  void ubahTanggalFilter(DateTime date) {
    selectedDate.value = date;
  }

  List<TransaksiModel> get transaksiTanggalDipilih {
    final date = selectedDate.value;

    final result = transaksiList.where((item) {
      return item.tanggal.year == date.year &&
          item.tanggal.month == date.month &&
          item.tanggal.day == date.day;
    }).toList();

    result.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return result;
  }

  double get totalPemasukanTanggalDipilih {
    return transaksiTanggalDipilih
        .where((e) => e.tipe == 'pemasukan')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get totalPengeluaranTanggalDipilih {
    return transaksiTanggalDipilih
        .where((e) => e.tipe == 'pengeluaran')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get saldoTanggalDipilih =>
      totalPemasukanTanggalDipilih - totalPengeluaranTanggalDipilih;
  final selectedStartDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;

  final selectedEndDate = DateTime.now().obs;

  void ubahDateRange(DateTime start, DateTime end) {
    selectedStartDate.value = start;
    selectedEndDate.value = end;
  }

  List<TransaksiModel> get transaksiFilterTanggal {
    final start = DateTime(
      selectedStartDate.value.year,
      selectedStartDate.value.month,
      selectedStartDate.value.day,
    );

    final end = DateTime(
      selectedEndDate.value.year,
      selectedEndDate.value.month,
      selectedEndDate.value.day,
      23,
      59,
      59,
    );

    final result = transaksiList.where((item) {
      return item.tanggal.isAfter(start.subtract(const Duration(seconds: 1))) &&
          item.tanggal.isBefore(end.add(const Duration(seconds: 1)));
    }).toList();

    result.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return result;
  }

  double get totalPemasukanFilterTanggal {
    return transaksiFilterTanggal
        .where((e) => e.tipe == 'pemasukan')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get totalPengeluaranFilterTanggal {
    return transaksiFilterTanggal
        .where((e) => e.tipe == 'pengeluaran')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get saldoFilterTanggal =>
      totalPemasukanFilterTanggal - totalPengeluaranFilterTanggal;
}
