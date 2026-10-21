import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/event/provider_change_events.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';

class SetProviderActiveUseCase
    implements UseCase<AdminPaymentProvider, SetProviderActiveParams> {
  SetProviderActiveUseCase({required this._repository, required this._events});

  final AdminProviderRepository _repository;
  final ProviderChangeEvents _events;

  @override
  Future<Either<Failure, AdminPaymentProvider>> call(
    SetProviderActiveParams params,
  ) async {
    final result = await _repository.setActive(
      params.id,
      active: params.active,
    );
    if (result.isRight()) _events.emit(params.id);
    return result;
  }
}

class SetProviderActiveParams {
  const SetProviderActiveParams({required this.id, required this.active});

  final String id;
  final bool active;
}
