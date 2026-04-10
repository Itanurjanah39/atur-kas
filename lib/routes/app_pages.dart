import 'package:get/get.dart';

import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.dashboard;

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}
