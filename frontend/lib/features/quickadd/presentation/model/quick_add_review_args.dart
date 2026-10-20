import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

part 'quick_add_review_args.freezed.dart';

/// What quick add hands the review: the phrase and its drafts.
@freezed
abstract class QuickAddReviewArgs with _$QuickAddReviewArgs {
  const factory QuickAddReviewArgs({
    required String phrase,

    /// Two or more.
    required List<QuickAddDraft> drafts,
  }) = _QuickAddReviewArgs;
}

/// How the review was left.
enum QuickAddReviewExit {
  /// "Start over": back to an empty quick add.
  startOver,

  /// "Back to home", or every draft was handled.
  home,
}
