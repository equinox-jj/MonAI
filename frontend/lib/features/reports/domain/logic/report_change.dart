/// Which way a total moved since the month before.
enum ChangeTrend { less, same, more }

/// A change against the month before, rounded to whole percent the way the
/// report shows it.
class ReportChange {
  const ReportChange._(this.trend, this.percent);

  /// The change for [changePercent]; null when the month before had nothing
  /// to compare with. A change that rounds to 0% is [ChangeTrend.same].
  static ReportChange? of(double? changePercent) {
    if (changePercent == null) return null;
    final percent = changePercent.abs().round();
    final trend = percent == 0
        ? ChangeTrend.same
        : changePercent < 0
        ? ChangeTrend.less
        : ChangeTrend.more;
    return ReportChange._(trend, percent);
  }

  final ChangeTrend trend;

  /// Whole percent, without a sign.
  final int percent;

  @override
  bool operator ==(Object other) =>
      other is ReportChange && other.trend == trend && other.percent == percent;

  @override
  int get hashCode => Object.hash(trend, percent);
}
