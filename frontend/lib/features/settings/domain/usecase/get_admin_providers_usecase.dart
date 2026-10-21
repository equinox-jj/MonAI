import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';

/// Every provider in the catalog, inactive ones included, by sort order.
class GetAdminProvidersUseCase
    implements UseCase<List<AdminPaymentProvider>, NoParams> {
  GetAdminProvidersUseCase(this._repository);

  final AdminProviderRepository _repository;

  @override
  Future<Either<Failure, List<AdminPaymentProvider>>> call(NoParams params) =>
      _repository.listProviders();
}
