import 'package:atur_kas/routes/app_routes.dart';
import 'package:atur_kas/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/transaksi_model.dart';
import '../../transaksi/controllers/transaksi_controller.dart';
import '../../transaksi/controllers/transaksi_form_controller.dart';

class LaporanController extends GetxController {
  final transaksiController = Get.find<TransaksiController>();

  final List<String> kategoriOptions = const [
    'Semua Kategori',
    'Upah Karyawan',
    'Operasional',
    'Kulakan',
    'Saldo Tabungan',
    'Belanja Bulanan',
    'Sembako',
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

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      helpText: 'Pilih Tanggal Mulai',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null) {
      startDate.value = DateTime(picked.year, picked.month, picked.day);

      if (endDate.value != null && endDate.value!.isBefore(startDate.value!)) {
        endDate.value = startDate.value;
      }

      applyFilter();
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? DateTime.now(),
      firstDate: startDate.value ?? DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      helpText: 'Pilih Tanggal Akhir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null) {
      endDate.value = DateTime(picked.year, picked.month, picked.day);
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
          : item.kategori?.trim().toLowerCase() ==
                selectedKategori.value.trim().toLowerCase();

      return matchTanggal && matchKategori;
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

  void applyFilter() {
    update();
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
    Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Transaksi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Yakin ingin menghapus "${item.keterangan}"?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await hapusTransaksi(item);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void editTransaksi(TransaksiModel item) {
    Get.delete<TransaksiFormController>();
    Get.toNamed(AppRoutes.transaksiForm, arguments: item);
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
