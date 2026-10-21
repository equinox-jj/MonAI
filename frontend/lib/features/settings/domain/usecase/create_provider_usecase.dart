import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/event/provider_change_events.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';
import 'package:monai/features/settings/domain/usecase/provider_logo_uploader.dart';
import 'package:monai/features/settings/domain/validation/provider_input_validator.dart';

/// Creates a provider, deactivates it when the form says so (the API creates
/// them active) and then uploads the logo. Invalid input fails as a
/// [ValidationFailure] without calling the server. Once created, a failed
/// status or logo step doesn't fail the whole: the logo's comes back in
/// [SavedProvider.logoFailure], and a provider that stayed active can be
/// switched off from the form.
class CreateProviderUseCase
    implements UseCase<SavedProvider, CreateProviderParams> {
  CreateProviderUseCase({
    required this._repository,
    required this._logoUploader,
    required this._events,
  });

  final AdminProviderRepository _repository;
  final ProviderLogoUploader _logoUploader;
  final ProviderChangeEvents _events;

  @override
  Future<Either<Failure, SavedProvider>> call(
    CreateProviderParams params,
  ) async {
    final input = ProviderInputValidator.normalized(params.input);
    final errors = ProviderInputValidator.validate(input);
    if (errors.isNotEmpty) return Left(Failure.validation(errors));

    AdminPaymentProvider provider;
    switch (await _repository.createProvider(input)) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final created):
        provider = created;
    }

    if (!input.isActive) {
      final deactivated = await _repository.setActive(
        provider.id,
        active: false,
      );
      if (deactivated case Right(value: final updated)) provider = updated;
    }

    var saved = SavedProvider(provider: provider);
    if (params.logoPath case final logoPath?) {
      final logo = await _logoUploader.upload(provider.id, logoPath);
      saved = logo.match(
        (failure) => SavedProvider(provider: provider, logoFailure: failure),
        (withLogo) => SavedProvider(provider: withLogo),
      );
    }
    _events.emit(provider.id);
    return Right(saved);
  }
}

class CreateProviderParams {
  const CreateProviderParams({required this.input, this.logoPath});

  /// The form as filled in.
  final ProviderInput input;

  /// A picked logo to upload; null for none.
  final String? logoPath;
}
