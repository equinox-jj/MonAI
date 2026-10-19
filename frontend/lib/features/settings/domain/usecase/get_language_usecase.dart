import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/settings/domain/repository/settings_repository.dart';

/// The picked app language.
class GetLanguageUseCase implements UseCase<AppLanguage, NoParams> {
  GetLanguageUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, AppLanguage>> call(NoParams params) =>
      _repository.language();
}
