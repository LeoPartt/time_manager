
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_search_bar.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/l10n/app_localizations.dart';

class UserSearchDialogWidget extends StatelessWidget {
  final Function(User) onUserSelected;
  final int? currentUserId;
  final AppLocalizations? tr;

  const UserSearchDialogWidget({
    super.key,
    required this.onUserSelected,
    this.currentUserId,
    this.tr,
  });

  @override
  Widget build(BuildContext context) {
    final translations = tr ?? AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(AppSizes.p20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha:0.8),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.r16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSizes.p12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: Text(
                      translations.searchUser,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p16),
                child: AppSearchBar(
                  onlyUsers: true,
                  currentUserId: currentUserId,
                  onUserSelected: onUserSelected,
                  customHint: translations.searchByNameOrEmail,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}