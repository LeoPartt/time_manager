
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/utils/validators.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/core/widgets/app_input_field.dart';
import 'package:time_manager/core/widgets/app_phone_field.dart';
import 'package:time_manager/domain/usecases/user/update_user_profile.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/loading_state_widget.dart';

@RoutePage()
class UserEditScreen extends StatefulWidget {
  final int userId;
  
  const UserEditScreen({
    super.key,
    @PathParam('id') required this.userId,
  });

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
  
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    // Détecter les changements
    _usernameController.addListener(_onFieldChanged);
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  void _loadUserData() {
    final state = context.read<UserCubit>().state;
    if (state is! UserLoaded) {
      context.read<UserCubit>().getUser(context, widget.userId);
    }
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
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

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_hasChanges) {
      context.showInfo('Aucune modification détectée');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<UserCubit>().updateProfile(
        context,
        UpdateUserProfileParams(
          id: widget.userId,
          username: _usernameController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty 
              ? null 
              : _phoneController.text.trim(),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _handleBackPress() async {
    if (!_hasChanges) return true;

    final tr = AppLocalizations.of(context)!;
    final confirmed = await context.showConfirmDialog(
      title: tr.unsavedChanges,
      message: tr.unsavedChangesMessage,
      confirmText: tr.discard,
      cancelText: tr.cancel,
      isDangerous: true,
    );

    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final isTablet = context.screenWidth >= 600;

    return PopScope(
      canPop: !_hasChanges,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _handleBackPress();
          if (shouldPop && context.mounted) {
            context.router.pop();
          }
        }
      },
      child: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          state.whenOrNull(
            updated: (user) {
              context.showSuccess(tr.profileUpdated);
              context.router.pop();
            },
            error: (msg) => context.showError(msg),
          );
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: state.when(
                initial: () => const LoadingStateWidget(),
                loading: () => const LoadingStateWidget(),
                loaded: (user) => _buildForm(context, user, tr, isTablet),
                updated: (user) => _buildForm(context, user, tr, isTablet),
                listLoaded: (_) => const SizedBox.shrink(),
                deleted: () => const SizedBox.shrink(),
                error: (msg) => Center(child: Text(msg)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    dynamic user,
    AppLocalizations tr,
    bool isTablet,
  ) {
    // Remplir les champs si vides
    if (_usernameController.text.isEmpty) {
      _usernameController.text = user.username;
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber ?? '';
      _hasChanges = false;
    }

    final colorScheme = context.colorScheme;

    return SingleChildScrollView(
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
              // Header avec bouton retour
              Header(
                label: tr.editProfile,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    final canPop = await _handleBackPress();
                    if (canPop && context.mounted) {
                      context.router.pop();
                    }
                  },
                ),
              ),
              
              SizedBox(height: AppSizes.p24),
              
              // Formulaire
              Container(
                padding: EdgeInsets.all(AppSizes.p24),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha:0.2),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Username
                      AppInputField(
                        label: tr.username,
                        controller: _usernameController,
                        icon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.validateNotEmpty(
                          context,
                          v,
                          tr.username,
                        ),
                      ),
                      
                      SizedBox(height: AppSizes.p16),
                      
                      // Prénom
                      AppInputField(
                        label: tr.firstName,
                        controller: _firstNameController,
                        icon: Icons.badge_outlined,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.validateNotEmpty(
                          context,
                          v,
                          tr.firstName,
                        ),
                      ),
                      
                      SizedBox(height: AppSizes.p16),
                      
                      // Nom
                      AppInputField(
                        label: tr.lastName,
                        controller: _lastNameController,
                        icon: Icons.badge_outlined,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.validateNotEmpty(
                          context,
                          v,
                          tr.lastName,
                        ),
                      ),
                      
                      SizedBox(height: AppSizes.p16),
                      
                      // Email
                      AppInputField(
                        label: tr.emailLabel,
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.validateEmail(context, v),
                      ),
                      
                      SizedBox(height: AppSizes.p16),
                      
                      // Téléphone
                      AppPhoneField(
                        controller: _phoneController,
                        label: tr.phoneNumber,
                      ),
                      
                      SizedBox(height: AppSizes.p32),
                      
                      // Boutons
                      Row(
                        children: [
                          Expanded(
                            child: AppOutlinedButton(
                              label: tr.cancel,
                              onPressed: () async {
                                final canPop = await _handleBackPress();
                                if (canPop && context.mounted) {
                                  context.router.pop();
                                }
                              },
                              fullSize: true,
                            ),
                          ),
                          
                          SizedBox(width: AppSizes.p16),
                          
                          Expanded(
                            child: AppButton(
                              label: tr.save,
                              onPressed: _handleSubmit,
                              fullSize: true,
                              isLoading: _isLoading,
                              icon: Icons.save_outlined,
                            ),
                          ),
                        ],
                      ),
                      
                      if (_hasChanges) ...[
                        SizedBox(height: AppSizes.p16),
                        Container(
                          padding: EdgeInsets.all(AppSizes.p12),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha:0.3),
                            borderRadius: BorderRadius.circular(AppSizes.r8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              SizedBox(width: AppSizes.p8),
                              Expanded(
                                child: Text(
                                  tr.unsavedChangesHint,
                                  style: TextStyle(
                                    fontSize: AppSizes.textSm,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
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