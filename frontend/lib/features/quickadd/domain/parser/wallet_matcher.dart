import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/features/quickadd/domain/parser/text_span.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';

/// What the word before a wallet says about it: `dari bca` pays from it,
/// `ke gopay` moves money into it.
enum WalletRole { source, destination, unspecified }

/// A wallet named in lowercase quick-add text. [span] includes the marker
/// word before it.
class WalletMatch {
  const WalletMatch(this.walletId, this.span, this.role, this.confidence);

  final String walletId;
  final TextSpan span;
  final WalletRole role;
  final double confidence;
}

class _Term {
  const _Term(this.text, this.walletId, this.confidence);

  final String text;
  final String walletId;
  final double confidence;
}

/// Finds the user's wallets by name, by their provider's name and aliases,
/// and cash wallets by `cash` / `tunai`.
class WalletMatcher {
  WalletMatcher(List<Wallet> wallets, List<PaymentProvider> providers)
    // Longest first, so "bca tabungan" wins over the "bca" alias.
    : _terms = _buildTerms(wallets, providers)
        ..sort((a, b) => b.text.length.compareTo(a.text.length));

  static const named = 0.95;
  static const sharedAlias = 0.75;

  static const _cashWords = ['cash', 'tunai', 'uang tunai'];

  // The marker must end right before the wallet name.
  static final _marker = RegExp(
    r'(?<!\w)(pakai|pake|pakek|via|lewat|dari|from|with|using|pakai kartu'
    r'|ke|to|into)\s+$',
  );

  final List<_Term> _terms;

  /// Every wallet named in [text], in order.
  List<WalletMatch> findAll(String text) {
    final taken = <TextSpan>[];
    final matches = <WalletMatch>[];
    for (final term in _terms) {
      final regex = wordPattern(RegExp.escape(term.text), extra: '-');
      for (final found in regex.allMatches(text)) {
        final span = TextSpan(found.start, found.end);
        if (taken.any(span.overlaps)) continue;
        taken.add(span);
        final marker = _marker.firstMatch(text.substring(0, found.start));
        final role = marker == null
            ? WalletRole.unspecified
            : _roleOf(marker.group(1)!);
        matches.add(
          WalletMatch(
            term.walletId,
            TextSpan(marker?.start ?? found.start, found.end),
            role,
            term.confidence,
          ),
        );
      }
    }
    return matches..sort((a, b) => a.span.start.compareTo(b.span.start));
  }

  static WalletRole _roleOf(String marker) => switch (marker) {
    'ke' || 'to' || 'into' => WalletRole.destination,
    _ => WalletRole.source,
  };

  static List<_Term> _buildTerms(
    List<Wallet> wallets,
    List<PaymentProvider> providers,
  ) {
    final providersById = {for (final p in providers) p.id: p};
    final names = [
      for (final wallet in wallets)
        _Term(wallet.name.toLowerCase().trim(), wallet.id, named),
    ];
    final nameTexts = names.map((t) => t.text).toSet();
    // An alias shared by several wallets (two BCA accounts) goes to the
    // default one, less surely.
    final owners = <String, List<Wallet>>{};
    for (final wallet in wallets) {
      for (final alias in _aliasesOf(wallet, providersById)) {
        (owners[alias] ??= []).add(wallet);
      }
    }
    final aliases = [
      for (final MapEntry(key: alias, value: walletsOf) in owners.entries)
        if (!nameTexts.contains(alias))
          _Term(
            alias,
            (walletsOf.where((w) => w.isDefault).firstOrNull ?? walletsOf.first)
                .id,
            walletsOf.length == 1 ? named : sharedAlias,
          ),
    ];
    return [...names, ...aliases].where((t) => t.text.isNotEmpty).toList();
  }

  static List<String> _aliasesOf(
    Wallet wallet,
    Map<String, PaymentProvider> providersById,
  ) {
    final provider = providersById[wallet.providerId];
    return {
      ...?provider?.aliases,
      ?provider?.name,
      if (wallet.type == WalletType.cash) ..._cashWords,
    }.map((t) => t.toLowerCase().trim()).toSet().toList();
  }
}
