import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/quickadd/domain/entity/ai_draft.dart';
import 'package:monai/features/quickadd/domain/entity/quick_add_reading.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/quickadd/domain/repository/quickadd_repository.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

/// Layer 2 of quick add. Keeps the phone's drafts when they already have a
/// sure amount and category (an unnamed wallet falls back to the default
/// one, highlighted); otherwise asks the AI, giving up after [timeout]. Any
/// AI failure (offline, 429, 503, timeout) falls back to the phone's drafts,
/// whose unsure fields stay highlighted. Never fails.
class CompleteDraftsWithAiUseCase
    implements UseCase<QuickAddReading, CompleteDraftsParams> {
  CompleteDraftsWithAiUseCase({
    required this._repository,
    required this._watchUser,
    this.timeout = const Duration(seconds: 3),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  /// The API's limit.
  static const maxTextLength = 300;

  /// When the profile hasn't been cached yet.
  static const _fallbackTimezone = 'UTC';

  final QuickaddRepository _repository;
  final WatchUserUseCase _watchUser;
  final DateTime Function() _now;
  final Duration timeout;

  @override
  Future<Either<Failure, QuickAddReading>> call(
    CompleteDraftsParams params,
  ) async {
    final local = params.local;
    if (!needsAi(local)) {
      return Right(QuickAddReading(drafts: local, engine: DraftEngine.local));
    }
    final result = await _askAi(params.text)
        .timeout(timeout, onTimeout: () => const Left(Failure.timeout()));
    return Right(switch (result) {
      Right(value: final ai) when ai.isNotEmpty => QuickAddReading(
        drafts: [
          for (final (i, draft) in ai.indexed)
            _filled(
              draft,
              ai.length == local.length ? local[i] : null,
              params.context,
            ),
        ],
        engine: DraftEngine.ai,
      ),
      Left(value: final failure) => QuickAddReading(
        drafts: local,
        engine: DraftEngine.fallback,
        aiFailure: _aiFailureOf(failure),
      ),
      // The AI read nothing.
      _ => QuickAddReading(
        drafts: local,
        engine: DraftEngine.fallback,
        aiFailure: QuickAddAiFailure.unavailable,
      ),
    });
  }

  Future<Either<Failure, List<AiDraft>>> _askAi(String text) async {
    final now = _now();
    final user = await _watchUser(const NoParams()).first;
    final trimmed = text.trim();
    return _repository.parse(
      trimmed.length > maxTextLength
          ? trimmed.substring(0, maxTextLength)
          : trimmed,
      today: DateTime(now.year, now.month, now.day),
      timezone: user.toNullable()?.timezone ?? _fallbackTimezone,
    );
  }

  static QuickAddAiFailure _aiFailureOf(Failure failure) => switch (failure) {
    NetworkFailure() || TimeoutFailure() => QuickAddAiFailure.offline,
    TooManyRequestsFailure() => QuickAddAiFailure.rateLimited,
    _ => QuickAddAiFailure.unavailable,
  };

  /// Fields the AI left null come from the phone's draft at the same place,
  /// else the defaults.
  static QuickAddDraft _filled(
    AiDraft ai,
    QuickAddDraft? local,
    ParseContext context,
  ) {
    final walletId = ai.walletId ?? local?.walletId ?? context.defaultWalletId;
    final confidence = ai.confidence;
    final localConfidence = local?.confidence ?? const DraftConfidence();
    return QuickAddDraft(
      type: ai.type ?? local?.type ?? .expense,
      amount: ai.amount ?? local?.amount,
      walletId: walletId,
      toWalletId: ai.toWalletId ?? local?.toWalletId,
      categoryId: ai.categoryId ?? local?.categoryId,
      date: ai.date ?? local?.date ?? context.today,
      note: ai.note ?? local?.note,
      merchant: ai.merchant,
      confidence: DraftConfidence(
        type: ai.type != null ? confidence.type : localConfidence.type,
        amount: ai.amount != null ? confidence.amount : localConfidence.amount,
        wallet: switch (null) {
          _ when ai.walletId != null => confidence.wallet,
          _ when local?.walletId != null => localConfidence.wallet,
          _ when walletId != null => defaultWalletGuess,
          _ => 0,
        },
        category: ai.categoryId != null
            ? confidence.category
            : localConfidence.category,
        date: ai.date != null ? confidence.date : localConfidence.date,
      ),
    );
  }
}

class CompleteDraftsParams {
  const CompleteDraftsParams({
    required this.text,
    required this.local,
    required this.context,
  });

  final String text;
  final List<QuickAddDraft> local;
  final ParseContext context;
}
