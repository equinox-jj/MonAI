import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/model/scan_phase.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/widgets/scan_receipt_camera_view.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/widgets/scan_receipt_frame.dart';

/// The photo being read, with what has been done so far.
class ScanReceiptProcessing extends StatelessWidget {
  const ScanReceiptProcessing({
    required this.photoPath,
    required this.step,
    required this.onCancel,
    super.key,
  });

  final String photoPath;
  final ProcessingStep step;

  /// Back to the camera.
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = context.textTheme;
    return SafeArea(
      child: Padding(
        padding: const .fromLTRB(
          MonAISpacing.x4,
          MonAISpacing.x4,
          MonAISpacing.x4,
          MonAISpacing.x10,
        ),
        child: Column(
          spacing: MonAISpacing.x6,
          children: [
            Row(
              children: [
                ScanReceiptRoundButton(
                  icon: MonAIIcons.close,
                  tooltip: l10n.receiptProcessingCancel,
                  onPressed: onCancel,
                ),
                Expanded(
                  child: Text(
                    l10n.receiptScanTitle,
                    textAlign: .center,
                    style: t.titleMedium?.copyWith(color: MonAIPalette.white),
                  ),
                ),
                const SizedBox.square(dimension: MonAISizes.touchTarget),
              ],
            ),
            Flexible(child: _Photo(path: photoPath)),
            Semantics(
              liveRegion: true,
              child: Column(
                spacing: MonAISpacing.x1_5,
                children: [
                  Row(
                    mainAxisSize: .min,
                    spacing: MonAISpacing.x2_5,
                    children: [
                      const SizedBox.square(
                        dimension: MonAISizes.iconMd,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: MonAIPalette.lime,
                          backgroundColor: Color(0x40FFFFFF),
                        ),
                      ),
                      Text(
                        l10n.receiptProcessingTitle,
                        style: t.titleLarge?.copyWith(
                          color: MonAIPalette.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    l10n.receiptProcessingHint,
                    style: t.bodySmall?.copyWith(color: MonAIPalette.gray400),
                  ),
                ],
              ),
            ),
            _Steps(step: step),
            const Spacer(),
            MonAIButton(
              label: l10n.receiptProcessingCancel,
              onPressed: onCancel,
              variant: .outlined,
              size: .medium,
            ),
          ],
        ),
      ),
    );
  }
}

class _Photo extends StatefulWidget {
  const _Photo({required this.path});

  static const _width = 240.0;
  static const _height = 340.0;

  final String path;

  @override
  State<_Photo> createState() => _PhotoState();
}

class _PhotoState extends State<_Photo> with SingleTickerProviderStateMixin {
  late final _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  late final _position = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.06, end: 0.9), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 0.9, end: 0.06), weight: 1),
  ]).animate(CurvedAnimation(parent: _sweep, curve: Curves.easeInOut));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _sweep
        ..stop()
        ..value = 0.25;
    } else if (!_sweep.isAnimating) {
      _sweep.repeat();
    }
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: _Photo._width,
        maxHeight: _Photo._height,
      ),
      child: AspectRatio(
        aspectRatio: _Photo._width / _Photo._height,
        child: ClipRRect(
          borderRadius: MonAIRadius.lgAll,
          child: Stack(
            fit: .expand,
            children: [
              Opacity(
                opacity: 0.75,
                child: Image.file(
                  File(widget.path),
                  fit: .cover,
                  errorBuilder: (_, _, _) =>
                      const ColoredBox(color: Color(0xFFF4F1EA)),
                ),
              ),
              const ColoredBox(color: Color(0x591A1842)),
              AnimatedBuilder(
                animation: _position,
                builder: (context, child) => Align(
                  alignment: Alignment(0, _position.value * 2 - 1),
                  child: child,
                ),
                child: const ScanReceiptScanLine(thickness: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Read on the phone, then the AI, then the draft.
class _Steps extends StatelessWidget {
  const _Steps({required this.step});

  final ProcessingStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textRead = step != ProcessingStep.readingText;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MonAIPalette.white.withValues(alpha: 0.06),
        borderRadius: MonAIRadius.lgAll,
      ),
      child: Padding(
        padding: const .all(MonAISpacing.x4),
        child: Column(
          spacing: MonAISpacing.x3,
          children: [
            _StepRow(
              label: textRead
                  ? l10n.receiptProcessingTextFound
                  : l10n.receiptProcessingReadingText,
              state: textRead ? _StepState.done : _StepState.active,
              trailing: l10n.receiptProcessingOffline,
            ),
            _StepRow(
              label: l10n.receiptProcessingFindingDetails,
              state: textRead ? _StepState.active : _StepState.pending,
            ),
            _StepRow(
              label: l10n.receiptProcessingPreparing,
              state: _StepState.pending,
            ),
          ],
        ),
      ),
    );
  }
}

enum _StepState { done, active, pending }

class _StepRow extends StatelessWidget {
  const _StepRow({required this.label, required this.state, this.trailing});

  final String label;
  final _StepState state;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.textTheme;
    final (icon, iconColor, textColor) = switch (state) {
      .done => (
        MonAIIcons.checkCircle,
        MonAIPalette.green400,
        MonAIPalette.white,
      ),
      .active => (
        MonAIIcons.autoAwesome,
        MonAIPalette.lime,
        MonAIPalette.white,
      ),
      .pending => (
        MonAIIcons.radioButtonUnchecked,
        MonAIPalette.gray500,
        MonAIPalette.gray500,
      ),
    };
    return Row(
      spacing: MonAISpacing.x2_5,
      children: [
        MonAIIcon(icon, size: MonAISizes.iconLg, color: iconColor),
        Expanded(
          child: Text(
            label,
            style: t.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: state == .active ? .w600 : null,
            ),
          ),
        ),
        if (trailing case final trailing?)
          Text(
            trailing,
            style: t.bodySmall?.copyWith(color: MonAIPalette.gray400),
          ),
      ],
    );
  }
}
