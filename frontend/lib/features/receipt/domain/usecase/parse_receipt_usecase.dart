import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';
import 'package:monai/features/receipt/domain/repository/receipt_repository.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

/// Turns a receipt's text into a draft (merchant, total, date, category,
/// items) with the AI, dated in the user's own timezone.
class ParseReceiptUseCase implements UseCase<ReceiptDraft, String> {
  /// [now] is the clock; tests pass a fixed one.
  ParseReceiptUseCase({
    required this._repository,
    required this._watchUser,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  /// The API's limit. A receipt's total sits near the end, but receipts
  /// this long are rare.
  static const maxTextLength = 5000;

  /// When the profile hasn't been cached yet.
  static const _fallbackTimezone = 'UTC';

  final ReceiptRepository _repository;
  final WatchUserUseCase _watchUser;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, ReceiptDraft>> call(String ocrText) async {
    final now = _now();
    final user = await _watchUser(const NoParams()).first;
    final timezone = user.toNullable()?.timezone ?? _fallbackTimezone;
    return _repository.parse(
      ocrText.length > maxTextLength
          ? ocrText.substring(0, maxTextLength)
          : ocrText,
      today: DateTime(now.year, now.month, now.day),
      timezone: timezone,
    );
  }
}
