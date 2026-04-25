import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/transaksi_model.dart';
import '../../../shared/themes/app_colors.dart';
import '../../../shared/utils/currency_helper.dart';
import '../../../shared/utils/date_helper.dart';
import '../../../shared/utils/filter_date_bottom_sheet.dart';
import '../../transaksi/controllers/transaksi_controller.dart';

class DashboardView extends GetView<TransaksiController> {
  const DashboardView({super.key});

  void _showFilterBottomSheet(BuildContext context) {
    FilterDateBottomSheet.show(
      title: 'Filter Dashboard',
      startDate: controller.selectedStartDate.value,
      endDate: controller.selectedEndDate.value,
      onReset: controller.resetDashboardFilter,
      onPickStartDate: () => controller.pickDashboardStartDate(context),
      onPickEndDate: () => controller.pickDashboardEndDate(context),
      onApply: Get.back,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: controller.loadTransaksi,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 130),
              children: [
                _DashboardHeader(
                  onFilterTap: () => _showFilterBottomSheet(context),
                ),
                const SizedBox(height: 16),
                _BalanceCard(saldo: controller.saldoSaatIni),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _ModernSummaryCard(
                        title: 'Pemasukan',
                        value: controller.totalPemasukanFilterTanggal,
                        icon: Icons.south_west_rounded,
                        isIncome: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ModernSummaryCard(
                        title: 'Pengeluaran',
                        value: controller.totalPengeluaranFilterTanggal,
                        icon: Icons.north_east_rounded,
                        isIncome: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _HistoryHeader(
                  startDate: controller.selectedStartDate.value,
                  endDate: controller.selectedEndDate.value,
                  total: controller.transaksiFilterTanggal.length,
                ),
                const SizedBox(height: 14),
                if (controller.transaksiFilterTanggal.isEmpty)
                  const _EmptyTransaction()
                else
                  ...controller.transaksiFilterTanggal.map(
                    (item) => _TransactionCard(item: item),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final VoidCallback onFilterTap;

  const _DashboardHeader({required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onFilterTap,
          child: const Icon(
            Icons.tune_rounded,
            color: AppColors.black,
            size: 26,
          ),
        ),
      ],
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final int total;

  const _HistoryHeader({
    required this.startDate,
    required this.endDate,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isSameDate =
        startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day;

    final periodeText = isSameDate
        ? DateHelper.formatTanggal(startDate)
        : '${DateHelper.formatTanggal(startDate)} - ${DateHelper.formatTanggal(endDate)}';

    return Row(
      children: [
        Expanded(
          child: Text(
            'Riwayat $periodeText',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$total transaksi',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyTransaction extends StatelessWidget {
  const _EmptyTransaction();

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
      child: const Text(
        'Belum ada transaksi pada periode ini',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.grey, fontSize: 14),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double saldo;

  const _BalanceCard({required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -24,
            right: -16,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -34,
            left: -22,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Saldo Aktif',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Saldo Saat Ini',
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
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'ATUR KAS',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Text(
                    '•••• 1024',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernSummaryCard extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;
  final bool isIncome;

  const _ModernSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isIncome
        ? AppColors.tertiary.withValues(alpha: 0.6)
        : AppColors.accent.withValues(alpha: 0.6);

    final iconColor = isIncome ? AppColors.success : AppColors.danger;
    final valueColor = isIncome ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [bgColor, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyHelper.toRupiah(value),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                isIncome
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: 14,
                color: iconColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Periode filter',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.black.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransaksiModel item;

  const _TransactionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isIncome = item.tipe == 'pemasukan';

    final iconBg = isIncome
        ? AppColors.accent.withValues(alpha: 0.9)
        : AppColors.danger.withValues(alpha: 0.22);

    final amountColor = isIncome ? AppColors.success : AppColors.danger;

    final metaText = (item.kategori != null && item.kategori!.trim().isNotEmpty)
        ? '${item.kategori!} • ${DateHelper.formatTanggal(item.tanggal)}'
        : DateHelper.formatTanggal(item.tanggal);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: isIncome ? AppColors.success : AppColors.danger,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.keterangan,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${isIncome ? '+' : '-'} ${CurrencyHelper.toRupiah(item.nominal)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: amountColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  metaText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
