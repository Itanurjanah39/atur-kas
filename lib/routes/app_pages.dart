import 'package:atur_kas/modules/laporan/bindings/laporan_binding.dart';
import 'package:atur_kas/modules/laporan/views/laporan_view.dart';
import 'package:atur_kas/modules/main_nav/bindings/main_nav_binding.dart';
import 'package:atur_kas/modules/main_nav/views/main_nav_view.dart';
import 'package:atur_kas/modules/transaksi/bindings/transaksi_binding.dart';
import 'package:atur_kas/modules/transaksi/views/transaksi_form_view.dart';
import 'package:get/get.dart';

import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.mainNav;

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.mainNav,
      page: () => const MainNavView(),
      binding: MainNavBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.transaksiForm,
      page: () => const TransaksiFormView(),
      binding: TransaksiBinding(),
    ),
    GetPage(
      name: AppRoutes.laporan,
      page: () => const LaporanView(),
      binding: LaporanBinding(),
    ),
  ];
}
