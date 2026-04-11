import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/themes/app_colors.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../info_app/views/info_app_view.dart';
import '../../kebijakan/views/kebijakan_view.dart';
import '../../laporan/views/laporan_view.dart';
import '../../transaksi/views/transaksi_form_view.dart';
import '../controllers/main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DashboardView(),
      const LaporanView(),
      const TransaksiFormView(),
      const KebijakanView(),
      const InfoAppView(),
    ];

    return Obx(() {
      final currentIndex = controller.selectedIndex.value;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(index: currentIndex, children: pages),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, -4),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 18),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: _NavItem(
                    label: 'Dashboard',
                    icon: Icons.home_rounded,
                    isActive: currentIndex == 0,
                    onTap: () => controller.changeIndex(0),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    label: 'Laporan',
                    icon: Icons.bar_chart_rounded,
                    isActive: currentIndex == 1,
                    onTap: () => controller.changeIndex(1),
                  ),
                ),
                Expanded(
                  child: _CenterAddButton(
                    isActive: currentIndex == 2,
                    onTap: () => controller.changeIndex(2),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    label: 'Kebijakan',
                    icon: Icons.verified_user_outlined,
                    isActive: currentIndex == 3,
                    onTap: () => controller.changeIndex(3),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    label: 'Info App',
                    icon: Icons.info_outline_rounded,
                    isActive: currentIndex == 4,
                    onTap: () => controller.changeIndex(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.grey;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.tertiary : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterAddButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _CenterAddButton({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            'Tambah',
            style: TextStyle(
              fontSize: 11,
              color: isActive ? AppColors.primary : AppColors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
