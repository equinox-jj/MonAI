import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';

/// "Today · Sat, 10 Oct" above a day's transactions, with the day's net.
class TransactionDayHeader extends StatelessWidget {
  const TransactionDayHeader({
    required this.day,
    required this.today,
    super.key,
    this.net,
  });

  final DateTime day;
  final DateTime today;

  /// Income minus expenses; left out when null.
  final int? net;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.labelLarge?.copyWith(
      color: context.colors.textSecondary,
    );
    return Padding(
      padding: const .fromLTRB(
        MonAISpacing.screenHorizontal,
        MonAISpacing.x3,
        MonAISpacing.screenHorizontal,
        MonAISpacing.x2,
      ),
      child: Row(
        spacing: MonAISpacing.x2,
        children: [
          Expanded(
            child: Text(
              TransactionDates.dayHeader(
                day,
                today,
                context.l10n,
                context.localeName,
              ),
              style: style,
              maxLines: 1,
              overflow: .ellipsis,
            ),
          ),
          if (net case final net?) Text(formatRupiah(net), style: style),
        ],
      ),
    );
  }
}
