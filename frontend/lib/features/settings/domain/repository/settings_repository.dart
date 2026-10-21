import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppThemeMode>> themeMode();

  Future<Either<Failure, AppThemeMode>> setThemeMode(AppThemeMode mode);

  Future<Either<Failure, AppLanguage>> language();

  Future<Either<Failure, AppLanguage>> setLanguage(AppLanguage language);

  Future<Either<Failure, String>> appVersion();
}
