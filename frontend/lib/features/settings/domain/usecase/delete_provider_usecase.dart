import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/event/provider_change_events.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';

/// Removes a provider and frees its aliases; existing wallets keep their own
/// name and type.
class DeleteProviderUseCase implements UseCase<Unit, String> {
  DeleteProviderUseCase({required this._repository, required this._events});

  final AdminProviderRepository _repository;
  final ProviderChangeEvents _events;

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    final result = await _repository.deleteProvider(id);
    if (result.isRight()) _events.emit(id);
    return result;
  }
}
