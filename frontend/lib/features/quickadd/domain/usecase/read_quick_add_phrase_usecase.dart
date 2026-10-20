import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/quickadd/domain/repository/quickadd_repository.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

/// Layer 1 of quick add, on the phone: parses the phrase and, for each
/// draft whose note the user has used before, takes the category they gave
/// it then over the keyword guess. Never fails; a history lookup that fails
/// keeps the guess.
class ReadQuickAddPhraseUseCase
    implements UseCase<List<QuickAddDraft>, ReadQuickAddPhraseParams> {
  ReadQuickAddPhraseUseCase(this._repository);

  /// How sure a category the user gave the same note before is.
  static const history = 0.9;

  final QuickaddRepository _repository;

  @override
  Future<Either<Failure, List<QuickAddDraft>>> call(
    ReadQuickAddPhraseParams params,
  ) async {
    final context = params.context;
    final visible = {for (final c in context.categories) c.id};
    final drafts = QuickAddParser.parse(params.text, context);
    return Right(await Future.wait(drafts.map((d) => _remembered(d, visible))));
  }

  Future<QuickAddDraft> _remembered(
    QuickAddDraft draft,
    Set<String> visible,
  ) async {
    final note = draft.note;
    if (note == null || draft.type == TransactionType.transfer) return draft;
    final result = await _repository.categoryForNote(note, draft.type);
    return switch (result) {
      Right(value: final id?) when visible.contains(id) => draft.copyWith(
        categoryId: id,
        confidence: draft.confidence.copyWith(category: history),
      ),
      _ => draft,
    };
  }
}

class ReadQuickAddPhraseParams {
  const ReadQuickAddPhraseParams({required this.text, required this.context});

  final String text;
  final ParseContext context;
}
