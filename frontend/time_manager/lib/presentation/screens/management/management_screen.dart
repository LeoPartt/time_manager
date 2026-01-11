
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_card.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;
    final isTablet = context.screenWidth >= 600;

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.p24),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 600 : double.infinity,
              ),
              child: Column(
                children: [
                  Header(label: tr.management),
                  
                  SizedBox(height: AppSizes.p24),

                  // Barre de recherche
             


                  // Actions rapides
                  _buildQuickActions(context, tr, colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    AppLocalizations tr,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        _buildActionCard(
          context,
          icon: Icons.person_add_outlined,
          title: tr.addUser,
          subtitle: tr.createNewUserAccount,
          color: AppColors.primary,
          onTap: () => context.pushRoute(CreateUserRoute()),
        ),
        
        SizedBox(height: AppSizes.p16),

        _buildActionCard(
          context,
          icon: Icons.group_add_outlined,
          title: tr.addTeam,
          subtitle: tr.createNewTeam,
          color: AppColors.success,
          onTap: () => context.pushRoute(const CreateTeamRoute()),
        ),

        SizedBox(height: AppSizes.p16),

        _buildActionCard(
          context,
          icon: Icons.calendar_month_outlined,
          title: tr.managePlanning,
          subtitle: tr.configurePlanningsForUsers,
          color: AppColors.warning,
          onTap: () => context.pushRoute( PlanningManagementRoute()),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colorScheme = context.colorScheme;
    
    return AppCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            
            SizedBox(width: AppSizes.p16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppSizes.textLg,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSizes.p4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppSizes.textSm,
                      color: colorScheme.onSurface.withValues(alpha:0.6),
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurface.withValues(alpha:0.4),
            ),
          ],
        ),
      ),
    );
  }
}