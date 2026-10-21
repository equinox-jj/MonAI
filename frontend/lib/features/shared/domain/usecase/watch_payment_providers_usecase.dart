import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/repository/payment_provider_repository.dart';

class WatchPaymentProvidersUseCase
    implements StreamUseCase<List<PaymentProvider>, NoParams> {
  WatchPaymentProvidersUseCase(this._repository);

  final PaymentProviderRepository _repository;

  @override
  Stream<Either<Failure, List<PaymentProvider>>> call(NoParams params) =>
      _repository.watchProviders();
}
