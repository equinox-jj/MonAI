import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';

abstract class PaymentProviderRepository {
  Stream<Either<Failure, List<PaymentProvider>>> watchProviders();

  Future<Either<Failure, List<PaymentProvider>>> refreshProviders();
}
