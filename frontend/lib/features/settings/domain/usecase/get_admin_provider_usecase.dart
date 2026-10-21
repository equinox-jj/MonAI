import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';

class GetAdminProviderUseCase implements UseCase<AdminPaymentProvider, String> {
  GetAdminProviderUseCase(this._repository);

  final AdminProviderRepository _repository;

  @override
  Future<Either<Failure, AdminPaymentProvider>> call(String id) =>
      _repository.getProvider(id);
}
