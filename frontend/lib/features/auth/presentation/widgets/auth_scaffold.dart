import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/features/auth/presentation/widgets/auth_hero_panel.dart';

/// The phone form's width cap (tablet portrait) and the tablet card's width.
const _formWidth = 480.0;

const _logoTileSize = 56.0;
const _logoIconSize = 30.0;
const _tabletSubmitMinWidth = 160.0;

/// Frame shared by Sign in and Register. Both are root screens, so neither
/// has a back button.
///
/// Compact and medium widths: [fields] at the top and [actions] pinned to
/// the bottom, scrolling together when the keyboard leaves too little room.
/// Expanded: the gradient hero on the left, and [fields] plus [actions] in a
/// card on the right.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({required this.fields, required this.actions, super.key});

  /// The header, banner and inputs, spaced evenly.
  final List<Widget> fields;

  /// Usually [AuthActions].
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return context.widthClass == .expanded
        ? _ExpandedAuthScaffold(fields: fields, actions: actions)
        : _CompactAuthScaffold(fields: fields, actions: actions);
  }
}

class _CompactAuthScaffold extends StatelessWidget {
  const _CompactAuthScaffold({required this.fields, required this.actions});

  final List<Widget> fields;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Fills the viewport so the actions sit at the bottom, and grows
            // past it to scroll when the keyboard is up.
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: .topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _formWidth),
                  child: Padding(
                    padding: const .fromLTRB(
                      MonAISpacing.screenHorizontalWide,
                      MonAISpacing.x4,
                      MonAISpacing.screenHorizontalWide,
                      MonAISpacing.x8,
                    ),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        Column(
                          crossAxisAlignment: .stretch,
                          spacing: MonAISpacing.x5,
                          children: fields,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const .only(top: MonAISpacing.x5),
                          child: actions,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedAuthScaffold extends StatelessWidget {
  const _ExpandedAuthScaffold({required this.fields, required this.actions});

  final List<Widget> fields;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: Row(
        crossAxisAlignment: .stretch,
        children: [
          const Expanded(child: AuthHeroPanel()),
          Expanded(
            child: SafeArea(
              left: false,
              child: Center(
                child: SingleChildScrollView(
                  padding: const .all(MonAISpacing.x8),
                  child: Container(
                    width: _formWidth,
                    padding: const .all(MonAISpacing.x10),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: MonAIRadius.xxlAll,
                      border: Border.all(color: c.border),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0F101828),
                          blurRadius: 24,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      spacing: MonAISpacing.x5,
                      children: [
                        ...fields,
                        Padding(
                          padding: const .only(top: MonAISpacing.x2),
                          child: actions,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The gradient wallet tile above the Sign in title (phone only).
class AuthLogoTile extends StatelessWidget {
  const AuthLogoTile({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Align(
      alignment: .centerLeft,
      child: ExcludeSemantics(
        child: Container(
          width: _logoTileSize,
          height: _logoTileSize,
          alignment: .center,
          decoration: BoxDecoration(
            gradient: c.heroGradient,
            borderRadius: MonAIRadius.xlAll,
            boxShadow: const [
              BoxShadow(
                color: Color(0x474A45D6),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: MonAIIcon(
            MonAIIcons.accountBalanceWallet,
            size: _logoIconSize,
            color: c.highlight,
          ),
        ),
      ),
    );
  }
}

/// The screen's title and the line under it.
class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: .start,
      spacing: MonAISpacing.x1_5,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: context.textTheme.headlineLarge?.copyWith(
              color: c.textPrimary,
            ),
          ),
        ),
        Text(
          subtitle,
          style: context.textTheme.titleSmall
              ?.withWeight(.w400)
              .copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}

/// The submit button and the link to the other auth screen. Compact: a
/// full-width button over a centred "New here? Create an account".
/// Expanded: the link on the left, a smaller button on the right.
class AuthActions extends StatelessWidget {
  const AuthActions({
    required this.submitLabel,
    required this.onSubmit,
    required this.loading,
    required this.prompt,
    required this.linkLabel,
    required this.onLinkTap,
    super.key,
  });

  final String submitLabel;
  final VoidCallback onSubmit;

  /// Shows a spinner on the button while a submit is running.
  final bool loading;

  /// The question before the link, e.g. "New here?"; compact only.
  final String prompt;
  final String linkLabel;
  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    if (context.widthClass == .expanded) {
      return Row(
        mainAxisAlignment: .spaceBetween,
        spacing: MonAISpacing.x3,
        children: [
          // Wraps rather than pushing the button out on long translations.
          Flexible(
            child: MonAITextLink(label: linkLabel, onPressed: onLinkTap),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: _tabletSubmitMinWidth),
            child: MonAIButton(
              label: submitLabel,
              onPressed: onSubmit,
              size: .medium,
              loading: loading,
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3,
      children: [
        MonAIButton(
          label: submitLabel,
          onPressed: onSubmit,
          loading: loading,
          expand: true,
        ),
        Row(
          mainAxisAlignment: .center,
          spacing: MonAISpacing.x1,
          children: [
            Flexible(
              child: Text(
                prompt,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
            MonAITextLink(label: linkLabel, onPressed: onLinkTap),
          ],
        ),
      ],
    );
  }
}
