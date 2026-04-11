import 'package:get/get.dart';

import '../../dashboard/bindings/dashboard_binding.dart';
import '../../laporan/bindings/laporan_binding.dart';
import '../../transaksi/bindings/transaksi_binding.dart';
import '../controllers/main_nav_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    DashboardBinding().dependencies();
    LaporanBinding().dependencies();
    TransaksiBinding().dependencies();

    if (!Get.isRegistered<MainNavController>()) {
      Get.lazyPut<MainNavController>(() => MainNavController());
    }
  }
}
