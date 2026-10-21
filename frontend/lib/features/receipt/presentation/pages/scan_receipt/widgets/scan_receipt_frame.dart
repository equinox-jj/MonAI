import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';

class ScanReceiptFrame extends StatelessWidget {
  const ScanReceiptFrame({super.key});

  static const _width = 296.0;
  static const _height = 370.0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _width, maxHeight: _height),
      child: const AspectRatio(
        aspectRatio: _width / _height,
        child: CustomPaint(
          painter: _CornersPainter(),
          child: Align(
            alignment: Alignment(0, -0.08),
            child: Padding(
              padding: .symmetric(horizontal: MonAISpacing.x3),
              child: ScanReceiptScanLine(),
            ),
          ),
        ),
      ),
    );
  }
}

class ScanReceiptScanLine extends StatelessWidget {
  const ScanReceiptScanLine({super.key, this.thickness = 2});

  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: thickness,
      decoration: BoxDecoration(
        color: MonAIPalette.lime,
        borderRadius: MonAIRadius.xsAll,
        boxShadow: [
          BoxShadow(
            color: MonAIPalette.lime.withValues(alpha: 0.55),
            blurRadius: 16,
            spreadRadius: 4,
          ),
        ],
      ),
    );
  }
}

class _CornersPainter extends CustomPainter {
  const _CornersPainter();

  static const _length = 40.0;
  static const _stroke = 4.0;
  static const _radius = MonAIRadius.lg;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MonAIPalette.lime
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;
    const inset = _stroke / 2;
    final right = size.width - inset;
    final bottom = size.height - inset;
    final corners = Path()
      ..moveTo(inset, _length)
      ..lineTo(inset, _radius)
      ..arcToPoint(
        const Offset(_radius, inset),
        radius: const Radius.circular(_radius),
      )
      ..lineTo(_length, inset)
      ..moveTo(right - _length, inset)
      ..lineTo(right - _radius, inset)
      ..arcToPoint(
        Offset(right, _radius),
        radius: const Radius.circular(_radius),
      )
      ..lineTo(right, _length)
      ..moveTo(right, bottom - _length)
      ..lineTo(right, bottom - _radius)
      ..arcToPoint(
        Offset(right - _radius, bottom),
        radius: const Radius.circular(_radius),
      )
      ..lineTo(right - _length, bottom)
      ..moveTo(_length, bottom)
      ..lineTo(_radius, bottom)
      ..arcToPoint(
        Offset(inset, bottom - _radius),
        radius: const Radius.circular(_radius),
      )
      ..lineTo(inset, bottom - _length);
    canvas.drawPath(corners, paint);
  }

  @override
  bool shouldRepaint(_CornersPainter oldDelegate) => false;
}
