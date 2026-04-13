import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/transaksi_model.dart';
import '../../transaksi/controllers/transaksi_controller.dart';

class LaporanController extends GetxController {
  final transaksiController = Get.find<TransaksiController>();

  final List<String> kategoriOptions = const [
    'Semua Kategori',
    'Upah Karyawan',
    'Operasional',
    'Kulakan',
    'Lainnya',
  ];

  final selectedKategori = 'Semua Kategori'.obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    setDefaultCurrentMonth();

    ever<List<TransaksiModel>>(transaksiController.transaksiList, (_) {
      applyFilter();
    });

    applyFilter();
  }

  void setDefaultCurrentMonth() {
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, 1);
    endDate.value = DateTime(now.year, now.month + 1, 0);
  }

  Future<void> loadData() async {
    await transaksiController.loadTransaksi();
    applyFilter();
  }

  Future<void> pickDateRange(BuildContext context) async {
    final now = DateTime.now();

    final initialRange = DateTimeRange(
      start: startDate.value ?? DateTime(now.year, now.month, 1),
      end: endDate.value ?? DateTime(now.year, now.month + 1, 0),
    );

    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
      helpText: 'Pilih Periode Laporan',
      confirmText: 'Terapkan',
      cancelText: 'Batal',
      saveText: 'Terapkan',
      fieldStartHintText: 'Start date',
      fieldEndHintText: 'End date',
    );

    if (picked != null) {
      startDate.value = DateTime(
        picked.start.year,
        picked.start.month,
        picked.start.day,
      );
      endDate.value = DateTime(
        picked.end.year,
        picked.end.month,
        picked.end.day,
      );
      applyFilter();
    }
  }

  void setKategori(String value) {
    selectedKategori.value = value;
    applyFilter();
  }

  void resetFilter() {
    selectedKategori.value = 'Semua Kategori';
    setDefaultCurrentMonth();
    applyFilter();
  }

  List<TransaksiModel> get filteredTransaksi {
    final start = startDate.value;
    final end = endDate.value;

    final result = transaksiController.transaksiList.where((item) {
      final itemDate = DateTime(
        item.tanggal.year,
        item.tanggal.month,
        item.tanggal.day,
      );

      final matchTanggal = start != null && end != null
          ? !itemDate.isBefore(start) && !itemDate.isAfter(end)
          : true;

      final matchKategori = selectedKategori.value == 'Semua Kategori'
          ? true
          : (item.kategori?.trim().toLowerCase() ==
                selectedKategori.value.trim().toLowerCase());

      return matchTanggal && matchKategori;
    }).toList();

    result.sort((a, b) => b.tanggal.compareTo(a.tanggal));
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

  void applyFilter() {
    update();
  }

  String get periodeText {
    if (startDate.value == null || endDate.value == null) {
      return 'Pilih periode';
    }

    return '${formatDate(startDate.value!)} - ${formatDate(endDate.value!)}';
  }

  String get headerTitle {
    if (startDate.value == null || endDate.value == null) {
      return 'Laporan';
    }

    final start = startDate.value!;
    final end = endDate.value!;
    final now = DateTime.now();

    final isCurrentMonth =
        start.year == now.year &&
        start.month == now.month &&
        start.day == 1 &&
        end.year == now.year &&
        end.month == now.month &&
        end.day == DateTime(now.year, now.month + 1, 0).day;

    if (isCurrentMonth) {
      return 'Laporan ${monthName(now.month)} ${now.year}';
    }

    return 'Laporan Periode';
  }

  String formatDate(DateTime date) {
    const bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day.toString().padLeft(2, '0')} ${bulan[date.month]} ${date.year}';
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

  Future<void> hapusTransaksi(TransaksiModel item) async {
    await transaksiController.hapusTransaksi(item.id);
    applyFilter();

    Get.snackbar(
      'Berhasil',
      'Transaksi berhasil dihapus',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> konfirmasiHapus(TransaksiModel item) async {
    Get.defaultDialog(
      title: 'Hapus Transaksi',
      middleText: 'Yakin ingin menghapus "${item.keterangan}"?',
      textCancel: 'Batal',
      textConfirm: 'Hapus',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        await hapusTransaksi(item);
      },
    );
  }

  void editTransaksi(TransaksiModel item) {
    Get.snackbar(
      'Edit Transaksi',
      'Hubungkan ke halaman edit untuk "${item.keterangan}"',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );

    // Contoh:
    // Get.toNamed(Routes.EDIT_TRANSAKSI, arguments: item);
  }
}
