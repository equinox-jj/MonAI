import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/repository/settings_repository.dart';

/// Remembers the picked app language.
class SetLanguageUseCase implements UseCase<AppLanguage, AppLanguage> {
  SetLanguageUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, AppLanguage>> call(AppLanguage params) =>
      _repository.setLanguage(params);
}
