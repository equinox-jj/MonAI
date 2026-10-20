import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Ring segments clockwise from 12 o'clock, e.g. spending by category.
///
/// [shares] are percentages; [colors] has one color per share. Fills its
/// parent's size; put labels on top with a [Stack].
class MonAIDonut extends StatelessWidget {
  /// Creates a donut.
  const MonAIDonut({
    required this.shares,
    required this.colors,
    required this.stroke,
    super.key,
    this.semanticsLabel,
  });

  /// Each segment's percentage of the ring.
  final List<double> shares;

  /// One color per share.
  final List<Color> colors;

  /// The ring's thickness.
  final double stroke;

  /// Read out in place of the drawing.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      image: semanticsLabel != null,
      child: CustomPaint(
        painter: _DonutPainter(shares: shares, colors: colors, stroke: stroke),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.shares,
    required this.colors,
    required this.stroke,
  });

  /// Gap between segments, in degrees.
  static const _gapDegrees = 1.5;

  final List<double> shares;
  final List<Color> colors;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = size.shortestSide - stroke;
    final rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: diameter,
      height: diameter,
    );
    final gap = shares.length > 1 ? _gapDegrees : 0.0;
    var start = -90.0;
    for (var i = 0; i < shares.length; i++) {
      final sweep = shares[i] * 3.6;
      final paint = Paint()
        ..color = colors[i]
        ..style = .stroke
        ..strokeWidth = stroke;
      canvas.drawArc(
        rect,
        _radians(start),
        _radians(math.max(sweep - gap, 0)),
        false,
        paint,
      );
      start += sweep;
    }
  }

  static double _radians(double degrees) => degrees * math.pi / 180;

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.shares != shares || old.colors != colors || old.stroke != stroke;
}
