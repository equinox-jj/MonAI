import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/bloc/wallet_detail_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/model/wallet_detail_state_extension.dart';

class WalletDetailChart extends StatelessWidget {
  const WalletDetailChart({super.key});

  static const _chartHeight = 110.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final locale = context.localeName;
    return BlocSelector<
      WalletDetailBloc,
      WalletDetailState,
      (DateTime, List<int>, int)
    >(
      selector: (state) =>
          (state.month, state.dailyOutflows, state.monthOutflow),
      builder: (context, selected) {
        final (month, days, total) = selected;
        final monthName = DateFormat.MMMM(locale).format(month);
        return MonAICard(
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x3,
            children: [
              Row(
                crossAxisAlignment: .baseline,
                textBaseline: .alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      l10n.walletDetailMoneyOut(monthName),
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    total == 0
                        ? formatRupiah(0)
                        : formatRupiahSigned(total, negative: true),
                    style: context.textTheme.labelLarge?.tabular.copyWith(
                      color: total == 0 ? c.textTertiary : c.expense,
                    ),
                  ),
                ],
              ),
              Semantics(
                image: true,
                label: l10n.walletDetailChartLabel(monthName),
                child: SizedBox(
                  height: _chartHeight,
                  child: CustomPaint(
                    painter: _BarsPainter(
                      days: days,
                      barColor: c.primaryContainerBorder,
                      highlightColor: c.accent,
                      emptyColor: c.border,
                      baselineColor: c.border,
                    ),
                  ),
                ),
              ),
              if (days.isNotEmpty)
                DefaultTextStyle.merge(
                  style: context.textTheme.labelSmall
                      ?.withWeight(.w400)
                      .copyWith(color: c.textTertiary),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      _DayLabel(month: month, day: 1),
                      if (days.length > 2)
                        _DayLabel(month: month, day: (days.length + 1) ~/ 2),
                      if (days.length > 1)
                        _DayLabel(month: month, day: days.length),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DayLabel extends StatelessWidget {
  const _DayLabel({required this.month, required this.day});

  final DateTime month;
  final int day;

  @override
  Widget build(BuildContext context) => Text(
    DateFormat(
      'd MMM',
      context.localeName,
    ).format(DateTime(month.year, month.month, day)),
  );
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({
    required this.days,
    required this.barColor,
    required this.highlightColor,
    required this.emptyColor,
    required this.baselineColor,
  });

  final List<int> days;
  final Color barColor;
  final Color highlightColor;
  final Color emptyColor;
  final Color baselineColor;

  static const _gap = 6.0;
  static const _emptyHeight = 3.0;
  static const _corner = Radius.circular(4);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      Paint()..color = baselineColor,
    );
    if (days.isEmpty) return;
    final max = days.reduce((a, b) => a > b ? a : b);
    final gap = days.length > 20 ? _gap / 2 : _gap;
    final width = (size.width - gap * (days.length - 1)) / days.length;
    for (var i = 0; i < days.length; i++) {
      final value = days[i];
      final height = value == 0 || max == 0
          ? _emptyHeight
          : size.height * value / max;
      final color = value == 0
          ? emptyColor
          : i == days.length - 1
          ? highlightColor
          : barColor;
      final left = i * (width + gap);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(left, size.height - height, width, height),
          topLeft: _corner,
          topRight: _corner,
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_BarsPainter old) =>
      old.days != days ||
      old.barColor != barColor ||
      old.highlightColor != highlightColor;
}
