import '../../services/storage_service.dart';
import '../models/transaksi_model.dart';

class TransaksiRepository {
  List<TransaksiModel> getAll() {
    final rawList = StorageService.readList(StorageService.transaksiKey);

    return rawList
        .map((item) => TransaksiModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> saveAll(List<TransaksiModel> data) async {
    final jsonList = data.map((e) => e.toJson()).toList();
    await StorageService.write(StorageService.transaksiKey, jsonList);
  }

  Future<void> add(TransaksiModel transaksi) async {
    final current = getAll();
    current.add(transaksi);
    await saveAll(current);
  }

  Future<void> update(TransaksiModel transaksi) async {
    final current = getAll();
    final index = current.indexWhere((e) => e.id == transaksi.id);

    if (index != -1) {
      current[index] = transaksi;
      await saveAll(current);
    }
  }

  Future<void> delete(String id) async {
    final current = getAll();
    current.removeWhere((e) => e.id == id);
    await saveAll(current);
  }
}
