import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/quickadd/domain/entity/quick_add_reading.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/quickadd/domain/usecase/complete_drafts_with_ai_usecase.dart';
import 'package:monai/features/quickadd/domain/usecase/read_quick_add_phrase_usecase.dart';
import 'package:monai/features/quickadd/domain/usecase/watch_quick_add_context_usecase.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_review_args.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/model/quick_add_state_extension.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';
import 'package:rxdart/rxdart.dart';

part 'quick_add_bloc.freezed.dart';
part 'quick_add_event.dart';
part 'quick_add_state.dart';

/// Turns a typed phrase into transaction drafts: read on the phone as the
/// user types, then, only when the phone isn't sure of an amount or a
/// category, by the AI on the first tap of the main button. The next tap
/// opens the form (one draft) or the review (several). Nothing is saved
/// here.
class QuickAddBloc extends Bloc<QuickAddEvent, QuickAddState> {
  QuickAddBloc({
    required this._watchContext,
    required this._read,
    required this._complete,
  }) : super(const QuickAddState()) {
    on<_Started>(_onStarted);
    // A newer phrase replaces a reading still in progress.
    on<_TextChanged>(
      _onTextChanged,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
    on<_ContinueRequested>(_onContinueRequested);
    on<_ContextChanged>(_onContextChanged);
  }

  final WatchQuickAddContextUseCase _watchContext;
  final ReadQuickAddPhraseUseCase _read;
  final CompleteDraftsWithAiUseCase _complete;

  StreamSubscription<void>? _context;

  String _text = '';

  void _onStarted(_Started event, Emitter<QuickAddState> emit) {
    _context = _watchContext(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (context) => add(QuickAddEvent.contextChanged(context)),
      ),
    );
  }

  Future<void> _onContextChanged(
    _ContextChanged event,
    Emitter<QuickAddState> emit,
  ) async {
    emit(state.copyWith(context: event.context));
    // The AI's reading stays; only the phone's is redone with new names.
    if (state.engine == DraftEngine.local) await _readLocally(emit, _text);
  }

  Future<void> _onTextChanged(
    _TextChanged event,
    Emitter<QuickAddState> emit,
  ) async {
    _text = event.text;
    if (event.text.trim() == state.phrase) return;
    await _readLocally(emit, event.text);
  }

  Future<void> _readLocally(Emitter<QuickAddState> emit, String text) async {
    final context = state.context;
    if (context == null) return;
    final result = await _read(
      ReadQuickAddPhraseParams(text: text, context: context),
    );
    emit(
      state.copyWith(
        phrase: text.trim(),
        drafts: result.getOrElse((_) => const []),
        engine: DraftEngine.local,
        aiFailure: null,
      ),
    );
  }

  Future<void> _onContinueRequested(
    _ContinueRequested event,
    Emitter<QuickAddState> emit,
  ) async {
    final context = state.context;
    if (context == null || !state.canContinue) return;
    if (state.willAskAi) {
      emit(state.copyWith(isAsking: true));
      final result = await _complete(
        CompleteDraftsParams(
          text: event.text,
          local: state.drafts,
          context: context,
        ),
      );
      final reading = result.getOrElse(
        (_) => QuickAddReading(
          drafts: state.drafts,
          engine: DraftEngine.fallback,
          aiFailure: QuickAddAiFailure.unavailable,
        ),
      );
      // The user sees what the AI read before going on.
      emit(
        state.copyWith(
          isAsking: false,
          drafts: reading.drafts,
          engine: reading.engine,
          aiFailure: reading.aiFailure,
        ),
      );
      return;
    }
    final drafts = state.drafts;
    emit(
      state.copyWith(
        navigation: drafts.length == 1
            ? QuickAddNavigation.form(drafts.single)
            : QuickAddNavigation.review(
                QuickAddReviewArgs(phrase: state.phrase, drafts: drafts),
              ),
      ),
    );
    emit(state.copyWith(navigation: null));
  }

  @override
  Future<void> close() async {
    await _context?.cancel();
    return super.close();
  }
}
