import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

class TransactionDetailReceipt extends StatelessWidget {
  const TransactionDetailReceipt({
    required this.url,
    required this.onView,
    super.key,
  });

  final String url;
  final VoidCallback onView;

  static const _thumbnailSize = Size(64, 84);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return MonAICard(
      onTap: onView,
      padding: const .all(MonAISpacing.x3),
      child: Row(
        spacing: MonAISpacing.x3,
        children: [
          ClipRRect(
            borderRadius: MonAIRadius.smAll,
            child: CachedNetworkImage(
              imageUrl: url,
              width: _thumbnailSize.width,
              height: _thumbnailSize.height,
              fit: .cover,
              placeholder: (_, _) => ColoredBox(color: c.surfaceSunken),
              errorWidget: (_, _, _) => ColoredBox(
                color: c.surfaceSunken,
                child: Center(
                  child: MonAIIcon(
                    MonAIIcons.image,
                    size: MonAISizes.iconMd,
                    color: c.textTertiary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: MonAISpacing.x0_5,
              children: [
                Text(
                  l10n.transactionDetailReceipt,
                  style: context.textTheme.titleSmall,
                ),
                Text(
                  l10n.transactionDetailReceiptNote,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: c.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          MonAIButton(
            label: l10n.transactionDetailViewReceipt,
            onPressed: onView,
            variant: .outlined,
            size: .small,
          ),
        ],
      ),
    );
  }
}

class TransactionReceiptViewer extends StatelessWidget {
  const TransactionReceiptViewer({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: Colors.black,
      // The body's constraints are loose; without the expand the stack
      // shrinks to the close button and the photo with it.
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                maxScale: 5,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: .contain,
                    placeholder: (_, _) =>
                        const CircularProgressIndicator(color: Colors.white),
                    errorWidget: (_, _, _) => Text(
                      l10n.transactionDetailReceiptError,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: MonAIIconButton(
                icon: MonAIIcons.close,
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
