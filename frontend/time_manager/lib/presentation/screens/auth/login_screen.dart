
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/validators.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/core/widgets/app_input_field.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/account/auth_cubit.dart';
import 'package:time_manager/presentation/cubits/account/auth_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/auth/login_header.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    
    await context.read<AuthCubit>().login(
      context,
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final isTablet = context.screenWidth >= 600;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: _handleAuthStateChanges,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: context.responsivePadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 500 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      // Header avec logo
                      LoginHeader(isTablet: isTablet),
                      
                      SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p32)),
                      
                      // Formulaire
                      _buildLoginForm(tr, isTablet),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm(AppLocalizations tr, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(
        AppSizes.responsiveWidth(context, AppSizes.p24),
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha:0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre
            Text(
              tr.login,
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? AppSizes.textXxl : AppSizes.textXl,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: AppSizes.p24),
            
            // Champ username
            AppInputField(
              controller: _usernameController,
              label: tr.userNameLabel,
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.validateNotEmpty(
                context,
                v,
                tr.userNameLabel,
              ),
            ),
            
            SizedBox(height: AppSizes.p16),
            
            // Champ password
            AppInputField(
              controller: _passwordController,
              label: tr.passwordLabel,
              icon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (v) => Validators.validatePassword(context, v),
              onSubmitted: _handleLogin,
            ),
            
            SizedBox(height: AppSizes.p24),
            
            // Bouton de connexion
            AppButton(
              label: tr.loginButton,
              onPressed: _handleLogin,
              fullSize: true,
              isLoading: _isLoading,
            ),
            
            SizedBox(height: AppSizes.p16),
            
            // Lien mot de passe oublié
            TextButton(
              onPressed: () => context.showInfo(tr.forgotPassword),
              child: Text(
                tr.forgotPassword,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    state.maybeWhen(
      error: (message) {
        context.showError(message);
      },
      authenticated: (user, isNewLogin) async {
        if (!isNewLogin) return; // Session restaurée, pas de message
        
        final tr = AppLocalizations.of(context)!;
        context.showSuccess(tr.loginSuccessful);
        
        // Navigation après le frame
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          
          // Admin pur → Management
          if (user.isAdministrator && user.username.toLowerCase() == 'admin') {
            context.router.replaceAll([const ManagementRoute()]);
            return;
          }
          
          // User normal → Charger profil puis Dashboard
          try {
            await context.read<UserCubit>().loadProfile();
          } catch (e) {
            // Profil non chargé, continuer quand même
          }
          
          if (mounted) {
            context.router.replaceAll([DashboardRoute()]);
          }
        });
      },
      orElse: () {},
    );
  }
}