part of 'quick_add_bloc.dart';

@freezed
abstract class QuickAddState with _$QuickAddState {
  const factory QuickAddState({
    /// The wallets, categories and providers to match; null until loaded.
    ParseContext? context,

    /// The phrase the drafts were read from, trimmed.
    @Default('') String phrase,
    @Default([]) List<QuickAddDraft> drafts,
    @Default(DraftEngine.local) DraftEngine engine,

    /// Why the AI couldn't help; set only on [DraftEngine.fallback].
    QuickAddAiFailure? aiFailure,

    /// Waiting for the AI.
    @Default(false) bool isAsking,

    /// Where to go next; the screen navigates once, then it is cleared.
    QuickAddNavigation? navigation,
  }) = _QuickAddState;
}

extension QuickAddStateX on QuickAddState {
  /// The phone's drafts aren't sure enough and the AI hasn't been asked.
  bool get willAskAi => engine == DraftEngine.local && needsAi(drafts);

  bool get hasMissingAmount => drafts.any((d) => d.amount == null);

  bool get canContinue => drafts.isNotEmpty && !isAsking;
}

/// Where quick add sends the user.
@freezed
sealed class QuickAddNavigation with _$QuickAddNavigation {
  /// The add form, filled from [draft].
  const factory QuickAddNavigation.form(QuickAddDraft draft) =
      QuickAddFormNavigation;

  /// The review of several drafts, one at a time.
  const factory QuickAddNavigation.review(QuickAddReviewArgs args) =
      QuickAddReviewNavigation;
}
