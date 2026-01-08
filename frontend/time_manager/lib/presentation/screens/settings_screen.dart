import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/accessibility_utils.dart';
import 'package:time_manager/core/theme/local_provider.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';
import '../../core/theme/theme_switcher.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeSwitcher = context.watch<ThemeSwitcher>();
    final localeProvider = context.watch<LocaleProvider>();
    final tr = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.responsiveWidth(context, AppSizes.p24),
            vertical: AppSizes.responsiveHeight(context, AppSizes.p24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AccessibilityUtils.withLabel(
                label: tr.settings,
                child: Header(label: tr.settings.toUpperCase()),
              ),
              SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

              Semantics(
                label: tr.darkMode,
                hint: tr.toggleThemeHint,
                toggled: themeSwitcher.isDarkMode,
                child: Container(
                  padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p16)),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSizes.r16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SwitchListTile(
                    title: Text(
                      tr.darkMode,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: AccessibilityUtils.accessibleText(
                          context,
                          AppSizes.textLg,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      themeSwitcher.isDarkMode
                          ? tr.currentThemeDark
                          : tr.currentThemeLight,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: AccessibilityUtils.accessibleText(
                          context,
                          AppSizes.textMd,
                        ),
                      ),
                    ),
                    value: themeSwitcher.isDarkMode,
                    onChanged: (value) => themeSwitcher.toggleTheme(),
                    activeThumbColor: colorScheme.primary,
                    inactiveThumbColor: colorScheme.secondary,
                    secondary: Icon(
                      themeSwitcher.isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: colorScheme.primary,
                      size: AppSizes.responsiveIcon(context, AppSizes.iconLarge),
                      semanticLabel: themeSwitcher.isDarkMode
                          ? tr.currentThemeDark
                          : tr.currentThemeLight,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p32)),

              // ────────────── Language Selection Section ──────────────
              Semantics(
                label: tr.language,
                hint: tr.languageSelectionHint,
                child: Container(
                  padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p16)),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSizes.r16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.language_rounded),
                    title: Text(
                      tr.language,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: AccessibilityUtils.accessibleText(
                          context,
                          AppSizes.textLg,
                        ),
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
                          child: Text(
                            tr.english,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: AccessibilityUtils.accessibleText(
                                context,
                                AppSizes.textMd,
                              ),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: const Locale('fr'),
                          child: Text(
                            tr.french,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: AccessibilityUtils.accessibleText(
                                context,
                                AppSizes.textMd,
                              ),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (locale) {
                        if (locale != null) localeProvider.setLocale(locale);
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p32)),

              ExcludeSemantics(
                child: Text(
                  tr.accessibilityInfo,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: AccessibilityUtils.accessibleText(
                      context,
                      AppSizes.textSm,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
