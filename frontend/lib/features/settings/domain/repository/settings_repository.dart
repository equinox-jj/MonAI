import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';

/// App settings kept on this device; they survive sign out.
abstract class SettingsRepository {
  /// The picked theme.
  Future<Either<Failure, AppThemeMode>> themeMode();

  /// Remembers the picked theme and gives it back.
  Future<Either<Failure, AppThemeMode>> setThemeMode(AppThemeMode mode);

  /// The picked language.
  Future<Either<Failure, AppLanguage>> language();

  /// Remembers the picked language and gives it back.
  Future<Either<Failure, AppLanguage>> setLanguage(AppLanguage language);
}
