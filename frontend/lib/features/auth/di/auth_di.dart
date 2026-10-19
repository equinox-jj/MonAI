import 'package:monai/core/di/injector.dart';
import 'package:monai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:monai/features/auth/data/repository/auth_repository_impl.dart';
import 'package:monai/features/auth/domain/repository/auth_repository.dart';
import 'package:monai/features/auth/domain/usecase/complete_onboarding_usecase.dart';
import 'package:monai/features/auth/domain/usecase/is_onboarding_completed_usecase.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/bloc/onboarding_bloc.dart';

class AuthDI {
  AuthDI._();

  static Future<void> init() async {
    sl
      ..registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(preferences: sl()),
      )
      ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(local: sl()),
      )
      ..registerFactory(() => IsOnboardingCompletedUseCase(sl()))
      ..registerFactory(() => CompleteOnboardingUseCase(sl()))
      ..registerFactory(() => OnboardingBloc(sl()));
  }
}
