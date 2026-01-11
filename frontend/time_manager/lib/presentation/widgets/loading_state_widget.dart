
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class LoadingStateWidget extends StatelessWidget {
  final String message;
  final bool showMessage;

  const LoadingStateWidget({
    super.key,
    this.message = 'Chargement en cours...',
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
            strokeWidth: 3,
          ),
          if (showMessage) ...[
            SizedBox(height: AppSizes.p20),
            Text(
              message,
              style: TextStyle(
                fontSize: AppSizes.textMd,
                color: colorScheme.onSurface.withValues(alpha:0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}