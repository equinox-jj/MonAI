import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/wallet_type.dart';

part 'wallet_changes.freezed.dart';

/// Null leaves a field as it is.
@freezed
abstract class WalletChanges with _$WalletChanges {
  const factory WalletChanges({
    String? name,
    WalletType? type,
    int? initialBalance,
    String? color,
    bool? isDefault,
    bool? isArchived,
  }) = _WalletChanges;

  const WalletChanges._();

  bool get isEmpty =>
      name == null &&
      type == null &&
      initialBalance == null &&
      color == null &&
      isDefault == null &&
      isArchived == null;
}
