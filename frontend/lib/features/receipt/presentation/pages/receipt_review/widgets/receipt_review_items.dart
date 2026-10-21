import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/receipt/domain/entity/receipt_draft.dart';

class ReceiptReviewItems extends StatelessWidget {
  const ReceiptReviewItems({
    required this.items,
    required this.total,
    super.key,
  });

  final List<ReceiptItem> items;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    final shape = RoundedRectangleBorder(
      borderRadius: MonAIRadius.mdAll,
      side: BorderSide(color: c.border),
    );
    return ExpansionTile(
      initiallyExpanded: true,
      shape: shape,
      collapsedShape: shape,
      tilePadding: const .symmetric(horizontal: MonAISpacing.x3_5),
      childrenPadding: const .fromLTRB(
        MonAISpacing.x3_5,
        0,
        MonAISpacing.x3_5,
        MonAISpacing.x3,
      ),
      title: Text(l10n.receiptReviewItems(items.length), style: t.titleSmall),
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: .zero,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: MonAISpacing.x2),
          itemBuilder: (context, index) => _ItemRow(item: items[index]),
        ),
        const SizedBox(height: MonAISpacing.x2),
        Divider(height: MonAISpacing.x2, color: c.divider),
        _Line(
          label: l10n.receiptReviewItemsTotal,
          amount: formatRupiah(total),
          style: t.labelLarge?.copyWith(color: c.textPrimary),
        ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final ReceiptItem item;

  @override
  Widget build(BuildContext context) {
    final quantity = item.quantity;
    final label = quantity == null || quantity == 1
        ? item.name
        : '${item.name} × ${_quantityText(quantity)}';
    return _Line(
      label: label,
      amount: switch (item.amount) {
        final amount? => formatRupiah(amount),
        null => '–',
      },
      style: context.textTheme.bodySmall?.copyWith(
        color: context.colors.textSecondary,
      ),
    );
  }

  static String _quantityText(double quantity) =>
      quantity == quantity.roundToDouble()
      ? quantity.toInt().toString()
      : quantity.toString();
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.amount, this.style});

  final String label;
  final String amount;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: MonAISpacing.x3,
      children: [
        Expanded(child: Text(label, style: style)),
        Text(
          amount,
          style: style?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
