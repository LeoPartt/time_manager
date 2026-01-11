import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
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
import 'package:time_manager/presentation/widgets/navbar.dart';

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
    final isTablet = context.screenWidth >= 600;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        state.whenOrNull(
          loaded: (user) {
            context.showSuccess('${user.username} ${tr.createdSuccessfully}');
            context.router.replace(const ManagementRoute());
          },
          error: (message) => context.showError(message),
        );
      },
      builder: (context, state) {
        final isLoading = state is UserLoading;

        return Scaffold(
          bottomNavigationBar: const NavBar(),
          resizeToAvoidBottomInset: true,
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
                      Header(
                        label: tr.createUser,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.router.pop(),
                        ),
                      ),
                      
                      SizedBox(height: AppSizes.p24),

                      AppCard(
                        padding: EdgeInsets.all(AppSizes.p20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AppInputField(
                                label: tr.username,
                                controller: _usernameController,
                                icon: Icons.person_outline,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: AppSizes.p16),

                              AppInputField(
                                label: tr.passwordLabel,
                                controller: _passwordController,
                                obscureText: true,
                                icon: Icons.lock_outline,
                                textInputAction: TextInputAction.next,
                                validator: (v) =>
                                    Validators.validatePassword(context, v),
                              ),
                              SizedBox(height: AppSizes.p16),

                              AppInputField(
                                label: tr.firstName,
                                controller: _firstNameController,
                                icon: Icons.badge_outlined,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: AppSizes.p16),

                              AppInputField(
                                label: tr.lastName,
                                controller: _lastNameController,
                                icon: Icons.badge_outlined,
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: AppSizes.p16),

                              AppInputField(
                                label: tr.emailLabel,
                                controller: _emailController,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (v) =>
                                    Validators.validateEmail(context, v),
                              ),
                              SizedBox(height: AppSizes.p16),

                              AppPhoneField(
                                controller: _phoneController,
                                label: tr.phoneNumber,
                                validator: (v) =>
                                    Validators.validatePhone(context, v as String?),
                                initialCountryCode: getDefaultCountryCode(),
                              ),

                              SizedBox(height: AppSizes.p24),

                              AppButton(
                                label: tr.createUser,
                                fullSize: true,
                                isLoading: isLoading,
                                onPressed: () => _onSubmit(context),
                                icon: Icons.person_add,
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