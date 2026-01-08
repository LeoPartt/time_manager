import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/accessibility_utils.dart';
import 'package:time_manager/core/utils/validators.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_avatars.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/core/widgets/app_input_field.dart';
import 'package:time_manager/core/widgets/app_card.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/account/auth_cubit.dart';
import 'package:time_manager/presentation/cubits/account/auth_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        context,
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width >= 600;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          error: (message) => context.showSnack(message, isError: true),
          authenticated: (_) {
            context.showSnack("✅ ${tr.login} ${tr.successful}");
            context.router.replaceAll([ DashboardRoute()]);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.responsiveWidth(context, AppSizes.p24),
                  vertical: AppSizes.responsiveHeight(context, AppSizes.p24),
                ),
                child: Semantics(
                  label: tr.loginButton,
                  hint: tr.login,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 500 : double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppCard(
                            padding: EdgeInsets.all(
                              AppSizes.responsiveWidth(context, AppSizes.p24),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AccessibilityUtils.withLabel(
                                    label: tr.login,
                                    child: AppAvatar(
                                      radius: isTablet ? 60 : 45,
                                      fallbackIcon:
                                          Icons.person_outline_rounded,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppSizes.responsiveHeight(
                                      context,
                                      AppSizes.p24,
                                    ),
                                  ),
                                  // Username
                                  AccessibilityUtils.withTooltip(
                                    context,
                                    tooltip: tr.userNameLabel,
                                    child: AppInputField(
                                      controller: _usernameController,
                                      label: tr.userNameLabel,
                                      icon: Icons.person_outline,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      validator: (v) =>
                                          Validators.validateNotEmpty(
                                            context,
                                            v,
                                            tr.userNameLabel,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.p16),

                                  // Password
                                  AccessibilityUtils.withTooltip(
                                    context,
                                    tooltip: tr.passwordLabel,
                                    child: AppInputField(
                                      controller: _passwordController,
                                      label: tr.passwordLabel,
                                      icon: Icons.lock_outline,
                                      obscureText: true,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.text,
                                      validator: (v) =>
                                          Validators.validatePassword(
                                            context,
                                            v,
                                          ),
                                      onSubmitted: () =>
                                          _onLoginPressed(context),
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.p24),

                                  // Login Button
                                  AccessibilityUtils.withLabel(
                                    label: tr.loginButton,
                                    child: AppButton(
                                      fullSize: true,
                                      isLoading: isLoading,
                                      label: tr.loginButton,
                                      onPressed: () => _onLoginPressed(context),
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.p16),

                                  // Forgot password
                                  Semantics(
                                    label: tr.forgotPassword,
                                    hint: tr.forgotPassword,
                                    button: true,
                                    child: TextButton(
                                      onPressed: () {
                                        context.showSnack(
                                          "🔐 ${tr.forgotPassword}",
                                        );
                                      },
                                      child: Text(
                                        tr.forgotPassword,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                        
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
