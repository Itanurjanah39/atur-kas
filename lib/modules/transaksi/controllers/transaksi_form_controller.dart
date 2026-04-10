import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransaksiFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final keteranganController = TextEditingController();
  final nominalController = TextEditingController();
  final kategoriController = TextEditingController();

  final selectedTipe = 'pemasukan'.obs;
  final selectedTanggal = DateTime.now().obs;

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
      value.replaceAll('.', '').replaceAll(',', ''),
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
