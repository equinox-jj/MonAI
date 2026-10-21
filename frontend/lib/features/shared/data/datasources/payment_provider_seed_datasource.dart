import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/features/shared/data/mapper/payment_provider_mapper.dart';
import 'package:monai/features/shared/data/model/payment_provider_catalog_response.dart';

abstract class PaymentProviderSeedDataSource {
  /// The catalog bundled with the app, for a first launch without network.
  /// Its ids start with [seedIdPrefix]: the server's are made on install.
  Future<List<PaymentProviderRow>> load();
}

/// The prefix of a bundled provider's id, which the server doesn't know.
const seedIdPrefix = 'seed:';

class PaymentProviderSeedDataSourceImpl extends PaymentProviderSeedDataSource
    with BaseLocalDataSource {
  PaymentProviderSeedDataSourceImpl({required this._bundle});

  final AssetBundle _bundle;

  /// The bundled catalog, in the `GET /payment-providers` shape.
  static const assetPath = 'assets/seed/payment_providers.json';

  @override
  Future<List<PaymentProviderRow>> load() => safeCacheCall(() async {
    final json = jsonDecode(await _bundle.loadString(assetPath));
    final catalog = PaymentProviderCatalogResponse.fromJson(
      json as Map<String, dynamic>,
    ).data;
    return (catalog?.providers ?? const [])
        .map((data) => data.toRow())
        .toList();
  });
}
