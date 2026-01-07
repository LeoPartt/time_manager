import 'package:get_it/get_it.dart';
import 'package:time_manager/data/datasources/local/local_storage_service.dart';
import 'package:time_manager/data/datasources/remote/account_api.dart';
import 'package:time_manager/data/datasources/remote/schedule_api.dart';
import 'package:time_manager/data/datasources/remote/team_api.dart';
import 'package:time_manager/data/datasources/remote/user_api.dart';
import 'package:time_manager/data/repositories_impl/account_repository_impl.dart';
import 'package:time_manager/data/repositories_impl/schedule_repository_impl.dart';
import 'package:time_manager/data/repositories_impl/team_repository_impl.dart';
import 'package:time_manager/data/repositories_impl/user_repository_impl.dart';
import 'package:time_manager/data/services/auth_header_service.dart';
import 'package:time_manager/data/services/http_client.dart';
import 'package:time_manager/domain/repositories/account_repository.dart';
import 'package:time_manager/domain/repositories/schedule_repository.dart';
import 'package:time_manager/domain/repositories/team_repository.dart';
import 'package:time_manager/domain/repositories/user_repository.dart';
import 'package:time_manager/domain/usecases/account/login_user.dart';
import 'package:time_manager/domain/usecases/account/logout_user.dart';
import 'package:time_manager/domain/usecases/account/register_account.dart';
import 'package:time_manager/domain/usecases/schedule/get_clock_in.dart';
import 'package:time_manager/domain/usecases/schedule/get_clock_out.dart';
import 'package:time_manager/domain/usecases/schedule/get_clock_status.dart';
import 'package:time_manager/domain/usecases/team/add_member_to_team.dart';
import 'package:time_manager/domain/usecases/team/create_team.dart';
import 'package:time_manager/domain/usecases/team/get_team.dart';
import 'package:time_manager/domain/usecases/team/get_team_members.dart';
import 'package:time_manager/domain/usecases/team/get_teams.dart';
import 'package:time_manager/domain/usecases/team/remove_member_from_team.dart';
import 'package:time_manager/domain/usecases/user/create_user.dart';
import 'package:time_manager/domain/usecases/user/delete_user.dart';
import 'package:time_manager/domain/usecases/user/get_user.dart';
import 'package:time_manager/domain/usecases/user/get_user_profile.dart';
import 'package:time_manager/domain/usecases/user/get_users.dart';
import 'package:time_manager/domain/usecases/user/update_user_profile.dart';
import 'package:time_manager/presentation/cubits/account/auth_cubit.dart';
import 'package:time_manager/presentation/cubits/clock/clock_cubit.dart';
import 'package:time_manager/presentation/cubits/team/team_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';

import '../presentation/routes/app_router.dart';

final GetIt locator = GetIt.instance;

/// Dependency injection setup using GetIt.
Future<void> setupLocator() async {
  // ─────────────────────────────────────────────
  // CORE SERVICES
  // ─────────────────────────────────────────────
  locator.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(),
  );
  locator.registerLazySingleton<AuthHeaderService>(
    () => AuthHeaderService(locator()),
  );
  locator.registerLazySingleton<ApiClient>(
    () => ApiClient(authHeaderService: locator<AuthHeaderService>()),
  );

  // ─────────────────────────────────────────────
  // ACCOUNT FEATURE
  // ─────────────────────────────────────────────
  locator.registerLazySingleton<AccountApi>(
    () => AccountApi(locator<ApiClient>()),
  );
  locator.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      api: locator<AccountApi>(),
      storage: locator<LocalStorageService>(),
    ),
  );

  locator.registerFactory(() => LoginUser(locator<AccountRepository>()));
  locator.registerFactory(() => RegisterUser(locator<AccountRepository>()));
  locator.registerFactory(() => LogoutUser(locator<AccountRepository>()));

  locator.registerFactory(
    () => AuthCubit(
      loginUser: locator<LoginUser>(),
      registerUser: locator<RegisterUser>(),
      logoutUser: locator<LogoutUser>(),
    ),
  );

  // ─────────────────────────────────────────────
  // USER FEATURE
  // ─────────────────────────────────────────────
  locator.registerLazySingleton<UserApi>(() => UserApi(locator<ApiClient>()));
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      api: locator<UserApi>(),
      storage: locator<LocalStorageService>(),
    ),
  );

  locator.registerFactory(() => GetUserProfile(locator<UserRepository>()));
  locator.registerFactory(() => UpdateUserProfile(locator<UserRepository>()));
  locator.registerFactory(() => DeleteUser(locator<UserRepository>()));
  locator.registerFactory(() => CreateUser(locator<UserRepository>()));
  locator.registerFactory(() => GetUser(locator<UserRepository>()));
  locator.registerFactory(() => GetUsers(locator<UserRepository>()));

  locator.registerFactory(
    () => UserCubit(
      getUserProfile: locator<GetUserProfile>(),
      updateUserProfile: locator<UpdateUserProfile>(),
      deleteUser: locator<DeleteUser>(), 
      createUserUsecase: locator<CreateUser>(), 
      getUserUseCase: locator<GetUser>(), 
      getUsersUseCase: locator<GetUsers>(),
    ),
  );
  
  // CLOCK FEATURE
locator.registerLazySingleton(() => ClockApi(locator<ApiClient>()));
locator.registerLazySingleton<ClockRepository>(
    () => ClockRepositoryImpl(locator<ClockApi>()));

locator.registerFactory(() => ClockIn(locator<ClockRepository>()));
locator.registerFactory(() => ClockOut(locator<ClockRepository>()));
locator.registerFactory(() => GetClockStatus(locator<ClockRepository>()));

locator.registerFactory(() => ClockCubit(
      clockInUseCase: locator<ClockIn>(),
      clockOutUseCase: locator<ClockOut>(),
      getStatusUseCase: locator<GetClockStatus>(),
));

  // TEAM FEATURE 

  locator.registerLazySingleton<TeamApi>(() => TeamApi(locator<ApiClient>()));
  locator.registerLazySingleton<TeamRepository>(
    () => TeamRepositoryImpl(api: locator<TeamApi>(), storage: locator<LocalStorageService>()),
  );

  locator.registerFactory(() => CreateTeam(locator<TeamRepository>()));
  locator.registerFactory(() => GetTeams(locator<TeamRepository>()));
  locator.registerFactory(() => AddMemberToTeam(locator<TeamRepository>()));
  locator.registerFactory(() => RemoveMemberFromTeam(locator<TeamRepository>()));
  locator.registerFactory(() => GetTeamById(locator<TeamRepository>()));
  locator.registerFactory(() => GetTeamMembers(locator<TeamRepository>()));



  locator.registerFactory(() => TeamCubit(
    createTeamUseCase: locator<CreateTeam>(), 
    getTeamsUseCase: locator<GetTeams>(),
    addMemberToTeamUseCase: locator<AddMemberToTeam>(),
    removeMemberFromTeamUseCase: locator<RemoveMemberFromTeam>(),
    getTeamByIdUseCase: locator<GetTeamById>(),
    getTeamMembersUseCase : locator<GetTeamMembers>(),
    ));

  locator.registerLazySingleton(() => AppRouter());
}
