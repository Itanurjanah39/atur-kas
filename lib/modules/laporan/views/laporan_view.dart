import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/transaksi_model.dart';
import '../../../shared/themes/app_colors.dart';
import '../../../shared/utils/currency_helper.dart';
import '../../../shared/utils/date_helper.dart';
import '../controllers/laporan_controller.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildJenisFilter(),
            const SizedBox(height: 12),
            _buildPeriodeFilter(),
            const SizedBox(height: 12),
            _buildKategoriFilter(),
            const SizedBox(height: 24),
            const Text(
              'Hasil Laporan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            if (controller.filteredTransaksi.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Tidak ada data sesuai filter',
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...controller.filteredTransaksi.map(_buildTransaksiItem),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'Saldo: ${CurrencyHelper.toRupiah(controller.saldo)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _summaryBox(
                  'Pemasukan',
                  CurrencyHelper.toRupiah(controller.totalPemasukan),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryBox(
                  'Pengeluaran',
                  CurrencyHelper.toRupiah(controller.totalPengeluaran),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJenisFilter() {
    final items = [
      ('semua', 'Semua'),
      ('pemasukan', 'Pemasukan'),
      ('pengeluaran', 'Pengeluaran'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = controller.selectedJenis.value == item.$1;
        return ChoiceChip(
          label: Text(item.$2),
          selected: isSelected,
          onSelected: (_) => controller.setJenis(item.$1),
        );
      }).toList(),
    );
  }

  Widget _buildPeriodeFilter() {
    final items = [
      ('semua', 'Semua'),
      ('harian', 'Harian'),
      ('bulanan', 'Bulanan'),
      ('tahunan', 'Tahunan'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = controller.selectedPeriode.value == item.$1;
        return ChoiceChip(
          label: Text(item.$2),
          selected: isSelected,
          onSelected: (_) => controller.setPeriode(item.$1),
        );
      }).toList(),
    );
  }

  Widget _buildKategoriFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedKategori.value,
          isExpanded: true,
          items: controller.kategoriList.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item == 'semua' ? 'Semua Kategori' : item),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.setKategori(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTransaksiItem(TransaksiModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: item.tipe == 'pemasukan'
                ? AppColors.tertiary
                : AppColors.accent,
            child: Icon(
              item.tipe == 'pemasukan'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: AppColors.black,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.keterangan,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.kategori ?? '-'} • ${DateHelper.formatTanggal(item.tanggal)}',
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            CurrencyHelper.toRupiah(item.nominal),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: item.tipe == 'pemasukan'
                  ? AppColors.success
                  : AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}
