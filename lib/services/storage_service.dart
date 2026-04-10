import 'package:get_storage/get_storage.dart';

class StorageService {
  StorageService._();

  static final GetStorage _box = GetStorage();

  static const String transaksiKey = 'transaksi_key';

  static List<dynamic> readList(String key) {
    return _box.read<List<dynamic>>(key) ?? <dynamic>[];
  }

  static Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  static T? read<T>(String key) {
    return _box.read<T>(key);
  }

  static Future<void> remove(String key) async {
    await _box.remove(key);
  }

  static bool hasData(String key) {
    return _box.hasData(key);
  }
}
