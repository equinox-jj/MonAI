import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/wallet_type.dart';

part 'admin_payment_provider.freezed.dart';

@freezed
abstract class AdminPaymentProvider with _$AdminPaymentProvider {
  const factory AdminPaymentProvider({
    required String id,
    required String slug,
    required String name,
    required WalletType type,

    /// Lowercase words quick add matches, e.g. `gpay` for GoPay.
    required List<String> aliases,
    required int sortOrder,
    required bool isActive,

    /// Cash and the like: can't be deactivated, deleted or renamed to
    /// another slug.
    required bool isSystem,
    required DateTime updatedAt,
    String? logoUrl,
  }) = _AdminPaymentProvider;
}

@freezed
abstract class ProviderInput with _$ProviderInput {
  const factory ProviderInput({
    required String name,
    required WalletType type,
    required List<String> aliases,
    required int sortOrder,
    required bool isActive,
  }) = _ProviderInput;
}

/// Only the non-null fields change; [aliases] replaces the list.
@freezed
abstract class ProviderChanges with _$ProviderChanges {
  const factory ProviderChanges({
    String? name,
    WalletType? type,
    List<String>? aliases,
    int? sortOrder,
  }) = _ProviderChanges;

  const ProviderChanges._();

  bool get isEmpty =>
      name == null && type == null && aliases == null && sortOrder == null;
}

/// [logoFailure] is set when the provider was saved but its new logo wasn't.
@freezed
abstract class SavedProvider with _$SavedProvider {
  const factory SavedProvider({
    required AdminPaymentProvider provider,
    Failure? logoFailure,
  }) = _SavedProvider;
}
