// lib/core/utils/toast_service.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ToastService {
  static void show(
      BuildContext context,
      String message, {
        bool isError = false,
      }) {
    // Clear any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    // Calculate exact position BELOW AppBar
    final double topOffset =
        MediaQuery.of(context).padding.top + kToolbarHeight + 12;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,

        // Position toast below AppBar
        margin: EdgeInsets.only(
          top: topOffset,
          left: 16,
          right: 16,
        ),

        backgroundColor: isError ? Colors.red : AppColors.primary,
        elevation: 6,
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.up,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
