import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

part 'quick_add_reading.freezed.dart';

/// Who read the phrase: the phone alone, the AI, or the phone because the
/// AI couldn't.
enum DraftEngine { local, ai, fallback }

/// Quick add then keeps the phone's own reading.
enum QuickAddAiFailure { offline, rateLimited, unavailable }

@freezed
abstract class QuickAddReading with _$QuickAddReading {
  const factory QuickAddReading({
    required List<QuickAddDraft> drafts,
    required DraftEngine engine,

    /// Why the AI failed; set only when [engine] is
    /// [DraftEngine.fallback].
    QuickAddAiFailure? aiFailure,
  }) = _QuickAddReading;
}
