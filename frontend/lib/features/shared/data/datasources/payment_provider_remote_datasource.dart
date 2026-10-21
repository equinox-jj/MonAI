import 'package:dio/dio.dart';
import 'package:monai/core/base/base_remote_data_source.dart';
import 'package:monai/features/shared/data/datasources/endpoint/payment_provider_endpoint.dart';
import 'package:monai/features/shared/data/model/payment_provider_catalog_response.dart';

/// A changed catalog and the ETag to send next time.
typedef PaymentProviderCatalogResult = ({
  PaymentProviderCatalogResponse body,
  String? etag,
});

abstract class PaymentProviderRemoteDataSource {
  /// `GET /payment-providers`, sending [etag] as `If-None-Match`. Null when
  /// the server answers 304: the cached catalog is current.
  Future<PaymentProviderCatalogResult?> getCatalog({String? etag});
}

class PaymentProviderRemoteDataSourceImpl
    extends PaymentProviderRemoteDataSource
    with BaseRemoteDataSource {
  PaymentProviderRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  static const _notModified = 304;

  @override
  Future<PaymentProviderCatalogResult?> getCatalog({String? etag}) =>
      safeApiCall(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          PaymentProviderEndpoint.catalog,
          options: Options(
            headers: {'If-None-Match': ?etag},
            validateStatus: (status) =>
                status != null &&
                ((status >= 200 && status < 300) || status == _notModified),
          ),
        );
        if (response.statusCode == _notModified) return null;
        return (
          body: PaymentProviderCatalogResponse.fromJson(
            response.data ?? const {},
          ),
          etag: response.headers.value('etag'),
        );
      });
}
