import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/repository/settings_repository.dart';

/// The picked theme.
class GetThemeModeUseCase implements UseCase<AppThemeMode, NoParams> {
  GetThemeModeUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, AppThemeMode>> call(NoParams params) =>
      _repository.themeMode();
}
