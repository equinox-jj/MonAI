part of 'quick_add_bloc.dart';

@freezed
sealed class QuickAddEvent with _$QuickAddEvent {
  /// The screen opened.
  const factory QuickAddEvent.started() = _Started;

  /// The phrase changed to [text]; read again on the phone.
  const factory QuickAddEvent.textChanged(String text) = _TextChanged;

  /// The main button, with the input's [text]: asks the AI first when the
  /// phone isn't sure, otherwise opens the drafts.
  const factory QuickAddEvent.continueRequested(String text) =
      _ContinueRequested;

  /// The cached wallets, categories or providers changed. Sent by the bloc
  /// itself.
  const factory QuickAddEvent.contextChanged(ParseContext context) =
      _ContextChanged;
}
