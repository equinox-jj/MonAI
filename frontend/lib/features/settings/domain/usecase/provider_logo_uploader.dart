import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';

class ProviderLogoUploader {
  ProviderLogoUploader(this._repository);

  final AdminProviderRepository _repository;

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
