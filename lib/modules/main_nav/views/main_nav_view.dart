import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/themes/app_colors.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../laporan/views/laporan_view.dart';
import '../../info_app/views/info_app_view.dart';
import '../controllers/main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DashboardView(),
      const LaporanView(),
      const InfoAppView(),
    ];

    return Obx(() {
      final currentIndex = controller.selectedIndex.value;
      final showFab = currentIndex == 0;

      return Scaffold(
        body: IndexedStack(index: currentIndex, children: pages),
        floatingActionButton: showFab
            ? FloatingActionButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.transaksiForm);
                },
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: controller.changeIndex,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.tertiary,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.assessment_outlined),
              selectedIcon: Icon(Icons.assessment),
              label: 'Laporan',
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline),
              selectedIcon: Icon(Icons.info),
              label: 'Info App',
            ),
          ],
        ),
      );
    });
  }
}
