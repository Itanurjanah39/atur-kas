import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/themes/app_colors.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../laporan/views/laporan_view.dart';
import '../controllers/main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DashboardView(),
      const LaporanView(),
      const _PengaturanPlaceholderView(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AppRoutes.transaksiForm);
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedIndex.value,
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
          ],
        ),
      ),
    );
  }
}

class _PengaturanPlaceholderView extends StatelessWidget {
  const _PengaturanPlaceholderView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: const Center(child: Text('Halaman pengaturan belum dibuat')),
    );
  }
}
