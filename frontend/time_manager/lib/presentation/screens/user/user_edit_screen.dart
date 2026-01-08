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
import 'package:time_manager/core/widgets/app_loader.dart';
import 'package:time_manager/core/widgets/app_phone_field.dart';
import 'package:time_manager/core/widgets/get_default_contry_code.dart';
import 'package:time_manager/domain/usecases/user/update_user_profile.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';

@RoutePage()
class UserEditScreen extends StatefulWidget {
  final int userId;
  const UserEditScreen({super.key, required this.userId});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUser(context, widget.userId);
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
      context.read<UserCubit>().updateProfile(context,
        UpdateUserProfileParams(
          id: widget.userId,
          username: _usernameController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width >= 600;
      final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        state.whenOrNull(
          updated: (user) {
            context.showSnack("✅ ${tr.modify} ${tr.successful}");
            context.router.replace(const UserRoute());
          },
          error: (msg) => context.showSnack(msg, isError: true),
        );
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: AppLoader());
        }

        if (state is UserLoaded) {
          final user = state.user;
          _usernameController.text = user.username;
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
          _emailController.text = user.email;
          _phoneController.text = user.phoneNumber ?? '';

          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.responsiveWidth(context, AppSizes.p24),
                  vertical: AppSizes.responsiveHeight(context, AppSizes.p24),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 600 : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ────────────── HEADER ──────────────
 AccessibilityUtils.withLabel(
                          label: tr.modify,
                          child: Header(label: tr.modify.toUpperCase()),
                        ),
                        SizedBox(
                          height: AppSizes.responsiveHeight(
                            context,
                            AppSizes.p24,
                          ),
                        ),

                        AppCard(
                          padding: EdgeInsets.all(
                            AppSizes.responsiveWidth(context, AppSizes.p20),
                          ),
                          child: Form(
                            key: _formKey,
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,

                            child: Column(
                              children: [
                                AccessibilityUtils.withTooltip(
                                  context,
                                  tooltip: tr.userNameLabel,
                                  child: AppInputField(
                                    label: tr.userNameLabel,
                                    controller: _usernameController,
                                    icon: Icons.person,
                                    textInputAction: TextInputAction.next,
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
                                  tooltip: tr.emailLabel,
                                  child: AppInputField(
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

                                AccessibilityUtils.withLabel(
                                  label: tr.validate,
                                  child: AppButton(
                                    label: tr.validate,
                                    fullSize: true,
                                    isLoading: state is UserLoading,
                                    onPressed: () => _onSubmit(context),
                                  ),
                                ),

                                 Semantics(
                          label: tr.validate,
                          readOnly: true,
                          child: Text(
                            tr.validate,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha:0.6),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
