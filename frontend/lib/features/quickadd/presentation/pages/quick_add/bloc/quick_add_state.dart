part of 'quick_add_bloc.dart';

@freezed
abstract class QuickAddState with _$QuickAddState {
  const factory QuickAddState({
    ParseContext? context,
    @Default('') String phrase,
    @Default([]) List<QuickAddDraft> drafts,
    @Default(DraftEngine.local) DraftEngine engine,
    QuickAddAiFailure? aiFailure,
    @Default(false) bool isAsking,
    QuickAddNavigation? navigation,
  }) = _QuickAddState;
}

@freezed
sealed class QuickAddNavigation with _$QuickAddNavigation {
  const factory QuickAddNavigation.form(QuickAddDraft draft) =
      QuickAddFormNavigation;

  const factory QuickAddNavigation.review(QuickAddReviewArgs args) =
      QuickAddReviewNavigation;
}
