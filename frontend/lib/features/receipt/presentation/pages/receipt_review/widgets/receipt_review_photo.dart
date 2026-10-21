import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

class ReceiptReviewPhoto extends StatelessWidget {
  const ReceiptReviewPhoto({required this.photoPath, super.key});

  static const _maxScale = 5.0;

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return Semantics(
      label: l10n.receiptReviewPhoto,
      image: true,
      child: ColoredBox(
        color: c.surfaceSunken,
        child: Padding(
          padding: const .all(MonAISpacing.x6),
          child: Column(
            spacing: MonAISpacing.x4,
            children: [
              Expanded(
                child: InteractiveViewer(
                  maxScale: _maxScale,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: MonAIRadius.smAll,
                      child: Image.file(
                        File(photoPath),
                        fit: .contain,
                        errorBuilder: (_, _, _) => MonAIIcon(
                          MonAIIcons.receiptLong,
                          size: MonAISizes.stateIcon,
                          color: c.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: .min,
                spacing: MonAISpacing.x1_5,
                children: [
                  MonAIIcon(
                    MonAIIcons.zoomIn,
                    size: MonAISizes.iconSm,
                    color: c.textSecondary,
                  ),
                  Text(
                    l10n.receiptReviewPhotoHint,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
