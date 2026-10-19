import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/error_mapper.dart';
import 'package:monai/core/error/exceptions.dart';

class _Repository with BaseRepository {}

void main() {
  final repository = _Repository();

  test('returns Right with the value on success', () async {
    final result = await repository.safeCall(() async => 42);

    expect(result, const Right<Failure, int>(42));
  });

  test('returns Left with the mapped failure on AppException', () async {
    final result = await repository.safeCall<int>(
      () async => throw const NotFoundException(code: 'not_found'),
    );

    expect(
      result,
      const Left<Failure, int>(Failure.notFound(code: 'not_found')),
    );
  });

  test('returns Left(UnknownFailure) on any other throw', () async {
    final result = await repository.safeCall<int>(
      () async => throw StateError('boom'),
    );

    expect(result.getLeft().toNullable(), isA<UnknownFailure>());
  });
}
