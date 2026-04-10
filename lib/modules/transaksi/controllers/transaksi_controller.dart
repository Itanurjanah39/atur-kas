import 'package:get/get.dart';

import '../../../data/models/transaksi_model.dart';
import '../../../data/repositories/transaksi_repository.dart';

class TransaksiController extends GetxController {
  final TransaksiRepository _repository = TransaksiRepository();

  final transaksiList = <TransaksiModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransaksi();
  }

  Future<void> loadTransaksi() async {
    isLoading.value = true;

    final data = _repository.getAll();
    data.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    transaksiList.assignAll(data);

    isLoading.value = false;
  }

  Future<void> tambahTransaksi({
    required DateTime tanggal,
    required String keterangan,
    required double nominal,
    required String tipe,
    String? kategori,
  }) async {
    final now = DateTime.now();

    final transaksi = TransaksiModel(
      id: now.microsecondsSinceEpoch.toString(),
      tanggal: tanggal,
      keterangan: keterangan,
      nominal: nominal,
      tipe: tipe,
      kategori: kategori,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.add(transaksi);
    await loadTransaksi();
  }

  Future<void> editTransaksi(TransaksiModel transaksi) async {
    final updated = transaksi.copyWith(updatedAt: DateTime.now());

    await _repository.update(updated);
    await loadTransaksi();
  }

  Future<void> hapusTransaksi(String id) async {
    await _repository.delete(id);
    await loadTransaksi();
  }

  double get totalPemasukan {
    return transaksiList
        .where((e) => e.tipe == 'pemasukan')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get totalPengeluaran {
    return transaksiList
        .where((e) => e.tipe == 'pengeluaran')
        .fold(0.0, (sum, item) => sum + item.nominal);
  }

  double get saldoSaatIni => totalPemasukan - totalPengeluaran;
}
