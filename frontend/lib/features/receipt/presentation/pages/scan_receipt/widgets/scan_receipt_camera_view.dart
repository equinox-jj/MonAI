import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/bloc/scan_receipt_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/model/scan_phase.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/model/scan_receipt_state_extension.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/widgets/scan_receipt_frame.dart';

class ScanReceiptCameraView extends StatelessWidget {
  const ScanReceiptCameraView({
    required this.preview,
    required this.onClose,
    required this.onToggleFlash,
    required this.onCapture,
    required this.onPickPhoto,
    required this.onTypeInstead,
    super.key,
  });

  final Widget Function() preview;
  final VoidCallback onClose;
  final VoidCallback onToggleFlash;
  final VoidCallback onCapture;
  final VoidCallback onPickPhoto;
  final VoidCallback onTypeInstead;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ScanReceiptBloc, ScanReceiptState, CameraStatus>(
      selector: (state) => state.camera,
      builder: (context, camera) => Stack(
        fit: .expand,
        children: [
          if (camera == .ready)
            preview()
          else
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.16),
                  radius: 0.9,
                  colors: [
                    Color(0xFF3A3F4B),
                    Color(0xFF1D2230),
                    MonAIPalette.gray925,
                  ],
                  stops: [0, 0.45, 0.8],
                ),
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                _Header(
                  showFlash: camera == .ready,
                  onClose: onClose,
                  onToggleFlash: onToggleFlash,
                ),
                Expanded(
                  child: switch (camera) {
                    .opening || .ready => const _Viewfinder(),
                    .denied => _CameraMessage(
                      title: context.l10n.receiptScanDeniedTitle,
                      message: context.l10n.receiptScanDeniedBody,
                    ),
                    .unavailable => _CameraMessage(
                      title: context.l10n.receiptScanUnavailableTitle,
                      message: context.l10n.receiptScanUnavailableBody,
                    ),
                  },
                ),
                _Controls(
                  onCapture: onCapture,
                  onPickPhoto: onPickPhoto,
                  onTypeInstead: onTypeInstead,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.showFlash,
    required this.onClose,
    required this.onToggleFlash,
  });

  final bool showFlash;
  final VoidCallback onClose;
  final VoidCallback onToggleFlash;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .all(MonAISpacing.x4),
      child: Row(
        children: [
          ScanReceiptRoundButton(
            icon: MonAIIcons.close,
            tooltip: l10n.receiptScanClose,
            onPressed: onClose,
          ),
          Expanded(
            child: Text(
              l10n.receiptScanTitle,
              textAlign: .center,
              style: context.textTheme.titleMedium?.copyWith(
                color: MonAIPalette.white,
              ),
            ),
          ),
          if (showFlash)
            BlocSelector<ScanReceiptBloc, ScanReceiptState, bool>(
              selector: (state) => state.flashOn,
              builder: (context, flashOn) => ScanReceiptRoundButton(
                icon: flashOn ? MonAIIcons.flashOn : MonAIIcons.flashOff,
                tooltip: flashOn
                    ? l10n.receiptScanFlashOn
                    : l10n.receiptScanFlashOff,
                onPressed: onToggleFlash,
              ),
            )
          else
            const SizedBox.square(dimension: MonAISizes.touchTarget),
        ],
      ),
    );
  }
}

class ScanReceiptRoundButton extends StatelessWidget {
  const ScanReceiptRoundButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final MonAIIconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.4),
      shape: const CircleBorder(),
      clipBehavior: .antiAlias,
      child: MonAIIconButton(
        icon: icon,
        tooltip: tooltip,
        onPressed: onPressed,
        color: MonAIPalette.white,
      ),
    );
  }
}

class _Viewfinder extends StatelessWidget {
  const _Viewfinder();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      spacing: MonAISpacing.x5,
      children: [
        const Flexible(child: ScanReceiptFrame()),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: MonAIRadius.fullAll,
          ),
          child: Padding(
            padding: const .symmetric(
              horizontal: MonAISpacing.x3_5,
              vertical: MonAISpacing.x2,
            ),
            child: Text(
              context.l10n.receiptScanHint,
              style: context.textTheme.bodyMedium?.copyWith(
                color: MonAIPalette.white,
                fontWeight: .w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CameraMessage extends StatelessWidget {
  const _CameraMessage({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .symmetric(horizontal: MonAISpacing.x10),
        child: Column(
          mainAxisSize: .min,
          spacing: MonAISpacing.x3,
          children: [
            const MonAIIcon(
              MonAIIcons.photoCamera,
              size: MonAISizes.stateIcon,
              color: MonAIPalette.gray400,
            ),
            Text(
              title,
              textAlign: .center,
              style: context.textTheme.titleLarge?.copyWith(
                color: MonAIPalette.white,
              ),
            ),
            Text(
              message,
              textAlign: .center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: MonAIPalette.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.onCapture,
    required this.onPickPhoto,
    required this.onTypeInstead,
  });

  final VoidCallback onCapture;
  final VoidCallback onPickPhoto;
  final VoidCallback onTypeInstead;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        MonAISpacing.x6,
        MonAISpacing.x4,
        MonAISpacing.x6,
        MonAISpacing.x10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: .centerLeft,
              child: _GalleryButton(
                label: l10n.receiptScanGallery,
                onPressed: onPickPhoto,
              ),
            ),
          ),
          BlocSelector<ScanReceiptBloc, ScanReceiptState, bool>(
            selector: (state) => state.canCapture,
            builder: (context, canCapture) => _Shutter(
              label: l10n.receiptScanShutter,
              onPressed: canCapture ? onCapture : null,
            ),
          ),
          Expanded(
            child: Align(
              alignment: .centerRight,
              child: TextButton(
                onPressed: onTypeInstead,
                style: TextButton.styleFrom(
                  foregroundColor: MonAIPalette.lime,
                  padding: const .symmetric(vertical: MonAISpacing.x3),
                ),
                child: Text(
                  l10n.receiptScanTypeInstead,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: MonAIPalette.lime,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryButton extends StatelessWidget {
  const _GalleryButton({required this.label, required this.onPressed});

  static const _size = 52.0;

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Material(
        color: MonAIPalette.white.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: MonAIRadius.mdlAll,
          side: BorderSide(color: MonAIPalette.white.withValues(alpha: 0.3)),
        ),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Semantics(
            button: true,
            label: label,
            excludeSemantics: true,
            child: const SizedBox.square(
              dimension: _size,
              child: Center(
                child: MonAIIcon(
                  MonAIIcons.photoLibrary,
                  color: MonAIPalette.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Shutter extends StatelessWidget {
  const _Shutter({required this.label, required this.onPressed});

  static const _size = 72.0;
  static const _inner = 56.0;
  static const _ring = 4.0;

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      excludeSemantics: true,
      child: Opacity(
        opacity: onPressed == null ? 0.4 : 1,
        child: Material(
          type: .transparency,
          shape: const CircleBorder(
            side: BorderSide(color: MonAIPalette.white, width: _ring),
          ),
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: const SizedBox.square(
              dimension: _size,
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: MonAIPalette.white,
                    shape: .circle,
                  ),
                  child: SizedBox.square(dimension: _inner),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
