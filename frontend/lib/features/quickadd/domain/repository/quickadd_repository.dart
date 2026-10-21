import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/quickadd/domain/entity/ai_draft.dart';

abstract class QuickaddRepository {
  /// [text] is 1 to 300 characters; [today] is the user's date in [timezone], an
  /// IANA name. Nothing is saved.
  Future<Either<Failure, List<AiDraft>>> parse(
    String text, {
    required DateTime today,
    required String timezone,
  });

  Future<Either<Failure, String?>> categoryForNote(
    String note,
    TransactionType type,
  );
}
