import 'package:monai/core/di/injector.dart';
import 'package:monai/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:monai/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:monai/features/profile/data/repository/profile_repository_impl.dart';
import 'package:monai/features/profile/domain/repository/profile_repository.dart';
import 'package:monai/features/profile/domain/usecase/change_avatar_usecase.dart';
import 'package:monai/features/profile/domain/usecase/delete_account_usecase.dart';
import 'package:monai/features/profile/domain/usecase/remove_avatar_usecase.dart';
import 'package:monai/features/profile/domain/usecase/update_profile_name_usecase.dart';
import 'package:monai/features/profile/presentation/pages/edit_profile/bloc/edit_profile_bloc.dart';

class ProfileDI {
  ProfileDI._();

  static Future<void> init() async {
    sl
      ..registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<ProfileLocalDataSource>(
        () => ProfileLocalDataSourceImpl(dao: sl()),
      )
      ..registerLazySingleton<ProfileRepository>(
        () =>
            ProfileRepositoryImpl(remote: sl(), local: sl(), compressor: sl()),
      )
      ..registerFactory(() => UpdateProfileNameUseCase(sl()))
      ..registerFactory(() => ChangeAvatarUseCase(sl()))
      ..registerFactory(() => RemoveAvatarUseCase(sl()))
      ..registerFactory(
        () => DeleteAccountUseCase(repository: sl(), logout: sl()),
      )
      ..registerFactory(
        () => EditProfileBloc(
          watchUser: sl(),
          updateName: sl(),
          changeAvatar: sl(),
          removeAvatar: sl(),
          deleteAccount: sl(),
          photos: sl(),
        ),
      );
  }
}
