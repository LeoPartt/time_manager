import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/widgets/app_card.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/dashboard_chart.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/team_selector.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedTeam;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
            final tr = AppLocalizations.of(context)!;


    return Scaffold(
             bottomNavigationBar: const NavBar(),

      body: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ────────────── Sélecteur d’équipe ──────────────
              TeamSelector(
                selectedTeam: selectedTeam,
                onChanged: (team) {
                  setState(() => selectedTeam = team);
                },
              ),

              const SizedBox(height: AppSizes.p24),

              // ────────────── Graphique ──────────────
              const DashboardChart(),

              const SizedBox(height: AppSizes.p24),

              // ────────────── KPI Card ──────────────
              AppCard(
                padding: const EdgeInsets.all(AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Accumulated delay time: 32 mins",
                        style: textTheme.bodyMedium),
                    const SizedBox(height: AppSizes.p16),
                    _buildProgress("Weekly work", 0.7),
                    const SizedBox(height: AppSizes.p16),
                    _buildProgress("Monthly work", 0.9),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.p24),

              // ────────────── Boutons ──────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Calendar"),
                    ),
                  ),
                  const SizedBox(width: AppSizes.p16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Team"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // TODO: Ajouter le AppBottomNav ici
    );
  }

  Widget _buildProgress(String label, double value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: AppSizes.p8),
        LinearProgressIndicator(
          value: value,
          color: colorScheme.primary,
          backgroundColor: colorScheme.surfaceContainerHighest,
          minHeight: 10,
          borderRadius: BorderRadius.circular(AppSizes.r8),
        ),
      ],
    );
  }
}
