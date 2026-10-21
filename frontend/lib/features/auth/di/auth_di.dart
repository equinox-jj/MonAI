import 'package:monai/core/app/injector.dart';
import 'package:monai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:monai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:monai/features/auth/data/repository/auth_repository_impl.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/usecase/change_password_usecase.dart';
import 'package:monai/features/auth/domain/usecase/complete_onboarding_usecase.dart';
import 'package:monai/features/auth/domain/usecase/is_onboarding_completed_usecase.dart';
import 'package:monai/features/auth/domain/usecase/login_usecase.dart';
import 'package:monai/features/auth/domain/usecase/register_usecase.dart';
import 'package:monai/features/auth/domain/usecase/restore_session_usecase.dart';
import 'package:monai/features/auth/presentation/pages/change_password/bloc/change_password_bloc.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_bloc.dart';
import 'package:monai/features/auth/presentation/pages/register/bloc/register_bloc.dart';
import 'package:monai/features/auth/presentation/pages/session_expired/cubit/session_expired_cubit.dart';
import 'package:monai/features/auth/presentation/pages/sign_in/bloc/sign_in_bloc.dart';

class AuthDI {
  AuthDI._();

  static Future<void> init() async {
    sl
      ..registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(
          preferences: sl(),
          tokenStorage: sl(),
          localCache: sl(),
          sessionManager: sl(),
        ),
      )
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          remote: sl(),
          local: sl(),
          users: sl(),
          session: sl(),
        ),
      )
      ..registerFactory(() => IsOnboardingCompletedUseCase(sl()))
      ..registerFactory(() => CompleteOnboardingUseCase(sl()))
      ..registerFactory(() => LoginUseCase(sl()))
      ..registerFactory(() => RegisterUseCase(sl()))
      ..registerFactory(() => ChangePasswordUseCase(sl()))
      ..registerFactory(() => RestoreSessionUseCase(sl()))
      ..registerFactory(() => OnboardingBloc(sl()))
      ..registerFactory(() => SignInBloc(sl()))
      ..registerFactory(() => RegisterBloc(sl()))
      ..registerFactory(() => ChangePasswordBloc(sl()))
      ..registerFactory(() => SessionExpiredCubit(sl()));
  }
}
