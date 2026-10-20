import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/wallet_type.dart';

part 'payment_provider.freezed.dart';

/// A bank or e-wallet from the server's catalog that a wallet can link to.
@freezed
abstract class PaymentProvider with _$PaymentProvider {
  const factory PaymentProvider({
    required String id,
    required String slug,
    required String name,
    required WalletType type,

    /// Other names the provider is known by, for quick add.
    required List<String> aliases,
    required int sortOrder,
    String? logoUrl,

    /// From the catalog bundled with the app, not yet replaced by the
    /// server's: its [id] isn't one the server knows.
    @Default(false) bool isBundled,
  }) = _PaymentProvider;
}
