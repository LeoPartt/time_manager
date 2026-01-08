import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
            final tr = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title:  Text(tr.dashboard)),
      // body: BlocBuilder<UserCubit, UserState>(
      //   builder: (context, state) {
      //     return state.when(
      //       initial: () => const Center(child: Text("No data yet")),
      //       loading: () => const Center(child: CircularProgressIndicator()),
      //       error: (msg) => Center(child: Text(msg)),
      //       loaded: (user) {
      //         usernameController.text = user.username;
      //         emailController.text = user.email;
      //         phoneController.text = user.phoneNumber ?? "";

      //         return Padding(
      //           padding: const EdgeInsets.all(24.0),
      //           child: Column(
      //             children: [
      //               TextField(
      //                 controller: usernameController,
      //                 decoration: const InputDecoration(labelText: "UserName"),
      //               ),
      //               TextField(
      //                 controller: emailController,
      //                 decoration: const InputDecoration(labelText: "Email"),
      //               ),
      //               TextField(
      //                 controller: phoneController,
      //                 decoration: const InputDecoration(labelText: "Phone"),
      //               ),
      //               const SizedBox(height: 20),
      //               ElevatedButton(
      //                 onPressed: () {
      //                   final params = UpdateUserProfileParams(
      //                     username: usernameController.text,
      //                     email: emailController.text,
      //                     phoneNumber: phoneController.text, id: 0,
      //                   );
      //                   context.read<UserCubit>().updateProfile(params);
      //                 },
      //                 child: const Text("Save Changes"),
      //               ),
      //               const SizedBox(height: 10),
      //               OutlinedButton(
      //                 onPressed: () =>
      //                     context.read<UserCubit>().removeAccount(id),
      //                 child: const Text("Delete Account"),
      //               ),
      //             ],
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
