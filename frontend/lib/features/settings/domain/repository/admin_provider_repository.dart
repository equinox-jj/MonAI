import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';

/// The provider catalog's admin endpoints. Network only: admins edit rarely
/// and must see the server's current list. Users get the changes through the
/// catalog's ETag on their next refresh. Every call needs a
/// `payment_provider.*` permission; without it the API answers 403.
abstract class AdminProviderRepository {
  /// Every provider, inactive ones included, by sort order then name.
  Future<Either<Failure, List<AdminPaymentProvider>>> listProviders();

  Future<Either<Failure, AdminPaymentProvider>> getProvider(String id);

  /// Created active; the server makes the slug from the name.
  Future<Either<Failure, AdminPaymentProvider>> createProvider(
    ProviderInput input,
  );

  Future<Either<Failure, AdminPaymentProvider>> updateProvider(
    String id,
    ProviderChanges changes,
  );

  Future<Either<Failure, AdminPaymentProvider>> setActive(
    String id, {
    required bool active,
  });

  /// Removes the provider and frees its aliases.
  Future<Either<Failure, Unit>> deleteProvider(String id);

  /// The picked image at [path] shrunk to a logo the API accepts.
  Future<Either<Failure, Uint8List>> compressLogo(String path);

  /// Makes [bytes] provider [id]'s logo.
  Future<Either<Failure, AdminPaymentProvider>> uploadLogo(
    String id,
    Uint8List bytes,
  );
}
