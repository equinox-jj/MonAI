import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/error/error_mapper.dart';
import 'package:monai/core/error/exceptions.dart';

DioException _badResponse(
  int status, [
  Object? body,
  Map<String, List<String>> headers = const {},
]) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: status,
      data: body,
      headers: Headers.fromMap(headers),
    ),
  );
}

Map<String, dynamic> _errorBody(String code, String message, [List? fields]) =>
    {
      'success': false,
      'message': message,
      'data': null,
      'error': {'code': code, 'fields': ?fields},
    };

void main() {
  group('mapDioException', () {
    test('maps timeouts to TimeoutException', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final e = DioException(requestOptions: RequestOptions(), type: type);
        expect(mapDioException(e), isA<TimeoutException>());
      }
    });

    test('maps connection errors to NetworkException', () {
      final e = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      );
      expect(mapDioException(e), isA<NetworkException>());
    });

    test('maps cancel to RequestCancelledException', () {
      final e = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.cancel,
      );
      expect(mapDioException(e), isA<RequestCancelledException>());
    });

    test('maps each status and keeps backend message and code', () {
      final cases = <int, (String, Matcher)>{
        400: ('invalid_request', isA<BadRequestException>()),
        401: ('invalid_credentials', isA<UnauthorizedException>()),
        403: ('forbidden', isA<ForbiddenException>()),
        404: ('not_found', isA<NotFoundException>()),
        409: ('wallet_has_transactions', isA<ConflictException>()),
        429: ('rate_limited', isA<TooManyRequestsException>()),
        503: ('ai_unavailable', isA<ServiceUnavailableException>()),
        500: ('internal_error', isA<ServerException>()),
      };
      cases.forEach((status, expected) {
        final (code, matcher) = expected;
        final result = mapDioException(
          _badResponse(status, _errorBody(code, 'msg $status')),
        );
        expect(result, matcher, reason: 'status $status');
        expect(result.code, code, reason: 'status $status');
        expect(result.message, 'msg $status', reason: 'status $status');
      });
    });

    test('falls back to default message when body has none', () {
      final result = mapDioException(_badResponse(404));
      expect(result, isA<NotFoundException>());
      expect(result.message, 'Not found');
      expect(result.code, isNull);
    });

    test('maps 422 with parsed field errors', () {
      final result = mapDioException(
        _badResponse(
          422,
          _errorBody('validation_failed', 'Some fields are invalid', [
            {
              'field': 'password',
              'code': 'min',
              'message': 'must be at least 8 characters',
              'params': {'min': 8},
            },
            {'field': 'email', 'code': 'email', 'message': 'invalid email'},
          ]),
        ),
      );

      expect(result, isA<ValidationException>());
      final fields = (result as ValidationException).fieldErrors;
      expect(fields, hasLength(2));
      expect(fields.firstForField('password')?.code, 'min');
      expect(fields.firstForField('password')?.params, {'min': 8});
      expect(fields.forField('email').single.params, isEmpty);
      expect(fields.firstForField('name'), isNull);
    });
  });

  group('Retry-After', () {
    test('429 carries Retry-After seconds through to the failure', () {
      // Arrange
      final error = _badResponse(429, _errorBody('rate_limited', 'slow'), {
        'retry-after': ['90'],
      });

      // Act
      final failure = mapExceptionToFailure(mapDioException(error));

      // Assert
      expect(
        failure,
        isA<TooManyRequestsFailure>().having(
          (f) => f.retryAfter,
          'retryAfter',
          const Duration(seconds: 90),
        ),
      );
    });

    test('429 without a usable Retry-After has no wait', () {
      // Arrange
      final missing = _badResponse(429);
      final invalid = _badResponse(429, null, {
        'retry-after': ['Wed, 21 Oct 2026 07:28:00 GMT'],
      });

      // Act
      final fromMissing = mapDioException(missing);
      final fromInvalid = mapDioException(invalid);

      // Assert
      expect((fromMissing as TooManyRequestsException).retryAfter, isNull);
      expect((fromInvalid as TooManyRequestsException).retryAfter, isNull);
    });
  });

  group('parseFieldErrors', () {
    test('returns empty for bodies without fields', () {
      expect(parseFieldErrors(null), isEmpty);
      expect(
        parseFieldErrors({
          'error': {'code': 'x'},
        }),
        isEmpty,
      );
      expect(parseFieldErrors('oops'), isEmpty);
    });
  });

  group('mapExceptionToFailure', () {
    test('carries message and code into the failure', () {
      final failure = mapExceptionToFailure(
        const ConflictException(
          message: 'Wallet name already exists',
          code: 'conflict',
        ),
      );
      expect(failure, isA<ConflictFailure>());
      expect(failure.message, 'Wallet name already exists');
      expect(failure.code, 'conflict');
    });

    test('keeps validation field errors and server status', () {
      const field = FieldError(field: 'name', code: 'required', message: 'm');
      final validation = mapExceptionToFailure(
        const ValidationException([field]),
      );
      expect(validation, const Failure.validation([field]));

      final server = mapExceptionToFailure(const ServerException(502));
      expect(server, isA<ServerFailure>());
      expect((server as ServerFailure).statusCode, 502);
    });

    test('maps cache and unknown errors', () {
      expect(
        mapExceptionToFailure(const CacheException()),
        isA<CacheFailure>(),
      );
      final unknown = mapExceptionToFailure(StateError('boom'));
      expect(unknown, isA<UnknownFailure>());
      expect(unknown.message, contains('boom'));
    });
  });
}
