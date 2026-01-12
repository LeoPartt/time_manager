
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
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class EditManagementUserScreen extends StatefulWidget {
  final User user;

  const EditManagementUserScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditManagementUserScreen> createState() => _EditManagementUserScreenState();
}

class _EditManagementUserScreenState extends State<EditManagementUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<UserCubit>().updateUser(
        context,
        userId: widget.user.id,
        username: _usernameController.text.trim(),
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
          updated: (user) {
            context.showSuccess(tr.userUpdatedSuccess);
            context.router.pop();
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
                        label: tr.editUser,
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
                              AccessibilityUtils.withTooltip(
                                context,
                                tooltip: tr.username,
                                child: AppInputField(
                                  label: tr.username,
                                  controller: _usernameController,
                                  icon: Icons.person_outline,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? tr.usernameRequired
                                          : null,
                                ),
                              ),
                              
                              SizedBox(height: AppSizes.p16),

                              AccessibilityUtils.withTooltip(
                                context,
                                tooltip: tr.firstName,
                                child: AppInputField(
                                  label: tr.firstName,
                                  controller: _firstNameController,
                                  icon: Icons.badge_outlined,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? tr.firstNameRequired
                                          : null,
                                ),
                              ),
                              
                              SizedBox(height: AppSizes.p16),

                              AccessibilityUtils.withTooltip(
                                context,
                                tooltip: tr.lastName,
                                child: AppInputField(
                                  label: tr.lastName,
                                  controller: _lastNameController,
                                  icon: Icons.badge_outlined,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? tr.lastNameRequired
                                          : null,
                                ),
                              ),
                              
                              SizedBox(height: AppSizes.p16),

                              AccessibilityUtils.withTooltip(
                                context,
                                tooltip: tr.email,
                                child: AppInputField(
                                  label: tr.email,
                                  controller: _emailController,
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) =>
                                      Validators.validateEmail(context, v),
                                ),
                              ),
                              
                              SizedBox(height: AppSizes.p16),
                              
                              AccessibilityUtils.withTooltip(
                                context,
                                tooltip: tr.phoneNumber,
                                child: AppPhoneField(
                                  controller: _phoneController,
                                  label: tr.phoneNumber,
                                  validator: (v) => Validators.validatePhone(
                                    context,
                                    v as String?,
                                  ),
                                  initialCountryCode: getDefaultCountryCode(),
                                ),
                              ),

                              SizedBox(height: AppSizes.p24),

                              AccessibilityUtils.withLabel(
                                label: tr.saveChanges,
                                child: AppButton(
                                  label: tr.saveChanges,
                                  fullSize: true,
                                  isLoading: isLoading,
                                  onPressed: () => _onSubmit(context),
                                  icon: Icons.save_outlined,
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