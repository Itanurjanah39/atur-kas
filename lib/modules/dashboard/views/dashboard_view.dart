import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/themes/app_colors.dart';
import '../../../shared/utils/currency_helper.dart';
import '../../transaksi/controllers/transaksi_controller.dart';

class DashboardView extends GetView<TransaksiController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atur Kas')),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.loadTransaksi,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
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
                      'Saldo Saat Ini',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyHelper.toRupiah(controller.saldoSaatIni),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Pemasukan',
                      amount: CurrencyHelper.toRupiah(
                        controller.totalPemasukan,
                      ),
                      color: AppColors.tertiary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Pengeluaran',
                      amount: CurrencyHelper.toRupiah(
                        controller.totalPengeluaran,
                      ),
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 12),
              if (controller.transaksiList.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Belum ada transaksi',
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...controller.transaksiList.map(
                  (item) => Container(
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.kategori ?? '-',
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 12,
                                ),
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
                  ),
                ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showTambahDummyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showTambahDummyDialog() async {
    await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Wrap(
            runSpacing: 12,
            children: [
              const Text(
                'Tambah Data Cepat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.tambahTransaksi(
                    tanggal: DateTime.now(),
                    keterangan: 'Pemasukan Baru',
                    nominal: 50000,
                    tipe: 'pemasukan',
                    kategori: 'Umum',
                  );
                  Get.back();
                },
                child: const Text('Tambah Pemasukan Dummy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.tambahTransaksi(
                    tanggal: DateTime.now(),
                    keterangan: 'Pengeluaran Baru',
                    nominal: 25000,
                    tipe: 'pengeluaran',
                    kategori: 'Belanja',
                  );
                  Get.back();
                },
                child: const Text('Tambah Pengeluaran Dummy'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
