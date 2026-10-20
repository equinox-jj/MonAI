import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/utils/monograms.dart';

/// A provider's or wallet's round logo: the image at [logoUrl], else the
/// monogram of [name].
class WalletLogo extends StatelessWidget {
  const WalletLogo({
    required this.name,
    super.key,
    this.logoUrl,
    this.size = MonAISizes.avatarMedium,
    this.containerColor,
    this.contentColor,
  });

  final String name;
  final String? logoUrl;
  final double size;
  final Color? containerColor;
  final Color? contentColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return switch (logoUrl) {
      final url? => MonAIAvatar(
        initials: walletMonogram(name),
        imageUrl: url,
        size: size,
      ),
      null => MonAIMonogram(
        text: walletMonogram(name),
        size: size,
        containerColor: containerColor ?? c.surfaceSunken,
        contentColor: contentColor ?? c.textSecondary,
      ),
    };
  }
}
