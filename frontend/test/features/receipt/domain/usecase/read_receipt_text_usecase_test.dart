import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';
import 'package:monai/features/receipt/domain/usecase/read_receipt_text_usecase.dart';

class _MockReceiptRepository extends Mock implements ReceiptRepository {}

void main() {
  const path = '/tmp/receipt.jpg';
  late _MockReceiptRepository repository;
  late ReadReceiptTextUseCase useCase;

  setUp(() {
    repository = _MockReceiptRepository();
    useCase = ReadReceiptTextUseCase(repository);
  });

  test('returns the text trimmed', () async {
    // Arrange
    when(() => repository.readText(path))
        .thenAnswer((_) async => const Right('\n  TOTAL 25.000 \n'));

    // Act
    final result = await useCase(path);

    // Assert
    expect(result, const Right<Failure, String?>('TOTAL 25.000'));
  });

  test('returns null when the text is only whitespace', () async {
    // Arrange
    when(() => repository.readText(path))
        .thenAnswer((_) async => const Right(' \n\t '));

    // Act
    final result = await useCase(path);

    // Assert
    expect(result, const Right<Failure, String?>(null));
  });

  test('returns null when the photo has no text', () async {
    // Arrange
    when(() => repository.readText(path))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase(path);

    // Assert
    expect(result, const Right<Failure, String?>(null));
  });

  test('passes a failure through unchanged', () async {
    // Arrange
    const failure = Failure.unknown(code: 'unreadable_image');
    when(() => repository.readText(path))
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await useCase(path);

    // Assert
    expect(result, const Left<Failure, String?>(failure));
  });
}
