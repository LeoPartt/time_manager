import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/accessibility_utils.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/utils/validators.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/core/widgets/app_card.dart';
import 'package:time_manager/core/widgets/app_input_field.dart';
import 'package:time_manager/core/widgets/app_phone_field.dart';
import 'package:time_manager/core/widgets/get_default_contry_code.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';

@RoutePage()
class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<UserCubit>().createUser(
        context,
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final padding = AppSizes.responsiveWidth(context, AppSizes.p24);

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        state.whenOrNull(
          loaded: (user) {
            context.showSnack("✅ ${user.username} ${tr.registerButton} !");
            context.router.replace(const ManagementRoute());
          },
          error: (message) => context.showSnack(message, isError: true),
        );
      },
      builder: (context, state) {
        final isLoading = state is UserLoading;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: AppSizes.responsiveHeight(context, AppSizes.p24),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 600 : double.infinity,
                  ),
                  child: Column(
                    children: [
  AccessibilityUtils.withLabel(
                        label: tr.registerTitle,
                        child: Header(label: tr.registerTitle),
                      ),                      SizedBox(
                        height: AppSizes.responsiveHeight(
                          context,
                          AppSizes.p24,
                        ),
                      ),

                      // ────────────── FORM CARD ──────────────
                      AppCard(
                        padding: EdgeInsets.all(
                          AppSizes.responsiveWidth(context, AppSizes.p20),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
   AccessibilityUtils.withTooltip(
    context,
                                tooltip: tr.userNameLabel,                                child: AppInputField(
                                  label: tr.userNameLabel,
                                  controller: _usernameController,
                                  icon: Icons.person,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              const SizedBox(height: AppSizes.p16),

   AccessibilityUtils.withTooltip(context,
                                tooltip: tr.passwordLabel,                                child: AppInputField(
                                  label: tr.passwordLabel,
                                  controller: _passwordController,
                                  obscureText: true,
                                  icon: Icons.lock_outline,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) =>
                                      Validators.validatePassword(context, v),
                                ),
                              ),
                              const SizedBox(height: AppSizes.p16),

                              AccessibilityUtils.withTooltip(
                                context,
                                tooltip: tr.firstNameLabel,
                                child: AppInputField(
                                  label: tr.firstNameLabel,
                                  controller: _firstNameController,
                                  icon: Icons.person_outline,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              const SizedBox(height: AppSizes.p16),

                              AccessibilityUtils.withTooltip(context,
                                tooltip: tr.lastNameLabel,
                                child: AppInputField(
                                  label: tr.lastNameLabel,
                                  controller: _lastNameController,
                                  icon: Icons.person_outline,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              const SizedBox(height: AppSizes.p16),

AccessibilityUtils.withTooltip(context,
                                tooltip: tr.lastNameLabel,                                child: AppInputField(
                                  label: tr.emailLabel,
                                  controller: _emailController,
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) =>
                                      Validators.validateEmail(context, v),
                                ),
                              ),
                              const SizedBox(height: AppSizes.p16),
                              AccessibilityUtils.withTooltip(context,
                                tooltip: tr.phoneNumberLabel,
                                child: AppPhoneField(
                                  controller: _phoneController,
                                  label: tr.phoneNumberLabel,
                                  validator: (v) => Validators.validatePhone(
                                    context,
                                    v as String?,
                                  ),
                                
                                  initialCountryCode: getDefaultCountryCode(),
                                ),
                              ),

                              SizedBox(
                                height: AppSizes.responsiveHeight(
                                  context,
                                  AppSizes.p24,
                                ),
                              ),

                              // ────────────── SUBMIT BUTTON ──────────────
 AccessibilityUtils.withLabel(
                                label: tr.registerButton,                                child: AppButton(
                                  label: tr.registerButton,
                                  fullSize: true,
                                  isLoading: isLoading,
                                  onPressed: () => _onSubmit(context),
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
        );
      },
    );
  }
}
