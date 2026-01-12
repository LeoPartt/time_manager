
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/account/forgot_password_cubit.dart';
import 'package:time_manager/presentation/cubits/account/forgot_password_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';

@RoutePage()
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<ForgotPasswordCubit>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordCubit>().changePassword(
            context,
            code: _codeController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;
    final isTablet = context.screenWidth >= 600;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.p24),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 500 : double.infinity,
              ),
              child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  state.whenOrNull(
                    success: () {
                      context.showSuccess(tr.passwordChangedSuccess);
                      context.router.replaceAll([const LoginRoute()]);
                    },
                    error: (msg) => context.showError(msg),
                  );
                },
                builder: (context, state) {
                  final isLoading = state is Loading;

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 48),

                        // Header
                        Header(
                          label: tr.resetPassword,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.router.pop(),
                          ),
                        ),

                        SizedBox(height: AppSizes.p32),

                        // Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_reset_rounded,
                            size: 60,
                            color: colorScheme.primary,
                          ),
                        ),

                        SizedBox(height: AppSizes.p32),

                        // Description
                        Text(
                          tr.forgotPasswordDesc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppSizes.textMd,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),

                        SizedBox(height: AppSizes.p32),

                        // Code Field
                        TextFormField(
                          controller: _codeController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: tr.resetCode,
                            hintText: '123456',
                            prefixIcon: const Icon(Icons.pin_outlined),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr.codeRequired;
                            }
                            if (value.length != 6) {
                              return tr.codeMustBe6Digits;
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: AppSizes.p24),

                        // New Password Field
                        TextFormField(
                          controller: _passwordController,
                          enabled: !isLoading,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: tr.newPassword,
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr.passwordRequired;
                            }
                            if (value.length < 6) {
                              return tr.shortPassword;
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: AppSizes.p24),

                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          enabled: !isLoading,
                          obscureText: _obscureConfirm,
                          decoration: InputDecoration(
                            labelText: tr.confirmPassword,
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() => _obscureConfirm = !_obscureConfirm);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr.confirmPasswordRequired;
                            }
                            if (value != _passwordController.text) {
                              return tr.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: AppSizes.p32),

                        // Submit Button
                        AppButton(
                          label: tr.resetPassword,
                          onPressed: _handleSubmit,
                          isLoading: isLoading,
                          fullSize: true,
                        ),

                        SizedBox(height: AppSizes.p16),

                        // Back to Login
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => context.router.pop(),
                          child: Text(tr.backToLogin),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}