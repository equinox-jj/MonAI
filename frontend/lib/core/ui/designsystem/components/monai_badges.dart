import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icon.dart';
import 'package:monai/core/ui/designsystem/icons/monai_icons.dart';
import 'package:monai/core/ui/designsystem/theme/monai_category_colors.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/ui/designsystem/theme/monai_typography.dart';

class MonAITag extends StatelessWidget {
  const MonAITag({
    required this.text,
    super.key,
    this.containerColor,
    this.contentColor,
  });

  final String text;
  final Color? containerColor;
  final Color? contentColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: containerColor ?? c.primaryContainer,
        borderRadius: MonAIRadius.xsAll,
      ),
      child: Padding(
        padding: const .symmetric(
          horizontal: MonAISpacing.x1_5,
          vertical: MonAISpacing.x0_5,
        ),
        child: Text(
          text.toUpperCase(),
          style: context.textTheme.labelSmall?.copyWith(
            letterSpacing: 0.5,
            color: contentColor ?? c.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class MonAIPill extends StatelessWidget {
  const MonAIPill({
    required this.text,
    super.key,
    this.icon,
    this.containerColor,
    this.contentColor,
  });

  final String text;
  final MonAIIconData? icon;
  final Color? containerColor;
  final Color? contentColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final content = contentColor ?? c.onHighlight;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: containerColor ?? c.highlight,
        borderRadius: MonAIRadius.fullAll,
      ),
      child: Padding(
        padding: const .symmetric(
          horizontal: MonAISpacing.x2_5,
          vertical: MonAISpacing.x1,
        ),
        child: Row(
          mainAxisSize: .min,
          spacing: MonAISpacing.x1_5,
          children: [
            if (icon case final icon?)
              MonAIIcon(icon, size: MonAISizes.iconXs, color: content),
            Flexible(
              child: Text(
                text,
                textAlign: .center,
                style: context.textTheme.labelMedium?.copyWith(color: content),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonAICategoryTypePill extends StatelessWidget {
  const MonAICategoryTypePill({
    required this.type,
    required this.label,
    super.key,
  });

  final CategoryType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (container, content, arrow) = switch (type) {
      .expense => (c.expenseContainer, c.expense, MonAIIcons.northEast),
      .income => (c.incomeContainer, c.income, MonAIIcons.southWest),
    };
    return MonAIPill(
      text: label,
      icon: arrow,
      containerColor: container,
      contentColor: content,
    );
  }
}

/// The initials stay while the photo loads and when it fails (presigned URLs
/// expire).
class MonAIAvatar extends StatelessWidget {
  const MonAIAvatar({
    required this.initials,
    super.key,
    this.size = MonAISizes.avatarLarge,
    this.imageUrl,
  });

  final String initials;
  final double size;
  final String? imageUrl;

  /// The URL without its query: the backend signs it again on every `GET /me`,
  /// so only the query changes between refreshes; a new photo gets a new path.
  static String cacheKey(String url) => url.split('?').first;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fontSize = size * 0.34;
    final initialsText = Center(
      child: Text(
        initials,
        style: context.textTheme.titleMedium
            ?.withWeight(.w700)
            .copyWith(fontSize: fontSize, height: 1, color: c.accent),
      ),
    );
    return SizedBox.square(
      dimension: size,
      child: ClipOval(
        child: ColoredBox(
          color: c.primaryContainer,
          child: switch (imageUrl) {
            null => initialsText,
            final url => CachedNetworkImage(
              imageUrl: url,
              cacheKey: cacheKey(url),
              fit: .cover,
              placeholder: (_, _) => initialsText,
              errorWidget: (_, _, _) => initialsText,
            ),
          },
        ),
      ),
    );
  }
}

class MonAIMonogram extends StatelessWidget {
  const MonAIMonogram({
    required this.text,
    super.key,
    this.containerColor = Colors.white,
    this.contentColor,
    this.size = MonAISizes.avatarSmall,
  });

  final String text;
  final Color containerColor;
  final Color? contentColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: .center,
      decoration: BoxDecoration(color: containerColor, shape: .circle),
      child: Text(
        text,
        maxLines: 1,
        style: context.textTheme.labelSmall
            ?.withWeight(.w800)
            .copyWith(
              fontSize: 10,
              height: 1.2,
              color: contentColor ?? context.colors.heroGradientStart,
            ),
      ),
    );
  }
}

/// [color] is the category's light color (the server hex); the icon and tint
/// switch to the dark-mode shade on their own.
class MonAICategoryIcon extends StatelessWidget {
  const MonAICategoryIcon({
    required this.icon,
    required this.color,
    super.key,
    this.size = MonAISizes.avatarMedium,
  });

  final MonAIIconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = context.colors.isDark;
    return Container(
      width: size,
      height: size,
      alignment: .center,
      decoration: BoxDecoration(
        color: CategoryColors.tint(color, dark: dark),
        shape: .circle,
      ),
      child: MonAIIcon(
        icon,
        size: MonAISizes.iconLg,
        color: CategoryColors.content(color, dark: dark),
      ),
    );
  }
}
