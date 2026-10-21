import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/exceptions.dart';
import 'package:monai/features/shared/data/datasources/endpoint/wallet_endpoint.dart';
import 'package:monai/features/shared/data/datasources/wallet_remote_datasource.dart';
import 'package:monai/features/shared/data/model/create_wallet_request.dart';
import 'package:monai/features/shared/data/model/update_wallet_request.dart';

import '../../../../helpers/api_fixtures.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late WalletRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = _MockDio();
    dataSource = WalletRemoteDataSourceImpl(dio: dio);
  });

  test(
    'getWallets asks for archived wallets too and reads the total',
    () async {
      // Arrange
      when(
        () => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => okResponse(
          WalletEndpoint.wallets,
          envelope([walletJson()], meta: {'total_balance': 100000}),
        ),
      );

      // Act
      final response = await dataSource.getWallets();

      // Assert
      verify(
        () => dio.get<Map<String, dynamic>>(
          WalletEndpoint.wallets,
          queryParameters: {'include_archived': true},
        ),
      ).called(1);
      expect(response.data?.single.id, 'w1');
      expect(response.meta?.totalBalance, 100000);
    },
  );

  test('createWallet leaves unset fields out of the body', () async {
    // Arrange
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer(
          (_) async => okResponse(
            WalletEndpoint.wallets,
            envelope(walletJson()),
            statusCode: 201,
          ),
        );

    // Act
    await dataSource.createWallet(
      const CreateWalletRequest(
        providerId: 'p1',
        initialBalance: 5000,
        isDefault: false,
      ),
    );

    // Assert
    final body = verify(
      () => dio.post<Map<String, dynamic>>(
        WalletEndpoint.wallets,
        data: captureAny(named: 'data'),
      ),
    ).captured.single;
    expect(body, {
      'provider_id': 'p1',
      'initial_balance': 5000,
      'is_default': false,
    });
  });

  test('updateWallet patches only the set fields', () async {
    // Arrange
    when(() => dio.patch<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer(
          (_) async =>
              okResponse(WalletEndpoint.wallet('w1'), envelope(walletJson())),
        );

    // Act
    await dataSource.updateWallet(
      'w1',
      const UpdateWalletRequest(isArchived: true),
    );

    // Assert
    final body = verify(
      () => dio.patch<Map<String, dynamic>>(
        '/wallets/w1',
        data: captureAny(named: 'data'),
      ),
    ).captured.single;
    expect(body, {'is_archived': true});
  });

  test('a 422 on delete keeps the backend code', () async {
    // Arrange
    when(
      () => dio.delete<Map<String, dynamic>>(any()),
    ).thenThrow(errorResponse('/wallets/w1', 422, 'wallet_has_transactions'));

    // Act
    final call = dataSource.deleteWallet('w1');

    // Assert
    await expectLater(
      call,
      throwsA(
        isA<ValidationException>().having(
          (e) => e.code,
          'code',
          'wallet_has_transactions',
        ),
      ),
    );
  });
}
