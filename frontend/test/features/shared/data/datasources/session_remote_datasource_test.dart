import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/features/shared/data/datasources/endpoint/session_endpoint.dart';
import 'package:monai/features/shared/data/datasources/session_remote_datasource.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  test('logoutAll posts with the session token', () async {
    // Arrange
    final dio = _MockDio();
    when(() => dio.post<Map<String, dynamic>>(any())).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: SessionEndpoint.logoutAll),
        statusCode: 200,
        data: const {'success': true, 'message': 'ok'},
      ),
    );

    // Act
    await SessionRemoteDataSourceImpl(dio: dio).logoutAll();

    // Assert
    verify(() => dio.post<Map<String, dynamic>>(SessionEndpoint.logoutAll))
        .called(1);
  });
}
