import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/repository/payment_provider_repository.dart';

/// Updates the cached catalog of banks and e-wallets when it has changed.
class RefreshPaymentProvidersUseCase
    implements UseCase<List<PaymentProvider>, NoParams> {
  RefreshPaymentProvidersUseCase(this._repository);

  final PaymentProviderRepository _repository;

  @override
  Future<Either<Failure, List<PaymentProvider>>> call(NoParams params) =>
      _repository.refreshProviders();
}
