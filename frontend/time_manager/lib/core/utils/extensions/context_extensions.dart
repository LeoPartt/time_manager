
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

extension ContextExtensions on BuildContext {
  // Screen dimensions
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Theme helpers
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Snackbar helper
  void showSnack(String message, {bool isError = false}) {
    final color = isError ? Colors.red : Colors.green;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(AppSizes.p16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r8),
        ),
      ),
    );
  }

  // Success snackbar
  void showSuccess(String message) {
    showSnack(message, isError: false);
  }

  // Error snackbar
  void showError(String message) {
    showSnack(message, isError: true);
  }

  // Info snackbar
  void showInfo(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(AppSizes.p16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r8),
        ),
      ),
    );
  }

  // Loading dialog
  void showLoadingDialog({String message = 'Chargement...'}) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              SizedBox(width: AppSizes.p16),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }

  // Close loading dialog
  void hideLoadingDialog() {
    Navigator.of(this).pop();
  }

  // Confirmation dialog
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isDangerous ? Icons.warning_amber_rounded : Icons.info_outline,
              color: isDangerous ? Colors.red : colorScheme.primary,
            ),
            SizedBox(width: AppSizes.p12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous ? Colors.red : colorScheme.primary,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Responsive padding
  EdgeInsets get responsivePadding => EdgeInsets.all(
        screenWidth > 600 ? AppSizes.p24 : AppSizes.p16,
      );
}