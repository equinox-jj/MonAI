import 'package:freezed_annotation/freezed_annotation.dart';

part 'draft_confidence.freezed.dart';

/// How sure the reader of a phrase or receipt (the phone or the AI) is of
/// each field of a draft, from 0 to 1.
@freezed
abstract class DraftConfidence with _$DraftConfidence {
  const factory DraftConfidence({
    @Default(0) double type,
    @Default(0) double amount,
    @Default(0) double wallet,
    @Default(0) double category,
    @Default(0) double date,
  }) = _DraftConfidence;

  /// Below this a filled field is shown for the user to check.
  static const sure = 0.7;
}
