part of 'quick_add_bloc.dart';

@freezed
sealed class QuickAddEvent with _$QuickAddEvent {
  const factory QuickAddEvent.started() = _Started;
  const factory QuickAddEvent.textChanged(String text) = _TextChanged;

  const factory QuickAddEvent.continueRequested(String text) =
      _ContinueRequested;

  const factory QuickAddEvent.contextChanged(ParseContext context) =
      _ContextChanged;
}
