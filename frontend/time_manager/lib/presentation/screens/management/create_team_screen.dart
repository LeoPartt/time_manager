
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/core/widgets/app_card.dart';
import 'package:time_manager/core/widgets/app_input_field.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/team/team_cubit.dart';
import 'package:time_manager/presentation/cubits/team/team_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<TeamCubit>().createTeam(
            name: _nameController.text.trim(),
            description: _descController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final isTablet = context.screenWidth >= 600;

    return BlocConsumer<TeamCubit, TeamState>(
      listener: (context, state) {
        state.whenOrNull(
          loaded: (team,_) {
            context.showSuccess(tr.teamCreatedSuccess);
            context.router.replace(const ManagementRoute());
          },
          error: (msg) => context.showError(msg),
        );
      },
      builder: (context, state) {
        final isLoading = state is TeamLoading;

        return Scaffold(
          bottomNavigationBar: const NavBar(),
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
                        label: tr.createTeam,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.router.pop(),
                        ),
                      ),
                      
                      SizedBox(height: AppSizes.p24),

                      AppCard(
                        padding: EdgeInsets.all(AppSizes.p24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AppInputField(
                                label: tr.teamName,
                                controller: _nameController,
                                icon: Icons.group_outlined,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? tr.teamNameRequired
                                        : null,
                              ),
                              
                              SizedBox(height: AppSizes.p16),
                              
                              AppInputField(
                                label: tr.teamDescription,
                                controller: _descController,
                                icon: Icons.description_outlined,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                              ),
                              
                              SizedBox(height: AppSizes.p24),
                              
                              AppButton(
                                label: tr.createTeam,
                                fullSize: true,
                                isLoading: isLoading,
                                onPressed: () => _onSubmit(context),
                                icon: Icons.group_add,
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