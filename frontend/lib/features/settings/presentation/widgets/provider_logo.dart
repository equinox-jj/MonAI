import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/utils/monograms.dart';

/// A provider's logo: a newly picked image, the saved one, or its monogram
/// while there is none.
class ProviderLogo extends StatelessWidget {
  const ProviderLogo({
    required this.name,
    super.key,
    this.logoUrl,
    this.localPath,
    this.size = MonAISizes.avatarMedium,
    this.dimmed = false,
  });

  final String name;
  final String? logoUrl;

  /// A picked image not uploaded yet; shown over [logoUrl].
  final String? localPath;
  final double size;

  /// Faded, for an inactive provider.
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final logo = switch ((localPath, logoUrl)) {
      (final path?, _) => ClipOval(
        child: Image.file(
          File(path),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
      (null, final url?) => MonAIAvatar(
        initials: walletMonogram(name),
        imageUrl: url,
        size: size,
      ),
      (null, null) => MonAIMonogram(
        text: walletMonogram(name),
        size: size,
        containerColor: c.surfaceSunken,
        contentColor: c.textSecondary,
      ),
    };
    return Opacity(opacity: dimmed ? 0.5 : 1, child: logo);
  }
}
