import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/icons/monai_icon.dart';
import 'package:monai/core/designsystem/icons/monai_icons.dart';
import 'package:monai/core/designsystem/theme/monai_radius.dart';
import 'package:monai/core/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/designsystem/theme/monai_theme_x.dart';
import 'package:monai/core/designsystem/theme/monai_typography.dart';

/// Small uppercase tag with 4 corners: "ADMIN", "DEFAULT".
class MonAITag extends StatelessWidget {
  /// Creates a tag. Defaults to light indigo.
  const MonAITag({
    required this.text,
    super.key,
    this.containerColor,
    this.contentColor,
  });

  /// The text; shown uppercase.
  final String text;

  /// Defaults to `primaryContainer`.
  final Color? containerColor;

  /// Defaults to `onPrimaryContainer`.
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

/// Rounded pill with an optional icon.
///
/// Defaults to the lime highlight used on gradients ("Default", "10% less
/// spent than September").
class MonAIPill extends StatelessWidget {
  /// Creates a pill.
  const MonAIPill({
    required this.text,
    super.key,
    this.icon,
    this.containerColor,
    this.contentColor,
  });

  /// The text.
  final String text;

  /// An icon before the text.
  final MonAIIconData? icon;

  /// Defaults to `highlight`.
  final Color? containerColor;

  /// Defaults to `onHighlight`.
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
            Text(
              text,
              style: context.textTheme.labelMedium?.copyWith(color: content),
            ),
          ],
        ),
      ),
    );
  }
}

/// Initials on a light-indigo circle, or the photo at [imageUrl] once it
/// loads.
///
/// The initials stay while it loads and when it fails (presigned URLs
/// expire). The image is cached by its URL without the query, so a refresh
/// that signs the URL again keeps showing the photo. The font size scales
/// with [size] (44 → 15, 64 → 22).
class MonAIAvatar extends StatelessWidget {
  /// Creates an avatar.
  const MonAIAvatar({
    required this.initials,
    super.key,
    this.size = MonAISizes.avatarLarge,
    this.imageUrl,
  });

  /// Shown until the photo loads.
  final String initials;

  /// The diameter.
  final double size;

  /// The photo, if the user has one.
  final String? imageUrl;

  /// The cache key for [url]: the URL without its query. The backend signs
  /// the URL again on every `GET /me`, so only the query changes between
  /// refreshes; a new photo is stored under a new path.
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

/// Wallet/provider monogram ("BCA", "GP") on a circle. Defaults to a white
/// circle for gradients.
class MonAIMonogram extends StatelessWidget {
  /// Creates a monogram.
  const MonAIMonogram({
    required this.text,
    super.key,
    this.containerColor = Colors.white,
    this.contentColor,
    this.size = MonAISizes.avatarSmall,
  });

  /// Two or three letters.
  final String text;

  /// The circle color.
  final Color containerColor;

  /// Defaults to the hero gradient's start color.
  final Color? contentColor;

  /// The diameter.
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
