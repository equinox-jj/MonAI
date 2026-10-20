import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';

part 'quick_add_reading.freezed.dart';

/// Who read the phrase: the phone alone, the AI, or the phone because the
/// AI couldn't.
enum DraftEngine { local, ai, fallback }

/// Why the AI couldn't read a phrase. Quick add then keeps the phone's own
/// reading.
enum QuickAddAiFailure {
  /// No connection or a timeout.
  offline,

  /// The per-user AI quota is used up for now.
  rateLimited,

  /// The AI model is down or didn't answer in time.
  unavailable,
}

/// The drafts read from a phrase and who read them.
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
