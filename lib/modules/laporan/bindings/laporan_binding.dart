import 'package:get/get.dart';

import '../../transaksi/bindings/transaksi_binding.dart';
import '../controllers/laporan_controller.dart';

class LaporanBinding extends Bindings {
  @override
  void dependencies() {
    TransaksiBinding().dependencies();

    if (!Get.isRegistered<LaporanController>()) {
      Get.lazyPut<LaporanController>(() => LaporanController());
    }
  }
}
