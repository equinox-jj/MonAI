import 'package:monai/core/database/monai_database.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/model/create_wallet_request.dart';
import 'package:monai/features/shared/data/model/update_wallet_request.dart';
import 'package:monai/features/shared/data/model/wallet_response.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/shared/domain/entity/wallet_changes.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';

extension WalletDataMapper on WalletData {
  WalletRow toRow() => WalletRow(
    id: requireField(id),
    providerId: providerId,
    name: requireField(name),
    type: parseWalletType(type),
    logoUrl: logoUrl,
    initialBalance: requireField(initialBalance),
    currentBalance: requireField(currentBalance),
    icon: icon,
    color: color,
    isDefault: requireField(isDefault),
    isArchived: requireField(isArchived),
    createdAt: requireField(createdAt),
    updatedAt: requireField(updatedAt),
  );
}

extension WalletRowMapper on WalletRow {
  Wallet toEntity() => Wallet(
    id: id,
    providerId: providerId,
    name: name,
    type: type,
    logoUrl: logoUrl,
    initialBalance: initialBalance,
    currentBalance: currentBalance,
    icon: icon,
    color: color,
    isDefault: isDefault,
    isArchived: isArchived,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension WalletInputMapper on WalletInput {
  /// A blank name is left out so the server names a provider wallet.
  CreateWalletRequest toRequest() => CreateWalletRequest(
    name: name.isEmpty ? null : name,
    providerId: providerId,
    type: type?.apiValue,
    initialBalance: initialBalance,
    color: color,
    isDefault: isDefault,
  );
}

extension WalletChangesMapper on WalletChanges {
  UpdateWalletRequest toRequest() => UpdateWalletRequest(
    name: name,
    type: type?.apiValue,
    initialBalance: initialBalance,
    color: color,
    isDefault: isDefault,
    isArchived: isArchived,
  );
}
