import 'dart:async';

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

  group('safeStream', () {
    test('wraps each value in Right', () async {
      // Arrange
      final source = Stream.fromIterable([1, 2]);

      // Act
      final events = await repository.safeStream(() => source).toList();

      // Assert
      expect(events, const [Right<Failure, int>(1), Right<Failure, int>(2)]);
    });

    test('turns an error into a Left and keeps going', () async {
      // Arrange
      final controller = StreamController<int>();

      // Act
      final events = repository.safeStream(() => controller.stream).toList();
      controller
        ..add(1)
        ..addError(const CacheException(message: 'boom'))
        ..add(2);
      await controller.close();

      // Assert
      expect(await events, [
        const Right<Failure, int>(1),
        const Left<Failure, int>(Failure.cache(message: 'boom')),
        const Right<Failure, int>(2),
      ]);
    });

    test('turns a throw while opening the stream into a Left', () async {
      // Arrange
      Stream<int> open() => throw StateError('boom');

      // Act
      final events = await repository.safeStream(open).toList();

      // Assert
      expect(events.single.getLeft().toNullable(), isA<UnknownFailure>());
    });
  });
}
