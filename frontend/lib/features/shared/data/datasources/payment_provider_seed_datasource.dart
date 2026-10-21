import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/data/database/monai_database.dart';
import 'package:monai/features/shared/data/mapper/payment_provider_mapper.dart';
import 'package:monai/features/shared/data/model/payment_provider_catalog_response.dart';

abstract class PaymentProviderSeedDataSource {
  /// For a first launch without network. Its ids start with [seedIdPrefix],
  /// since the server's ids are made on install.
  Future<List<PaymentProviderRow>> load();
}

const seedIdPrefix = 'seed:';

class PaymentProviderSeedDataSourceImpl extends PaymentProviderSeedDataSource
    with BaseLocalDataSource {
  PaymentProviderSeedDataSourceImpl({required this._bundle});

  final AssetBundle _bundle;
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
