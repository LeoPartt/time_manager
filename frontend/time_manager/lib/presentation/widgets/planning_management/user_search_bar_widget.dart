
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/l10n/app_localizations.dart';

class UserSearchBarWidget extends StatelessWidget {
  final User? selectedUser;
  final VoidCallback onSearchTap;
  final AppLocalizations? tr;

  const UserSearchBarWidget({
    super.key,
    this.selectedUser,
    required this.onSearchTap,
    this.tr,
  });

  @override
  Widget build(BuildContext context) {
    final translations = tr ?? AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha:0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (selectedUser != null) ...[
            _buildSelectedUserCard(context, selectedUser!, colorScheme, translations),
            SizedBox(height: AppSizes.p12),
          ],
          _buildSearchButton(context, colorScheme, translations),
        ],
      ),
    );
  }

  Widget _buildSelectedUserCard(
    BuildContext context,
    User user,
    ColorScheme colorScheme,
    AppLocalizations translations,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha:0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha:0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
         
          
          SizedBox(width: AppSizes.p16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppSizes.p4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha:0.9),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton(
    BuildContext context,
    ColorScheme colorScheme,
    AppLocalizations translations,
  ) {
    return InkWell(
      onTap: onSearchTap,
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p16,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha:0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: AppSizes.p12),
            Expanded(
              child: Text(
                selectedUser == null
                    ? translations.searchUser
                    : translations.changeUser,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha:0.6),
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: colorScheme.onSurface.withValues(alpha:0.6),
            ),
          ],
        ),
      ),
    );
  }
}