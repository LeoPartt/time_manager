import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';
import 'package:time_manager/core/widgets/app_search_bar.dart'; 

@RoutePage()
class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      body: Container(
        width: double.infinity,
        alignment: Alignment.topCenter, 
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.04),
          child: Column(
            children: [
              Header(label: tr.management),
              SizedBox(height: size.height * 0.04),

              AppSearchBar(
              ),
              SizedBox(height: size.height * 0.04),

              AppButton(
                label: tr.addanewuser,
                fullSize: true,
                onPressed: () => context.pushRoute( PlanningManagementRoute(userId: 1)),
              ),
              SizedBox(height: size.height * 0.03),
              AppButton(
                label: tr.addanewteam,
                fullSize: true,
                onPressed: () => context.pushRoute(const CreateTeamRoute()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
