import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:monai/core/base/base_local_data_source.dart';
import 'package:monai/core/base/error/exceptions.dart';

class _DataSource with BaseLocalDataSource {}

void main() {
  final dataSource = _DataSource();

  group('safeCacheCall', () {
    test('returns the value on success', () async {
      // Arrange
      Future<int> op() async => 42;

      // Act
      final result = await dataSource.safeCacheCall(op);

      // Assert
      expect(result, 42);
    });

    test('turns any throw into a CacheException', () async {
      // Arrange
      Future<int> op() async => throw StateError('boom');

      // Act
      final call = dataSource.safeCacheCall(op);

      // Assert
      await expectLater(call, throwsA(isA<CacheException>()));
    });
  });

  group('safeCacheStream', () {
    test('passes values through', () async {
      // Arrange
      final source = Stream.fromIterable([1, 2]);

      // Act
      final values = await dataSource.safeCacheStream(() => source).toList();

      // Assert
      expect(values, [1, 2]);
    });

    test('turns an error into a CacheException and keeps going', () async {
      // Arrange
      final controller = StreamController<int>();
      final values = <int>[];
      final errors = <Object>[];

      // Act
      final done = Completer<void>();
      dataSource
          .safeCacheStream(() => controller.stream)
          .listen(values.add, onError: errors.add, onDone: done.complete);
      controller
        ..add(1)
        ..addError(StateError('boom'))
        ..add(2);
      await controller.close();
      await done.future;

      // Assert
      expect(values, [1, 2]);
      expect(errors.single, isA<CacheException>());
    });

    test('turns a throw while opening the stream into a CacheException', () {
      // Arrange
      Stream<int> open() => throw StateError('boom');

      // Act
      final stream = dataSource.safeCacheStream(open);

      // Assert
      expect(stream, emitsError(isA<CacheException>()));
    });
  });
}
