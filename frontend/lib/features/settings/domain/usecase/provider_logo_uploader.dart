import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';

/// Shrinks the picked logo to a WebP within the API's 512 KB and uploads it.
/// Shared by the create and update use cases, which both end with an
/// optional new logo.
class ProviderLogoUploader {
  ProviderLogoUploader(this._repository);

  final AdminProviderRepository _repository;

  /// Makes the image at [logoPath] provider [providerId]'s logo.
  Future<Either<Failure, AdminPaymentProvider>> upload(
    String providerId,
    String logoPath,
  ) async {
    final compressed = await _repository.compressLogo(logoPath);
    return switch (compressed) {
      Left(value: final failure) => Left(failure),
      Right(value: final bytes) => _repository.uploadLogo(providerId, bytes),
    };
  }
}
