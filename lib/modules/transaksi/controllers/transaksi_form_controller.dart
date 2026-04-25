import 'package:atur_kas/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/transaksi_model.dart';
import '../../transaksi/controllers/transaksi_controller.dart';
import '../../main_nav/controllers/main_nav_controller.dart';

class TransaksiFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final keteranganController = TextEditingController();
  final nominalController = TextEditingController();

  final selectedTipe = 'pemasukan'.obs;
  final selectedTanggal = DateTime.now().obs;
  final selectedKategori = RxnString();

  final isEditMode = false.obs;
  final isSubmitting = false.obs;

  final transaksiController = Get.find<TransaksiController>();

  final List<Map<String, String>> tipeOptions = const [
    {'value': 'pemasukan', 'label': 'Pemasukan'},
    {'value': 'pengeluaran', 'label': 'Pengeluaran'},
  ];

  final List<String> kategoriOptions = const [
    'Upah Karyawan',
    'Operasional',
    'Kulakan',
    'Saldo Tabungan',
    'Belanja Bulanan',
    'Sembako',
    'Lainnya',
  ];

  TransaksiModel? editingTransaksi;

  @override
  void onInit() {
    super.onInit();
    loadArgumentsIfExists();
  }

  void resetForm() {
    editingTransaksi = null;
    isEditMode.value = false;
    selectedTipe.value = 'pemasukan';
    selectedTanggal.value = DateTime.now();
    selectedKategori.value = null;
    keteranganController.clear();
    nominalController.clear();
  }

  void loadArgumentsIfExists() {
    resetForm();

    final args = Get.arguments;

    if (args is TransaksiModel) {
      editingTransaksi = args;
      isEditMode.value = true;

      selectedTipe.value = args.tipe;
      selectedTanggal.value = args.tanggal;
      selectedKategori.value = args.kategori;
      keteranganController.text = args.keterangan;
      nominalController.text = args.nominal.toStringAsFixed(0);
    }
  }

  @override
  void onClose() {
    keteranganController.dispose();
    nominalController.dispose();
    super.onClose();
  }

  Future<void> pickTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggal.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null) {
      selectedTanggal.value = picked;
    }
  }

  void setTipe(String value) {
    selectedTipe.value = value;
  }

  void setKategori(String? value) {
    selectedKategori.value = value;
  }

  String? validateKeterangan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Keterangan wajib diisi';
    }
    return null;
  }

  String? validateNominal(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nominal wajib diisi';
    }

    final parsed = double.tryParse(
      value.replaceAll('.', '').replaceAll(',', '').trim(),
    );

    if (parsed == null || parsed <= 0) {
      return 'Nominal tidak valid';
    }

    return null;
  }

  double parseNominal() {
    final raw = nominalController.text
        .replaceAll('.', '')
        .replaceAll(',', '')
        .trim();

    return double.parse(raw);
  }

  String? get kategoriValue {
    final value = selectedKategori.value?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String get pageTitle =>
      isEditMode.value ? 'Edit Transaksi' : 'Tambah Transaksi';

  String get submitLabel =>
      isEditMode.value ? 'Simpan Perubahan' : 'Simpan Transaksi';

  String get dialogTitle =>
      isEditMode.value ? 'Simpan Perubahan?' : 'Simpan Transaksi?';

  String get dialogMessage => isEditMode.value
      ? 'Pastikan data transaksi yang diubah sudah benar.'
      : 'Pastikan data transaksi yang dimasukkan sudah benar.';

  Future<void> confirmSubmit() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          dialogTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Text(dialogMessage, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirmed == true) {
      await submitForm();
    }
  }

  Future<void> submitForm() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    try {
      if (isEditMode.value && editingTransaksi != null) {
        final updated = editingTransaksi!.copyWith(
          tanggal: selectedTanggal.value,
          keterangan: keteranganController.text.trim(),
          nominal: parseNominal(),
          tipe: selectedTipe.value,
          kategori: kategoriValue,
          updatedAt: DateTime.now(),
        );

        await transaksiController.editTransaksi(updated);

        Get.back();

        Get.snackbar(
          'Berhasil',
          'Transaksi berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        await _goToDashboardAfterSubmit();
      } else {
        await transaksiController.tambahTransaksi(
          tanggal: selectedTanggal.value,
          keterangan: keteranganController.text.trim(),
          nominal: parseNominal(),
          tipe: selectedTipe.value,
          kategori: kategoriValue,
        );

        resetForm();
        formKey.currentState?.reset();
        update();

        Get.snackbar(
          'Berhasil',
          'Transaksi berhasil ditambahkan',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _goToDashboardAfterSubmit() async {
    await transaksiController.loadTransaksi();

    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeIndex(0);
    }

    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    }
  }
}
