import 'package:get/get.dart';

import '../controllers/transaksi_controller.dart';
import '../controllers/transaksi_form_controller.dart';

// class TransaksiBinding extends Bindings {
//   @override
//   void dependencies() {
//     if (!Get.isRegistered<TransaksiController>()) {
//       Get.lazyPut<TransaksiController>(() => TransaksiController());
//     }

//     if (!Get.isRegistered<TransaksiFormController>()) {
//       Get.lazyPut<TransaksiFormController>(() => TransaksiFormController());
//     }
//   }
// }
class TransaksiBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TransaksiController>()) {
      Get.lazyPut<TransaksiController>(() => TransaksiController());
    }

    Get.lazyPut<TransaksiFormController>(
      () => TransaksiFormController(),
      fenix: false,
    );
  }
}
