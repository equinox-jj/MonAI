// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider_dao.dart';

// ignore_for_file: type=lint
mixin _$PaymentProviderDaoMixin on DatabaseAccessor<MonAIDatabase> {
  $PaymentProvidersTable get paymentProviders =>
      attachedDatabase.paymentProviders;
  $PaymentProviderCatalogTable get paymentProviderCatalog =>
      attachedDatabase.paymentProviderCatalog;
  PaymentProviderDaoManager get managers => PaymentProviderDaoManager(this);
}

class PaymentProviderDaoManager {
  final _$PaymentProviderDaoMixin _db;
  PaymentProviderDaoManager(this._db);
  $$PaymentProvidersTableTableManager get paymentProviders =>
      $$PaymentProvidersTableTableManager(
        _db.attachedDatabase,
        _db.paymentProviders,
      );
  $$PaymentProviderCatalogTableTableManager get paymentProviderCatalog =>
      $$PaymentProviderCatalogTableTableManager(
        _db.attachedDatabase,
        _db.paymentProviderCatalog,
      );
}
