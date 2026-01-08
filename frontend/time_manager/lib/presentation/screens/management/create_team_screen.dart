import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/constants/app_strings.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/core/widgets/app_card.dart';
import 'package:time_manager/core/widgets/app_input_field.dart';
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
      context.router.replace(const ManagementRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.p24),
          children: [
            const Header(label: AppStrings.createTeam),
            const SizedBox(height: AppSizes.p32),
            AppCard(
              padding: const EdgeInsets.all(AppSizes.p24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppInputField(
                      label: AppStrings.teamNameLabel,
                      controller: _nameController,
                      icon: Icons.group_outlined,
                      textInputAction: TextInputAction.next,
                      validator: (value) => value == null || value.isEmpty
                          ? "Please enter a team name"
                          : null,
                    ),
                    const SizedBox(height: AppSizes.p16),
                    AppInputField(
                      label: AppStrings.teamDescriptionLabel,
                      controller: _descController,
                      icon: Icons.description_outlined,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSizes.p24),
                    BlocBuilder<TeamCubit, TeamState>(
                      builder: (context, state) {
                        final isLoading = state is TeamLoading;
                        return AppButton(
                          label: "Create Team",
                          fullSize: true,
                          isLoading: isLoading,
                          onPressed: () => _onSubmit(context),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
