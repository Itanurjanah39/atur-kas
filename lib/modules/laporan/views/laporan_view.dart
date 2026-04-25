import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/themes/app_colors.dart';
import '../../../shared/utils/currency_helper.dart';
import '../../../shared/utils/date_helper.dart';
import '../controllers/laporan_controller.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LaporanController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: false,
            foregroundColor: AppColors.black,
            title: const Text(
              '   Laporan',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(
                onPressed: () => _showFilterBottomSheet(context),
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: controller.loadData,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _BalanceCard(
                  saldo: controller.saldoSaatIni,
                  periodeText: controller.periodeText,
                  kategori: controller.selectedKategori.value,
                ),
                const SizedBox(height: 18),
                _ReportHeader(
                  title: controller.headerTitle,
                  totalMonth: controller.laporanBulanan.length,
                ),
                const SizedBox(height: 14),
                if (controller.laporanBulanan.isEmpty)
                  const _EmptyReport()
                else
                  ...controller.laporanBulanan.map(
                    (item) => _MonthlyReportCard(item: item),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      GetBuilder<LaporanController>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Filter Laporan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: controller.resetFilter,
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Periode',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tanggal Mulai',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _DateInput(
                      text: 'Pilih tanggal mulai',
                      date: controller.startDate.value,
                      onTap: () => controller.pickStartDate(context),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tanggal Akhir',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _DateInput(
                      text: 'Pilih tanggal akhir',
                      date: controller.endDate.value,
                      onTap: () => controller.pickEndDate(context),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.kategoriOptions.map((kategori) {
                        final isSelected =
                            controller.selectedKategori.value == kategori;

                        return InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => controller.setKategori(kategori),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.tertiary.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              kategori,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: Get.back,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Terapkan Filter',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}

class _ReportHeader extends StatelessWidget {
  final String title;
  final int totalMonth;

  const _ReportHeader({required this.title, required this.totalMonth});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$totalMonth bulan',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _DateInput extends StatelessWidget {
  final String text;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateInput({required this.text, this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date != null ? DateHelper.formatTanggal(date!) : text,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double saldo;
  final String periodeText;
  final String kategori;

  const _BalanceCard({
    required this.saldo,
    required this.periodeText,
    required this.kategori,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.14),
            blurRadius: 14,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -10,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -16,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saldo Periode Ini',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                CurrencyHelper.toRupiah(saldo),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BalanceMetaRow(
                      icon: Icons.calendar_month_rounded,
                      text: periodeText,
                      isPrimary: true,
                    ),
                    const SizedBox(height: 8),
                    _BalanceMetaRow(
                      icon: Icons.category_rounded,
                      text: kategori,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceMetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isPrimary;

  const _BalanceMetaRow({
    required this.icon,
    required this.text,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isPrimary ? Colors.white : Colors.white70,
              fontSize: isPrimary ? 13 : 12,
              fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthlyReportCard extends StatelessWidget {
  final LaporanBulanan item;

  const _MonthlyReportCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          /// HEADER (BULAN + SALDO)
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),

              /// BULAN
              Expanded(
                child: Text(
                  '${_monthName(item.month)} ${item.year}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),

              /// SALDO (KANAN ATAS)
              Text(
                CurrencyHelper.toRupiah(item.sisaSaldo),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// PEMASUKAN & PENGELUARAN (1 BARIS)
          Row(
            children: [
              Expanded(
                child: _ReportRow(
                  label: 'Pemasukan',
                  value: item.totalPemasukan,
                  isIncome: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ReportRow(
                  label: 'Pengeluaran',
                  value: item.totalPengeluaran,
                  isIncome: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
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
}

class _ReportRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isIncome;

  const _ReportRow({
    required this.label,
    required this.value,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              CurrencyHelper.toRupiah(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyReport extends StatelessWidget {
  const _EmptyReport();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.receipt_long_rounded, size: 40, color: AppColors.grey),
          SizedBox(height: 12),
          Text(
            'Tidak ada laporan pada periode ini',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Coba ubah filter periode atau kategori.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
