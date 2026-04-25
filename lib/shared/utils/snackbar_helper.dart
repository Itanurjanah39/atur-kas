import 'package:another_flushbar/flushbar.dart';
import 'package:atur_kas/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Enum untuk menentukan tipe snackbar
enum SnackbarType { success, error, warning, info }

class SnackbarHelper {
  static void show(
    BuildContext context,
    String message, {
    SnackbarType type = SnackbarType.info,
    String? title,
  }) {
    final overlayCtx = Get.overlayContext ?? context;
    Color barColor;
    IconData icon;
    switch (type) {
      case SnackbarType.success:
        barColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      case SnackbarType.error:
        barColor = AppColors.danger;
        icon = Icons.error;
        break;
      case SnackbarType.warning:
        barColor = AppColors.warning;
        icon = Icons.warning_amber_rounded;
        break;
      case SnackbarType.info:
        barColor = AppColors.primary;
        icon = Icons.info_outline;
    }

    Flushbar(
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(icon, color: barColor, size: 28),
      titleText: title != null
          ? Text(
              title,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      messageText: Text(
        message,
        style: const TextStyle(color: AppColors.grey, fontSize: 14),
      ),
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: barColor,
      boxShadows: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ).show(overlayCtx);
  }
}
