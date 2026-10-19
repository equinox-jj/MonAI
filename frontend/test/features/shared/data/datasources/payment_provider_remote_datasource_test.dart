import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/features/shared/data/datasources/endpoint/payment_provider_endpoint.dart';
import 'package:monai/features/shared/data/datasources/payment_provider_remote_datasource.dart';

import '../../../../helpers/api_fixtures.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late PaymentProviderRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = _MockDio();
    dataSource = PaymentProviderRemoteDataSourceImpl(dio: dio);
  });

  void stubGet(Response<Map<String, dynamic>> response) => when(
    () => dio.get<Map<String, dynamic>>(any(), options: any(named: 'options')),
  ).thenAnswer((_) async => response);

  Options capturedOptions() =>
      verify(
            () => dio.get<Map<String, dynamic>>(
              PaymentProviderEndpoint.catalog,
              options: captureAny(named: 'options'),
            ),
          ).captured.single
          as Options;

  test('sends the ETag and reads the new catalog with its ETag', () async {
    // Arrange
    stubGet(
      okResponse(
        PaymentProviderEndpoint.catalog,
        envelope({
          'version': 3,
          'providers': [providerJson()],
        }),
        headers: {
          'etag': ['"v3"'],
        },
      ),
    );

    // Act
    final result = await dataSource.getCatalog(etag: '"v2"');

    // Assert
    final options = capturedOptions();
    expect(options.headers, {'If-None-Match': '"v2"'});
    expect(options.validateStatus?.call(304), isTrue);
    expect(options.validateStatus?.call(500), isFalse);
    expect(result?.etag, '"v3"');
    expect(result?.body.data?.version, 3);
    expect(result?.body.data?.providers?.single.name, 'BCA');
  });

  test('sends no If-None-Match without an ETag', () async {
    // Arrange
    stubGet(
      okResponse(
        PaymentProviderEndpoint.catalog,
        envelope({'version': 1, 'providers': <Object>[]}),
      ),
    );

    // Act
    await dataSource.getCatalog();

    // Assert
    expect(capturedOptions().headers, isEmpty);
  });

  test('a 304 means the cached catalog is current', () async {
    // Arrange
    stubGet(okResponse(PaymentProviderEndpoint.catalog, null, statusCode: 304));

    // Act
    final result = await dataSource.getCatalog(etag: '"v3"');

    // Assert
    expect(result, isNull);
  });
}
