import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/receipt/presentation/model/receipt_ai_failure.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/bloc/receipt_review_bloc.dart';

/// What the review is: fields the AI filled are marked, or the AI gave no
/// draft, with why and "Try again".
class ReceiptReviewBanner extends StatelessWidget {
  const ReceiptReviewBanner({required this.onRetry, super.key, this.photoPath});

  static const _thumbWidth = 44.0;
  static const _thumbHeight = 56.0;

  /// Sends the receipt's text to the AI again.
  final VoidCallback onRetry;

  /// Shows a thumbnail of the photo; the tablet layout shows it whole.
  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ReceiptReviewBloc,
      ReceiptReviewState,
      (ReceiptAiFailure?, bool)
    >(
      selector: (state) => (state.aiFailure, state.isRetrying),
      builder: (context, selected) {
        final (aiFailure, isRetrying) = selected;
        final c = context.colors;
        final (fill, content) = aiFailure == null
            ? (c.primaryContainer, c.onPrimaryContainer)
            : (c.warningContainer, c.onWarningContainer);
        return DecoratedBox(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: MonAIRadius.mdAll,
          ),
          child: Padding(
            padding: const .symmetric(
              horizontal: MonAISpacing.x3,
              vertical: MonAISpacing.x2_5,
            ),
            child: Row(
              spacing: MonAISpacing.x3,
              children: [
                if (photoPath case final path?)
                  _Thumbnail(path: path)
                else
                  MonAIIcon(
                    aiFailure == null
                        ? MonAIIcons.autoAwesome
                        : MonAIIcons.warning,
                    size: MonAISizes.iconMd,
                    color: content,
                  ),
                Expanded(
                  child: switch (aiFailure) {
                    null => _FilledText(color: content),
                    final failure => _FailedText(
                      failure: failure,
                      color: content,
                      isRetrying: isRetrying,
                      onRetry: onRetry,
                    ),
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: MonAIRadius.smAll,
      child: Image.file(
        File(path),
        width: ReceiptReviewBanner._thumbWidth,
        height: ReceiptReviewBanner._thumbHeight,
        fit: .cover,
        cacheWidth: 132,
        errorBuilder: (_, _, _) => const SizedBox(
          width: ReceiptReviewBanner._thumbWidth,
          height: ReceiptReviewBanner._thumbHeight,
        ),
      ),
    );
  }
}

/// "We filled the fields marked ✦ from your receipt…"
class _FilledText extends StatelessWidget {
  const _FilledText({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${l10n.receiptReviewBannerBefore} '),
          WidgetSpan(
            alignment: .middle,
            child: MonAIIcon(
              MonAIIcons.autoAwesome,
              size: MonAISizes.iconXs,
              color: context.colors.accent,
              semanticLabel: l10n.receiptReviewFilledByAi,
            ),
          ),
          TextSpan(text: ' ${l10n.receiptReviewBannerAfter}'),
        ],
      ),
      style: context.textTheme.bodySmall?.copyWith(color: color),
    );
  }
}

/// Why the AI gave no draft, with "Try again".
class _FailedText extends StatelessWidget {
  const _FailedText({
    required this.failure,
    required this.color,
    required this.isRetrying,
    required this.onRetry,
  });

  final ReceiptAiFailure failure;
  final Color color;
  final bool isRetrying;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      spacing: MonAISpacing.x2,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            failure.banner(l10n),
            style: context.textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
        MonAIButton(
          label: l10n.receiptReviewTryAgain,
          leadingIcon: MonAIIcons.refresh,
          onPressed: onRetry,
          loading: isRetrying,
          variant: .outlined,
          size: .small,
        ),
      ],
    );
  }
}
