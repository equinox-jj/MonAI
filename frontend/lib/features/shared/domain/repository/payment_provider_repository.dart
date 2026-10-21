import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';

/// The catalog of banks and e-wallets wallets can link to.
abstract class PaymentProviderRepository {
  /// The cached catalog in the server's order.
  Stream<Either<Failure, List<PaymentProvider>>> watchProviders();

  /// Updates the cached catalog when the server's has changed, and gives
  /// the catalog now cached.
  Future<Either<Failure, List<PaymentProvider>>> refreshProviders();
}
