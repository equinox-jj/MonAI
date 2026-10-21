import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/event/provider_change_events.dart';
import 'package:monai/features/settings/domain/repository/admin_provider_repository.dart';
import 'package:monai/features/settings/domain/usecase/provider_logo_uploader.dart';
import 'package:monai/features/settings/domain/validation/provider_input_validator.dart';

/// Saves the form over the original provider, sending only the fields that
/// changed, then a new status and a new logo when there is one. A logo that
/// fails after the rest saved is reported in [SavedProvider.logoFailure].
class UpdateProviderUseCase
    implements UseCase<SavedProvider, UpdateProviderParams> {
  UpdateProviderUseCase({
    required this._repository,
    required this._logoUploader,
    required this._events,
  });

  final AdminProviderRepository _repository;
  final ProviderLogoUploader _logoUploader;
  final ProviderChangeEvents _events;

  @override
  Future<Either<Failure, SavedProvider>> call(
    UpdateProviderParams params,
  ) async {
    final original = params.original;
    final input = ProviderInputValidator.normalized(params.input);
    final errors = ProviderInputValidator.validate(input);
    if (errors.isNotEmpty) return Left(Failure.validation(errors));

    final changes = ProviderChanges(
      name: input.name == original.name ? null : input.name,
      type: input.type == original.type ? null : input.type,
      aliases: _sameList(input.aliases, [...original.aliases]..sort())
          ? null
          : input.aliases,
      sortOrder: input.sortOrder == original.sortOrder ? null : input.sortOrder,
    );
    final statusChanged = input.isActive != original.isActive;
    final logoPath = params.logoPath;
    if (changes.isEmpty && !statusChanged && logoPath == null) {
      return Right(SavedProvider(provider: original));
    }

    var provider = original;
    if (!changes.isEmpty) {
      final updated = await _repository.updateProvider(original.id, changes);
      switch (updated) {
        case Left(value: final failure):
          return Left(failure);
        case Right(value: final saved):
          provider = saved;
      }
    }
    // From here on something saved, so the list reloads whatever fails
    // next.
    _events.emit(original.id);
    if (statusChanged) {
      final status = await _repository.setActive(
        original.id,
        active: input.isActive,
      );
      switch (status) {
        case Left(value: final failure):
          return Left(failure);
        case Right(value: final saved):
          provider = saved;
      }
    }
    if (logoPath == null) return Right(SavedProvider(provider: provider));
    final logo = await _logoUploader.upload(provider.id, logoPath);
    return Right(
      logo.match(
        (failure) => SavedProvider(provider: provider, logoFailure: failure),
        (withLogo) => SavedProvider(provider: withLogo),
      ),
    );
  }
}

class UpdateProviderParams {
  const UpdateProviderParams({
    required this.original,
    required this.input,
    this.logoPath,
  });

  /// The provider as last loaded or saved.
  final AdminPaymentProvider original;

  /// The form as filled in.
  final ProviderInput input;

  /// A newly picked logo to upload; null to keep the current one.
  final String? logoPath;
}

bool _sameList(List<String> a, List<String> b) =>
    a.length == b.length &&
    Iterable<int>.generate(a.length).every((i) => a[i] == b[i]);
