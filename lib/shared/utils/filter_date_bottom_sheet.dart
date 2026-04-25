import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/app_colors.dart';
import '../utils/date_helper.dart';

class FilterDateBottomSheet {
  static void show({
    required String title,
    required DateTime? startDate,
    required DateTime? endDate,
    required VoidCallback onReset,
    required VoidCallback onApply,
    required VoidCallback onPickStartDate,
    required VoidCallback onPickEndDate,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    TextButton(onPressed: onReset, child: const Text('Reset')),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Periode',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tanggal Mulai',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                FilterDateInput(
                  text: 'Pilih tanggal mulai',
                  date: startDate,
                  onTap: onPickStartDate,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tanggal Akhir',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                FilterDateInput(
                  text: 'Pilih tanggal akhir',
                  date: endDate,
                  onTap: onPickEndDate,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onApply,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Terapkan Filter',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class FilterDateInput extends StatelessWidget {
  final String text;
  final DateTime? date;
  final VoidCallback onTap;

  const FilterDateInput({
    super.key,
    required this.text,
    this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date != null ? DateHelper.formatTanggal(date!) : text,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
