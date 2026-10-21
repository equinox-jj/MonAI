import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

part 'quick_add_review_args.freezed.dart';

@freezed
abstract class QuickAddReviewArgs with _$QuickAddReviewArgs {
  const factory QuickAddReviewArgs({
    required String phrase,
    required List<QuickAddDraft> drafts,
  }) = _QuickAddReviewArgs;
}

enum QuickAddReviewExit { startOver, home }
