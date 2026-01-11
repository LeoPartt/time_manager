
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/theme/local_provider.dart';
import 'package:time_manager/core/theme/theme_switcher.dart';
import 'package:time_manager/core/widgets/app_info_provider.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/account/auth_cubit.dart';
import 'package:time_manager/presentation/cubits/account/auth_state.dart';import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
@override
  
  void initState() {
    super.initState();
    // ✅ Charger le profil si pas encore fait (pour les non-admins)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final authState = context.read<AuthCubit>().state;
      authState.whenOrNull(
        authenticated: (user, isNewLogin) {
          // ✅ Si pas admin, charger le profil
          if (!(user.isAdministrator && user.username.toLowerCase() == 'admin')) {
            final userState = context.read<UserCubit>().state;
            if (userState is Initial) {
              context.read<UserCubit>().loadProfile();
            }
          }
        },
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    final themeSwitcher = context.watch<ThemeSwitcher>();
    final localeProvider = context.watch<LocaleProvider>();
    final tr = AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;
    final isTablet = context.screenWidth >= 600;
    final appInfo = context.watch<AppInfoProvider>();

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            AppSizes.responsiveWidth(context, AppSizes.p24),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 600 : double.infinity,
              ),
              child: Column(
                children: [
                  // Header
                  Header(label: tr.settings),

                  SizedBox(height: AppSizes.p24),

                  // Section Apparence
                  _buildSectionHeader(context, tr.appearance, Icons.palette_outlined),

                  SizedBox(height: AppSizes.p12),

                  // Dark Mode Toggle
                  _buildSettingCard(
                    context,
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.p16,
                        vertical: AppSizes.p8,
                      ),
                      title: Text(
                        tr.darkMode,
                        style: TextStyle(
                          fontSize: AppSizes.textMd,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        themeSwitcher.isDarkMode
                            ? tr.currentThemeDark
                            : tr.currentThemeLight,
                        style: TextStyle(
                          fontSize: AppSizes.textSm,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      value: themeSwitcher.isDarkMode,
                      onChanged: (value) => themeSwitcher.toggleTheme(),
                      secondary: Container(
                        padding: EdgeInsets.all(AppSizes.p8),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppSizes.r8),
                        ),
                        child: Icon(
                          themeSwitcher.isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: AppSizes.p32),

                  // Section Langue
                  _buildSectionHeader(context, tr.language, Icons.language_rounded),

                  SizedBox(height: AppSizes.p12),

                  // Language Selector
                  _buildSettingCard(
                    context,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.p16,
                        vertical: AppSizes.p8,
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(AppSizes.p8),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppSizes.r8),
                        ),
                        child: Icon(
                          Icons.translate_rounded,
                          color: colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        tr.language,
                        style: TextStyle(
                          fontSize: AppSizes.textMd,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        _getLanguageName(localeProvider.locale, tr),
                        style: TextStyle(
                          fontSize: AppSizes.textSm,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      trailing: DropdownButton<Locale>(
                        value: localeProvider.locale,
                        underline: const SizedBox.shrink(),
                        icon: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: colorScheme.primary,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: const Locale('en'),
                            child: Row(
                              children: [
                                const Text('🇬🇧  '),
                                Text(tr.english),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: const Locale('fr'),
                            child: Row(
                              children: [
                                const Text('🇫🇷  '),
                                Text(tr.french),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (locale) {
                          if (locale != null) {
                            localeProvider.setLocale(locale);
                            context.showSuccess(tr.languageChanged);
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: AppSizes.p32),

                  // Section Notifications
                  _buildSectionHeader(context, tr.notifications, Icons.notifications_outlined),

                  SizedBox(height: AppSizes.p12),

                  _buildSettingCard(
                    context,
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSizes.p16,
                            vertical: AppSizes.p8,
                          ),
                          title: Text(
                            tr.pushNotifications,
                            style: TextStyle(
                              fontSize: AppSizes.textMd,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            tr.pushNotificationsDesc,
                            style: TextStyle(
                              fontSize: AppSizes.textSm,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          value: true,
                          onChanged: (value) {},
                          secondary: Container(
                            padding: EdgeInsets.all(AppSizes.p8),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(AppSizes.r8),
                            ),
                            child: Icon(
                              Icons.notifications_active_outlined,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),

                        Divider(
                          height: 1,
                          color: colorScheme.outline.withValues(alpha: 0.2),
                        ),

                        SwitchListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSizes.p16,
                            vertical: AppSizes.p8,
                          ),
                          title: Text(
                            tr.emailNotifications,
                            style: TextStyle(
                              fontSize: AppSizes.textMd,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            tr.emailNotificationsDesc,
                            style: TextStyle(
                              fontSize: AppSizes.textSm,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          value: false,
                          onChanged: (value) {},
                          secondary: Container(
                            padding: EdgeInsets.all(AppSizes.p8),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(AppSizes.r8),
                            ),
                            child: Icon(
                              Icons.email_outlined,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.p32),

                  // Section À propos
                  _buildSectionHeader(context, tr.about, Icons.info_outline),

                  SizedBox(height: AppSizes.p12),

                  _buildSettingCard(
                    context,
                    child: Column(
                      children: [
                        _buildInfoTile(
                          context,
                          icon: Icons.app_settings_alt_outlined,
                          title: tr.appVersion,
                          subtitle: appInfo.isLoaded ? appInfo.version : '—',
                        ),

                        Divider(
                          height: 1,
                          color: colorScheme.outline.withValues(alpha: 0.2),
                        ),

                        _buildInfoTile(
                          context,
                          icon: Icons.verified_outlined,
                          title: tr.buildNumber,
                          subtitle: appInfo.isLoaded ? appInfo.buildNumber : '—',
                        ),
                      ],
                    ),
                  ),

                  // ✅ Bouton Déconnexion Admin Only
                 BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    
    return state.when(
      initial: () {
        return const SizedBox.shrink();
      },
      loading: () {
        return const SizedBox.shrink();
      },
       unauthenticated: () => const SizedBox.shrink(),
      authenticated: (user,isNewLogin) {
        
        if (user.isAdministrator && user.username.toLowerCase() == 'admin') {
          return Column(
            children: [
              SizedBox(height: AppSizes.p32),
              _buildSectionHeader(
                context,
                tr.account,
                Icons.admin_panel_settings_outlined,
              ),
              SizedBox(height: AppSizes.p12),
              _buildLogoutButton(context, tr, colorScheme),
            ],
          );
        } else {
        }
        return const SizedBox.shrink();
      },
     
      error: (msg) {
        return const SizedBox.shrink();
      },
    );
  },
),

                  SizedBox(height: AppSizes.p32),

                  // Footer
                  Text(
                    tr.accessibilityInfo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSizes.textSm,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final colorScheme = context.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        SizedBox(width: AppSizes.p8),
        Text(
          title,
          style: TextStyle(
            fontSize: AppSizes.textLg,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard(BuildContext context, {required Widget child}) {
    final colorScheme = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = context.colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p8,
      ),
      leading: Container(
        padding: EdgeInsets.all(AppSizes.p8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppSizes.r8),
        ),
        child: Icon(
          icon,
          color: colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppSizes.textMd,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: AppSizes.textSm,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  // ✅ Bouton de déconnexion
  Widget _buildLogoutButton(
    BuildContext context,
    AppLocalizations tr,
    ColorScheme colorScheme,
  ) {
    return _buildSettingCard(
      context,
      child: InkWell(
        onTap: () => _showLogoutConfirmation(context, tr),
        borderRadius: BorderRadius.circular(AppSizes.r16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p16,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.p8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              SizedBox(width: AppSizes.p16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.logout,
                      style: TextStyle(
                        fontSize: AppSizes.textMd,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: AppSizes.p4),
                    Text(
                      tr.logoutAdminDesc,
                      style: TextStyle(
                        fontSize: AppSizes.textSm,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.red.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Dialog de confirmation
  Future<void> _showLogoutConfirmation(
    BuildContext context,
    AppLocalizations tr,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: AppSizes.p12),
            Text(tr.logoutConfirmation),
          ],
        ),
        content: Text(tr.logoutConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(tr.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(tr.logout),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().logout();
      if (context.mounted) {
        context.router.replaceAll([const LoginRoute()]);
        context.showSuccess(tr.logoutSuccessful);
      }
    }
  }

  String _getLanguageName(Locale locale, AppLocalizations tr) {
    switch (locale.languageCode) {
      case 'en':
        return tr.english;
      case 'fr':
        return tr.french;
      default:
        return tr.english;
    }
  }
}