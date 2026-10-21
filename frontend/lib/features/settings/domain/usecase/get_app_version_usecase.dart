import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/repository/settings_repository.dart';

class GetAppVersionUseCase implements UseCase<String, NoParams> {
  GetAppVersionUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, String>> call(NoParams params) =>
      _repository.appVersion();
}
