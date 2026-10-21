import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/wallet_type.dart';

part 'wallet_input.freezed.dart';

/// With a [providerId], the server fills a blank [name] and a null [type] from
/// the provider.
@freezed
abstract class WalletInput with _$WalletInput {
  const factory WalletInput({
    required String name,
    String? providerId,
    WalletType? type,
    @Default(0) int initialBalance,

    /// `#RRGGBB`.
    String? color,
    @Default(false) bool isDefault,
  }) = _WalletInput;
}
