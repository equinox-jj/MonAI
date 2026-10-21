import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/quickadd/domain/entity/quick_add_reading.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_text.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/bloc/quick_add_bloc.dart';

class QuickAddStatus extends StatelessWidget {
  const QuickAddStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      QuickAddBloc,
      QuickAddState,
      (QuickAddEngineNote?, bool, QuickAddAiFailure?)
    >(
      selector: (state) => (
        switch (state.context) {
          final parseContext? => quickAddEngineNote(
            state.drafts,
            state.engine,
            parseContext,
          ),
          null => null,
        },
        state.engine == DraftEngine.fallback && state.drafts.isNotEmpty,
        state.aiFailure,
      ),
      builder: (context, selected) => switch (selected) {
        (_, true, final failure) => _FallbackBanner(failure: failure),
        (final note?, false, _) => _EngineLine(note: note),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _EngineLine extends StatelessWidget {
  const _EngineLine({required this.note});

  final QuickAddEngineNote note;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = switch (note.kind) {
      .onPhone => c.success,
      .defaultWallet => c.transfer,
      .willAskAi || .askedAi => c.accent,
    };
    return Semantics(
      liveRegion: true,
      child: Row(
        spacing: MonAISpacing.x1_5,
        children: [
          MonAIIcon(note.icon, size: MonAISizes.iconSm, color: color),
          Expanded(
            child: Text(
              note.text(context.l10n),
              style: context.textTheme.bodySmall?.copyWith(
                color: c.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackBanner extends StatelessWidget {
  const _FallbackBanner({required this.failure});

  final QuickAddAiFailure? failure;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.warningContainer,
          borderRadius: MonAIRadius.mdAll,
          border: Border.all(color: c.warningContainerBorder),
        ),
        child: Padding(
          padding: const .all(MonAISpacing.x3),
          child: Row(
            crossAxisAlignment: .start,
            spacing: MonAISpacing.x2_5,
            children: [
              MonAIIcon(
                failure == QuickAddAiFailure.offline
                    ? MonAIIcons.cloudOff
                    : MonAIIcons.hourglassTop,
                size: MonAISizes.iconLg,
                color: c.warning,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: MonAISpacing.x0_5,
                  children: [
                    Text(
                      quickAddFallbackTitle(failure, l10n),
                      style: t.titleSmall?.copyWith(
                        color: c.onWarningContainer,
                      ),
                    ),
                    Text(
                      l10n.quickAddFallbackBody,
                      style: t.bodySmall?.copyWith(color: c.onWarningContainer),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
