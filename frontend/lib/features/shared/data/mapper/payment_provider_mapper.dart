import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/features/shared/data/datasources/payment_provider_seed_datasource.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/model/payment_provider_catalog_response.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';

extension PaymentProviderDataMapper on PaymentProviderData {
  PaymentProviderRow toRow() => PaymentProviderRow(
    id: requireField(id),
    slug: requireField(slug),
    name: requireField(name),
    type: parseWalletType(type),
    logoUrl: logoUrl,
    aliases: aliases ?? const [],
    sortOrder: sortOrder ?? 0,
  );
}

extension PaymentProviderRowMapper on PaymentProviderRow {
  PaymentProvider toEntity() => PaymentProvider(
    id: id,
    slug: slug,
    name: name,
    type: type,
    logoUrl: logoUrl,
    aliases: aliases,
    sortOrder: sortOrder,
    isBundled: id.startsWith(seedIdPrefix),
  );
}
