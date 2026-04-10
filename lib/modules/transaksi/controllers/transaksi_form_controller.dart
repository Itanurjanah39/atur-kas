import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/transaksi_model.dart';

class TransaksiFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final keteranganController = TextEditingController();
  final nominalController = TextEditingController();
  final kategoriController = TextEditingController();

  final selectedTipe = 'pemasukan'.obs;
  final selectedTanggal = DateTime.now().obs;
  final isEditMode = false.obs;

  TransaksiModel? editingTransaksi;

  @override
  void onInit() {
    super.onInit();
    _loadArgumentsIfExists();
  }

  @override
  void onReady() {
    super.onReady();
    _loadArgumentsIfExists();
  }

  void resetForm() {
    editingTransaksi = null;
    isEditMode.value = false;
    selectedTipe.value = 'pemasukan';
    selectedTanggal.value = DateTime.now();
    keteranganController.clear();
    nominalController.clear();
    kategoriController.clear();
  }

  void _loadArgumentsIfExists() {
    resetForm();

    final args = Get.arguments;

    if (args != null && args is TransaksiModel) {
      editingTransaksi = args;
      isEditMode.value = true;

      selectedTipe.value = args.tipe;
      selectedTanggal.value = args.tanggal;
      keteranganController.text = args.keterangan;
      nominalController.text = args.nominal.toStringAsFixed(0);
      kategoriController.text = args.kategori ?? '';
    }
  }

  @override
  void onClose() {
    keteranganController.dispose();
    nominalController.dispose();
    kategoriController.dispose();
    super.onClose();
  }

  void setTipe(String value) {
    selectedTipe.value = value;
  }

  void setTanggal(DateTime value) {
    selectedTanggal.value = value;
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
    final value = kategoriController.text.trim();
    if (value.isEmpty) return null;
    return value;
  }
}
