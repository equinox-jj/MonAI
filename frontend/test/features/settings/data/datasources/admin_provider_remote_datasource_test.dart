import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/error/exceptions.dart';
import 'package:monai/features/settings/data/datasources/admin_provider_remote_datasource.dart';
import 'package:monai/features/settings/data/datasources/endpoint/admin_provider_endpoint.dart';
import 'package:monai/features/settings/data/model/create_provider_request.dart';
import 'package:monai/features/settings/data/model/provider_status_request.dart';
import 'package:monai/features/settings/data/model/update_provider_request.dart';

import '../../../../helpers/api_fixtures.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late AdminProviderRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = _MockDio();
    dataSource = AdminProviderRemoteDataSourceImpl(dio: dio);
  });

  test('lists a page of every status', () async {
    // Arrange
    when(
      () => dio.get<Map<String, dynamic>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => okResponse(
        AdminProviderEndpoint.providers,
        envelope(
          [adminProviderJson()],
          meta: {'page': 2, 'per_page': 100, 'total': 101, 'total_pages': 2},
        ),
      ),
    );

    // Act
    final response = await dataSource.listProviders(page: 2, perPage: 100);

    // Assert
    final call = verify(
      () => dio.get<Map<String, dynamic>>(
        AdminProviderEndpoint.providers,
        queryParameters: captureAny(named: 'queryParameters'),
      ),
    )..called(1);
    expect(call.captured.single, {'page': 2, 'per_page': 100, 'status': 'ALL'});
    expect(response.data?.single.name, 'GoPay');
    expect(response.meta?.totalPages, 2);
  });

  test('gets one provider by id', () async {
    // Arrange
    when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
      (_) async => okResponse(
        AdminProviderEndpoint.provider('p1'),
        envelope(adminProviderJson()),
      ),
    );

    // Act
    final response = await dataSource.getProvider('p1');

    // Assert
    verify(() => dio.get<Map<String, dynamic>>('/admin/payment-providers/p1'))
        .called(1);
    expect(response.data?.isActive, isTrue);
    expect(response.data?.updatedAt, DateTime.parse(timestampJson));
  });

  test('creates a provider with the form as the body', () async {
    // Arrange
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer(
          (_) async => okResponse(
            AdminProviderEndpoint.providers,
            envelope(adminProviderJson()),
            statusCode: 201,
          ),
        );

    // Act
    await dataSource.createProvider(
      const CreateProviderRequest(
        name: 'GoPay',
        type: 'E_WALLET',
        aliases: ['gopay'],
        sortOrder: 50,
      ),
    );

    // Assert
    final call = verify(
      () => dio.post<Map<String, dynamic>>(
        AdminProviderEndpoint.providers,
        data: captureAny(named: 'data'),
      ),
    )..called(1);
    expect(call.captured.single, {
      'name': 'GoPay',
      'type': 'E_WALLET',
      'aliases': ['gopay'],
      'sort_order': 50,
    });
  });

  test('an update sends only the changed fields', () async {
    // Arrange
    when(() => dio.patch<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer(
          (_) async => okResponse(
            AdminProviderEndpoint.provider('p1'),
            envelope(adminProviderJson()),
          ),
        );

    // Act
    await dataSource.updateProvider(
      'p1',
      const UpdateProviderRequest(sortOrder: 70),
    );

    // Assert
    final call = verify(
      () => dio.patch<Map<String, dynamic>>(
        '/admin/payment-providers/p1',
        data: captureAny(named: 'data'),
      ),
    )..called(1);
    expect(call.captured.single, {'sort_order': 70});
  });

  test('sets the status on its own path', () async {
    // Arrange
    when(() => dio.patch<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer(
          (_) async => okResponse(
            AdminProviderEndpoint.status('p1'),
            envelope(adminProviderJson(isActive: false)),
          ),
        );

    // Act
    final response = await dataSource.setStatus(
      'p1',
      const ProviderStatusRequest(isActive: false),
    );

    // Assert
    final call = verify(
      () => dio.patch<Map<String, dynamic>>(
        '/admin/payment-providers/p1/status',
        data: captureAny(named: 'data'),
      ),
    )..called(1);
    expect(call.captured.single, {'is_active': false});
    expect(response.data?.isActive, isFalse);
  });

  test('deletes by id', () async {
    // Arrange
    when(() => dio.delete<void>(any())).thenAnswer(
      (_) async => Response<void>(
        requestOptions: RequestOptions(path: 'p1'),
        statusCode: 204,
      ),
    );

    // Act
    await dataSource.deleteProvider('p1');

    // Assert
    verify(() => dio.delete<void>('/admin/payment-providers/p1')).called(1);
  });

  test('uploads the logo as a multipart file', () async {
    // Arrange
    when(() => dio.put<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer(
          (_) async => okResponse(
            AdminProviderEndpoint.logo('p1'),
            envelope(adminProviderJson()),
          ),
        );

    // Act
    await dataSource.uploadLogo(
      'p1',
      Uint8List.fromList([1, 2, 3]),
      filename: 'logo.webp',
    );

    // Assert
    final call = verify(
      () => dio.put<Map<String, dynamic>>(
        '/admin/payment-providers/p1/logo',
        data: captureAny(named: 'data'),
      ),
    )..called(1);
    final form = call.captured.single as FormData;
    expect(form.files.single.key, 'file');
    expect(form.files.single.value.filename, 'logo.webp');
  });

  test('a conflict becomes a typed exception', () async {
    // Arrange
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenThrow(
          errorResponse(AdminProviderEndpoint.providers, 409, 'conflict'),
        );

    // Act
    final call = dataSource.createProvider(
      const CreateProviderRequest(
        name: 'GoPay',
        type: 'E_WALLET',
        aliases: [],
        sortOrder: 50,
      ),
    );

    // Assert
    await expectLater(call, throwsA(isA<ConflictException>()));
  });
}
