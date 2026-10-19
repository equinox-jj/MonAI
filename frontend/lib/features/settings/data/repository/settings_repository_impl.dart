import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:monai/features/settings/domain/repository/settings_repository.dart';

class SettingsRepositoryImpl extends SettingsRepository with BaseRepository {
  SettingsRepositoryImpl({required this._local});

  final SettingsLocalDataSource _local;

  @override
  Future<Either<Failure, AppThemeMode>> themeMode() =>
      safeCall(_local.themeMode);

  @override
  Future<Either<Failure, AppThemeMode>> setThemeMode(AppThemeMode mode) =>
      safeCall(() async {
        await _local.setThemeMode(mode);
        return mode;
      });

  @override
  Future<Either<Failure, AppLanguage>> language() => safeCall(_local.language);

  @override
  Future<Either<Failure, AppLanguage>> setLanguage(AppLanguage language) =>
      safeCall(() async {
        await _local.setLanguage(language);
        return language;
      });
}
