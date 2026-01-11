import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class AppLoader extends StatelessWidget {
  final double size;
  final String? message;
  final bool showMessage;

  const AppLoader({
    super.key,
    this.size = 32,
    this.message,
    this.showMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scaledSize = AppSizes.responsiveHeight(context, size);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: scaledSize,
            height: scaledSize,
            child: CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
          if (showMessage && message != null) ...[
            SizedBox(height: AppSizes.p16),
            Text(
              message!,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha:0.6),
                fontSize: AppSizes.textMd,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ✅ Loader fullscreen avec overlay
class AppFullscreenLoader extends StatelessWidget {
  final String? message;

  const AppFullscreenLoader({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha:0.3),
      child: AppLoader(
        size: 48,
        message: message,
        showMessage: true,
      ),
    );
  }
}