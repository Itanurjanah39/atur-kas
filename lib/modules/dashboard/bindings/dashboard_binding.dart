import 'package:get/get.dart';

import '../../transaksi/bindings/transaksi_binding.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    TransaksiBinding().dependencies();
  }
}
