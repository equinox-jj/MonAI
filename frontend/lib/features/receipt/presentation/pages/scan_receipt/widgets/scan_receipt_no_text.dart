import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/widgets/scan_receipt_camera_view.dart';

/// The blurred photo under a sheet: no text was found, so retake it or
/// enter the transaction by hand.
class ScanReceiptNoText extends StatelessWidget {
  const ScanReceiptNoText({
    required this.photoPath,
    required this.sheetTheme,
    required this.onClose,
    required this.onRetake,
    required this.onEnterManually,
    super.key,
  });

  final String photoPath;

  /// The app's theme; the scanner around the sheet is always dark.
  final ThemeData sheetTheme;
  final VoidCallback onClose;
  final VoidCallback onRetake;
  final VoidCallback onEnterManually;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        Opacity(
          opacity: 0.6,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Image.file(
              File(photoPath),
              fit: .cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: .topLeft,
            child: Padding(
              padding: const .all(MonAISpacing.x4),
              child: ScanReceiptRoundButton(
                icon: MonAIIcons.close,
                tooltip: context.l10n.receiptScanClose,
                onPressed: onClose,
              ),
            ),
          ),
        ),
        Align(
          alignment: .bottomCenter,
          child: Theme(
            data: sheetTheme,
            child: _Sheet(onRetake: onRetake, onEnterManually: onEnterManually),
          ),
        ),
      ],
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.onRetake, required this.onEnterManually});

  final VoidCallback onRetake;
  final VoidCallback onEnterManually;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Material(
        color: c.surface,
        borderRadius: MonAIRadius.sheetTop,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const .fromLTRB(
              MonAISpacing.x6,
              MonAISpacing.x6,
              MonAISpacing.x6,
              MonAISpacing.x8,
            ),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              spacing: MonAISpacing.x3_5,
              children: [
                Align(
                  alignment: .centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.errorContainer,
                      shape: .circle,
                    ),
                    child: SizedBox.square(
                      dimension: MonAISizes.avatarXLarge - MonAISpacing.x2,
                      child: Center(
                        child: MonAIIcon(
                          MonAIIcons.receiptLong,
                          size: MonAISizes.iconXl,
                          color: c.error,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(l10n.receiptNoTextTitle, style: t.titleLarge),
                Text(
                  l10n.receiptNoTextBody,
                  style: t.bodyMedium?.copyWith(color: c.textSecondary),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.surfaceSunken,
                    borderRadius: MonAIRadius.mdAll,
                  ),
                  child: Padding(
                    padding: const .all(MonAISpacing.x3_5),
                    child: Column(
                      spacing: MonAISpacing.x2_5,
                      children: [
                        _Tip(
                          icon: MonAIIcons.lightMode,
                          text: l10n.receiptNoTextTipLight,
                        ),
                        _Tip(
                          icon: MonAIIcons.cropFree,
                          text: l10n.receiptNoTextTipFlat,
                        ),
                        _Tip(
                          icon: MonAIIcons.centerFocusStrong,
                          text: l10n.receiptNoTextTipStill,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: MonAISpacing.x1),
                MonAIButton(
                  label: l10n.receiptNoTextRetake,
                  leadingIcon: MonAIIcons.photoCamera,
                  onPressed: onRetake,
                  expand: true,
                ),
                MonAIButton(
                  label: l10n.receiptNoTextManual,
                  leadingIcon: MonAIIcons.edit,
                  onPressed: onEnterManually,
                  variant: .outlined,
                  size: .medium,
                  expand: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({required this.icon, required this.text});

  final MonAIIconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      spacing: MonAISpacing.x2_5,
      children: [
        MonAIIcon(icon, size: MonAISizes.iconMd, color: c.accent),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodySmall?.copyWith(
              color: c.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
