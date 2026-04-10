import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/themes/app_colors.dart';
import '../../../shared/utils/date_helper.dart';
import '../controllers/transaksi_controller.dart';
import '../controllers/transaksi_form_controller.dart';

class TransaksiFormView extends GetView<TransaksiFormController> {
  const TransaksiFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final transaksiController = Get.find<TransaksiController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Jenis Transaksi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _TipeCard(
                      title: 'Pemasukan',
                      icon: Icons.arrow_downward,
                      isSelected: controller.selectedTipe.value == 'pemasukan',
                      onTap: () => controller.setTipe('pemasukan'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TipeCard(
                      title: 'Pengeluaran',
                      icon: Icons.arrow_upward,
                      isSelected:
                          controller.selectedTipe.value == 'pengeluaran',
                      onTap: () => controller.setTipe('pengeluaran'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tanggal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedTanggal.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    controller.setTanggal(picked);
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.tertiary.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined),
                      const SizedBox(width: 12),
                      Text(
                        DateHelper.formatTanggal(
                          controller.selectedTanggal.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.keteranganController,
              validator: controller.validateKeterangan,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Keterangan',
                hintText: 'Contoh: Gaji bulanan',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.nominalController,
              validator: controller.validateNominal,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nominal',
                hintText: 'Contoh: 50000',
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => TextFormField(
                controller: controller.kategoriController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: controller.selectedTipe.value == 'pengeluaran'
                      ? 'Kategori'
                      : 'Kategori (opsional)',
                  hintText: controller.selectedTipe.value == 'pengeluaran'
                      ? 'Contoh: Makan, Transport'
                      : 'Contoh: Gaji, Bonus',
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final isValid =
                    controller.formKey.currentState?.validate() ?? false;

                if (!isValid) return;

                await transaksiController.tambahTransaksi(
                  tanggal: controller.selectedTanggal.value,
                  keterangan: controller.keteranganController.text.trim(),
                  nominal: controller.parseNominal(),
                  tipe: controller.selectedTipe.value,
                  kategori: controller.kategoriValue,
                );

                Get.back();

                Get.snackbar(
                  'Berhasil',
                  'Transaksi berhasil ditambahkan',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.primary,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TipeCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected ? AppColors.primary : Colors.white;
    final foregroundColor = isSelected ? Colors.white : AppColors.black;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.tertiary,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: foregroundColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
