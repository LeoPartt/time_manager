import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:time_manager/core/theme/local_provider.dart';
import 'package:time_manager/core/widgets/app_info_provider.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/account/auth_cubit.dart';
import 'package:time_manager/presentation/cubits/clock/clock_cubit.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:time_manager/presentation/cubits/planning/planning_cubit.dart';
import 'package:time_manager/presentation/cubits/team/team_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/navigation/navbar_cubit.dart';
import 'core/theme/theme_switcher.dart';
import 'presentation/routes/app_router.dart';
import 'initialization/locator.dart';


class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = locator<AppRouter>();
    final localeProvider = context.watch<LocaleProvider>();

    return Consumer<ThemeSwitcher>(
      builder: (context, themeSwitcher, _) {
        return MultiBlocProvider(
          providers: [
              ChangeNotifierProvider(
      create: (_) => AppInfoProvider()..load(),
    ),
            BlocProvider<AuthCubit>(
               create: (_) => locator<AuthCubit>()..restoreSession(),
            ),
            BlocProvider<UserCubit>(
              create: (_) => locator<UserCubit>(),
            ),
            BlocProvider<NavCubit>(
              create: (_) => NavCubit(),
            ),
            BlocProvider<DashboardCubit>(
              create: (_) =>  locator<DashboardCubit>(),
            ),
        
            BlocProvider<ClockCubit>(
              create: (_) => locator<ClockCubit>()..getStatus(context),
            ),
            BlocProvider<PlanningCubit>(
              create: (_) => locator<PlanningCubit>(),
            ),
            BlocProvider(create: (_) => locator<TeamCubit>(),)
          ],
          child: MaterialApp.router(
            theme: themeSwitcher.currentTheme,
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: appRouter.config(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
