import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';

/// The provider with the given id, as admins see it.
class GetAdminProviderUseCase implements UseCase<AdminPaymentProvider, String> {
  GetAdminProviderUseCase(this._repository);

  final AdminProviderRepository _repository;

  @override
  Future<Either<Failure, AdminPaymentProvider>> call(String id) =>
      _repository.getProvider(id);
}
