import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/repository/settings_repository.dart';

/// Remembers the picked theme.
class SetThemeModeUseCase implements UseCase<AppThemeMode, AppThemeMode> {
  SetThemeModeUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, AppThemeMode>> call(AppThemeMode params) =>
      _repository.setThemeMode(params);
}
