import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/designsystem.dart';

/// A dev-only page showing every token and component, with a light/dark
/// toggle. Copy is hard-coded English on purpose: it never ships to users.
class DesignSystemGalleryPage extends StatefulWidget {
  /// Creates the gallery.
  const DesignSystemGalleryPage({super.key});

  @override
  State<DesignSystemGalleryPage> createState() =>
      _DesignSystemGalleryPageState();
}

class _DesignSystemGalleryPageState extends State<DesignSystemGalleryPage> {
  /// Null follows the platform brightness until the user toggles.
  final _dark = ValueNotifier<bool?>(null);
  final _tab = ValueNotifier(0);
  final _loading = ValueNotifier(false);
  final _type = ValueNotifier('expense');
  final _filter = ValueNotifier(true);
  final _theme = ValueNotifier('system');

  @override
  void dispose() {
    _dark.dispose();
    _tab.dispose();
    _loading.dispose();
    _type.dispose();
    _filter.dispose();
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _dark,
      builder: (context, darkOverride, _) {
        final dark =
            darkOverride ??
            MediaQuery.platformBrightnessOf(context) == Brightness.dark;
        return Theme(
          data: dark ? MonAITheme.dark() : MonAITheme.light(),
          child: Scaffold(
            appBar: MonAITopBar(
              title: 'Design system',
              navigation: .none,
              actions: [
                MonAIIconButton(
                  icon: dark ? MonAIIcons.lightMode : MonAIIcons.darkMode,
                  tooltip: dark ? 'Light theme' : 'Dark theme',
                  onPressed: () => _dark.value = !dark,
                ),
              ],
            ),
            body: _GalleryBody(
              loading: _loading,
              type: _type,
              filter: _filter,
              theme: _theme,
            ),
            bottomNavigationBar: _GalleryBottomBar(tab: _tab),
          ),
        );
      },
    );
  }
}

class _GalleryBottomBar extends StatelessWidget {
  const _GalleryBottomBar({required this.tab});

  final ValueNotifier<int> tab;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: tab,
      builder: (context, selected, _) => MonAIBottomBar(
        items: MonAINavItem.main(
          home: 'Home',
          transactions: 'Transactions',
          wallets: 'Wallets',
          settings: 'Settings',
        ),
        selectedIndex: selected,
        onSelect: (i) => tab.value = i,
        onAdd: () => showMonAISnackBar(
          context,
          message: 'Add tapped',
          icon: MonAIIcons.checkCircle,
          iconColor: context.colors.success,
        ),
        addLabel: 'Add transaction',
      ),
    );
  }
}

class _GalleryBody extends StatelessWidget {
  const _GalleryBody({
    required this.loading,
    required this.type,
    required this.filter,
    required this.theme,
  });

  final ValueNotifier<bool> loading;
  final ValueNotifier<String> type;
  final ValueNotifier<bool> filter;
  final ValueNotifier<String> theme;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const .all(MonAISpacing.screenHorizontal),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              const _Section(title: 'Colors', child: _ColorSwatches()),
              const _Section(title: 'Typography', child: _TypeScale()),
              _Section(
                title: 'Buttons',
                child: _Buttons(loading: loading),
              ),
              const _Section(title: 'Fields', child: _Fields()),
              const _Section(title: 'Surfaces', child: _Surfaces()),
              const _Section(title: 'Badges', child: _Badges()),
              _Section(
                title: 'Selection',
                child: _Selection(type: type, filter: filter),
              ),
              _Section(
                title: 'Lists',
                child: _Lists(theme: theme),
              ),
              const _Section(title: 'Feedback', child: _Feedback()),
              const _Section(title: 'States', child: _States()),
              const _Section(title: 'Icons', child: SizedBox.shrink()),
            ]),
          ),
        ),
        SliverPadding(
          padding: const .fromLTRB(
            MonAISpacing.screenHorizontal,
            0,
            MonAISpacing.screenHorizontal,
            MonAISpacing.x10,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 56,
              mainAxisSpacing: MonAISpacing.x2,
              crossAxisSpacing: MonAISpacing.x2,
            ),
            itemCount: MonAIIcons.all.length,
            itemBuilder: (context, i) => Tooltip(
              message: MonAIIcons.all[i].name,
              child: Center(
                child: MonAIIcon(
                  MonAIIcons.all[i],
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: MonAISpacing.x8),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.sectionContentGap,
        children: [
          MonAISectionHeader(title: title),
          child,
        ],
      ),
    );
  }
}

class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final swatches = [
      ('primary', c.primary),
      ('accent', c.accent),
      ('primaryContainer', c.primaryContainer),
      ('highlight', c.highlight),
      ('background', c.background),
      ('surface', c.surface),
      ('surfaceSunken', c.surfaceSunken),
      ('textPrimary', c.textPrimary),
      ('textSecondary', c.textSecondary),
      ('textTertiary', c.textTertiary),
      ('border', c.border),
      ('borderStrong', c.borderStrong),
      ('expense', c.expense),
      ('income', c.income),
      ('warning', c.warning),
      ('error', c.error),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        mainAxisSpacing: MonAISpacing.x2,
        crossAxisSpacing: MonAISpacing.x2,
        childAspectRatio: 1.4,
      ),
      itemCount: swatches.length,
      itemBuilder: (context, i) {
        final (name, color) = swatches[i];
        return Column(
          crossAxisAlignment: .start,
          spacing: MonAISpacing.x1,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: MonAIRadius.mdAll,
                  border: Border.all(color: c.border),
                ),
                child: const SizedBox.expand(),
              ),
            ),
            Text(
              name,
              style: context.textTheme.bodySmall,
              maxLines: 1,
              overflow: .ellipsis,
            ),
          ],
        );
      },
    );
  }
}

class _TypeScale extends StatelessWidget {
  const _TypeScale();

  @override
  Widget build(BuildContext context) {
    final t = context.textTheme;
    final s = context.textStyles;
    final styles = [
      ('displayLarge', t.displayLarge),
      ('displayMedium', t.displayMedium),
      ('headlineLarge', t.headlineLarge),
      ('headlineMedium', t.headlineMedium),
      ('headlineSmall', t.headlineSmall),
      ('titleLarge', t.titleLarge),
      ('titleMedium', t.titleMedium),
      ('titleSmall', t.titleSmall),
      ('bodyLarge', t.bodyLarge),
      ('bodyMedium', t.bodyMedium),
      ('bodySmall', t.bodySmall),
      ('labelLarge', t.labelLarge),
      ('labelMedium', t.labelMedium),
      ('labelSmall', t.labelSmall),
      ('amountLarge Rp 12.450.000', s.amountLarge),
      ('amount −Rp 35.000', s.amount),
      ('bodyCompact', s.bodyCompact),
      ('OVERLINE', s.overline),
    ];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: styles.length,
      itemBuilder: (context, i) => Text(
        styles[i].$1,
        style: styles[i].$2?.copyWith(color: context.colors.textPrimary),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({required this.loading});

  final ValueNotifier<bool> loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3,
      children: [
        MonAIButton(label: 'Sign in', onPressed: () {}, expand: true),
        MonAIButton(
          label: 'Save expense',
          onPressed: () {},
          leadingIcon: MonAIIcons.check,
          expand: true,
        ),
        const MonAIButton(label: 'Disabled', onPressed: null, expand: true),
        Wrap(
          spacing: MonAISpacing.x2,
          runSpacing: MonAISpacing.x2,
          crossAxisAlignment: .center,
          children: [
            ValueListenableBuilder(
              valueListenable: loading,
              builder: (context, isLoading, _) => MonAIButton(
                label: isLoading ? 'Trying…' : 'Try again',
                onPressed: () => loading.value = !isLoading,
                size: .medium,
                loading: isLoading,
              ),
            ),
            MonAIButton(
              label: 'New wallet',
              onPressed: () {},
              variant: .outlined,
              size: .medium,
              leadingIcon: MonAIIcons.add,
            ),
            MonAIButton(
              label: 'Scan',
              onPressed: () {},
              variant: .tonal,
              size: .small,
              leadingIcon: MonAIIcons.documentScanner,
            ),
            MonAIButton(
              label: 'Cancel',
              onPressed: () {},
              variant: .text,
              size: .compact,
            ),
            MonAIButton(
              label: 'Delete',
              onPressed: () {},
              variant: .destructive,
              size: .compact,
            ),
          ],
        ),
        Row(
          spacing: MonAISpacing.x2,
          children: [
            MonAIIconButton(
              icon: MonAIIcons.arrowBack,
              tooltip: 'Back',
              onPressed: () {},
            ),
            MonAIIconButton(
              icon: MonAIIcons.search,
              tooltip: 'Search',
              onPressed: () {},
              style: .surface,
            ),
            MonAIIconButton(
              icon: MonAIIcons.documentScanner,
              tooltip: 'Scan receipt',
              onPressed: () {},
              style: .tonal,
              size: MonAISizes.quickAddField,
            ),
            MonAIIconButton(
              icon: MonAIIcons.delete,
              tooltip: 'Delete',
              onPressed: () {},
              color: context.colors.error,
            ),
          ],
        ),
      ],
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x4,
      children: [
        const MonAITextField(
          label: 'Email',
          placeholder: 'you@example.com',
          leadingIcon: MonAIIcons.mail,
          keyboardType: TextInputType.emailAddress,
        ),
        const MonAIPasswordField(
          label: 'Password',
          placeholder: 'Your password',
          supportingText: 'At least 8 characters',
          tone: .success,
          showPasswordLabel: 'Show password',
          hidePasswordLabel: 'Hide password',
        ),
        MonAITextField(
          label: 'Email',
          supportingText: 'This email is already registered.',
          supportingLinkLabel: 'Sign in instead',
          onSupportingLinkTap: () {},
          tone: .error,
        ),
        const MonAITextField(
          placeholder: 'Add a note (optional)',
          leadingIcon: MonAIIcons.editNote,
          compact: true,
        ),
        const MonAISearchField(
          placeholder: 'Search transactions',
          clearLabel: 'Clear search',
        ),
        MonAIPillField(
          text: 'makan siang 35rb pakai gopay',
          leadingIcon: MonAIIcons.autoAwesome,
          leadingIconColor: context.colors.accent,
          height: MonAISizes.quickAddField,
          onTap: () {},
        ),
        Row(
          spacing: MonAISpacing.x2,
          children: [
            Expanded(
              child: MonAISelectField(
                value: 'BCA Tabungan',
                leadingIcon: MonAIIcons.accountBalance,
                showChevron: true,
                onTap: () {},
              ),
            ),
            Expanded(
              child: MonAISelectField(
                value: 'GoPay',
                label: 'To',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Surfaces extends StatelessWidget {
  const _Surfaces();

  @override
  Widget build(BuildContext context) {
    final t = context.textTheme;
    final c = context.colors;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x4,
      children: [
        MonAIGradientCard(
          child: Column(
            crossAxisAlignment: .start,
            spacing: MonAISpacing.x4,
            children: [
              Text(
                'Total balance · 4 wallets',
                style: t.bodyMedium
                    ?.withWeight(.w500)
                    .copyWith(color: c.onGradientMuted),
              ),
              Text(
                'Rp 12.450.000',
                style: t.displayMedium?.tabular.copyWith(color: Colors.white),
              ),
              const MonAIPill(text: '10% less spent than September'),
            ],
          ),
        ),
        SizedBox(
          height: MonAISizes.walletCardHeight,
          child: MonAIGradientCard(
            gradient: WalletGradients.eWallet(dark: c.isDark).gradient,
            borderRadius: MonAIRadius.lgAll,
            padding: const .all(MonAISpacing.x4),
            elevated: false,
            decorated: false,
            onTap: () {},
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .spaceBetween,
              children: [
                Row(
                  spacing: MonAISpacing.x2_5,
                  children: [
                    MonAIMonogram(
                      text: 'GP',
                      contentColor: WalletGradients.eWallet(dark: c.isDark)
                          .start,
                    ),
                    Text(
                      'GoPay',
                      style: t.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  'Rp 1.185.000',
                  style: context.textStyles.amountLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        MonAICard(
          onTap: () {},
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x3,
            children: [
              Text('October budget', style: t.titleMedium),
              MonAIProgressBar(progress: 0.8, color: c.warning),
            ],
          ),
        ),
        MonAISectionHeader(
          title: 'Wallets',
          actionLabel: 'See all',
          onActionPressed: () {},
        ),
        const MonAIScreenTitle(title: 'Transactions'),
        const MonAIDivider(),
      ],
    );
  }
}

class _Badges extends StatelessWidget {
  const _Badges();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Wrap(
      spacing: MonAISpacing.x2,
      runSpacing: MonAISpacing.x2,
      crossAxisAlignment: .center,
      children: [
        const MonAITag(text: 'Admin'),
        const MonAIPill(text: 'Default'),
        MonAIPill(
          text: 'Expense',
          icon: MonAIIcons.northEast,
          containerColor: c.expenseContainer,
          contentColor: c.isDark ? c.expense : c.errorText,
        ),
        const MonAIAvatar(initials: 'JP'),
        const MonAIAvatar(initials: 'JP', size: MonAISizes.avatarXLarge),
        MonAIMonogram(
          text: 'BCA',
          containerColor: c.primaryContainer,
          contentColor: c.accent,
          size: MonAISizes.avatarMedium,
        ),
      ],
    );
  }
}

class _Selection extends StatelessWidget {
  const _Selection({required this.type, required this.filter});

  final ValueNotifier<String> type;
  final ValueNotifier<bool> filter;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3,
      children: [
        ValueListenableBuilder(
          valueListenable: type,
          builder: (context, selected, _) => MonAISegmentedControl<String>(
            segments: [
              MonAISegment(
                value: 'expense',
                label: 'Expense',
                selectedContainer: c.expenseContainer,
                selectedContent: c.expense,
              ),
              MonAISegment(
                value: 'income',
                label: 'Income',
                selectedContainer: c.incomeContainer,
                selectedContent: c.income,
              ),
              const MonAISegment(value: 'transfer', label: 'Transfer'),
            ],
            selected: selected,
            onChanged: (v) => type.value = v,
          ),
        ),
        Wrap(
          spacing: MonAISpacing.x2,
          children: [
            ValueListenableBuilder(
              valueListenable: filter,
              builder: (context, selected, _) => MonAIFilterChip(
                label: 'This month',
                selected: selected,
                onTap: () => filter.value = !selected,
              ),
            ),
            MonAIFilterChip(
              label: 'Category',
              selected: false,
              hasDropdown: true,
              onTap: () {},
            ),
          ],
        ),
        const Center(child: MonAIPageIndicator(pageCount: 3, currentPage: 1)),
      ],
    );
  }
}

class _Lists extends StatelessWidget {
  const _Lists({required this.theme});

  final ValueNotifier<String> theme;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const food = Color(0xFFF97316);
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x4,
      children: [
        MonAICard(
          padding: .zero,
          child: MonAIListItem(
            title: 'Makan siang',
            supporting: 'Food · GoPay · 12:40',
            onTap: () {},
            leading: Container(
              width: MonAISizes.avatarMedium,
              height: MonAISizes.avatarMedium,
              alignment: .center,
              decoration: BoxDecoration(
                color: CategoryColors.tint(food, dark: c.isDark),
                shape: .circle,
              ),
              child: MonAIIcon(
                categoryIcon('restaurant'),
                size: MonAISizes.iconLg,
                color: CategoryColors.content(food, dark: c.isDark),
              ),
            ),
            trailing: Text(
              '−Rp 35.000',
              style: context.textStyles.amount.copyWith(color: c.expense),
            ),
          ),
        ),
        MonAISettingsGroup(
          title: 'Preferences',
          footer: 'Applies on this device only.',
          children: [
            MonAISettingsRow(
              label: 'Language',
              icon: MonAIIcons.translate,
              value: 'Bahasa Indonesia',
              onTap: () {},
            ),
            MonAISettingsRow(
              label: 'Delete account',
              icon: MonAIIcons.personRemove,
              destructive: true,
              showDivider: false,
              onTap: () {},
            ),
          ],
        ),
        _ThemeOptions(theme: theme),
      ],
    );
  }
}

class _ThemeOptions extends StatelessWidget {
  const _ThemeOptions({required this.theme});

  final ValueNotifier<String> theme;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: theme,
      builder: (context, selected, _) => Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x4,
        children: [
          MonAIRadioOption(
            title: 'System',
            subtitle: 'Follow the device setting',
            tag: 'Default',
            selected: selected == 'system',
            onTap: () => theme.value = 'system',
          ),
          MonAIRadioOption(
            title: 'Dark',
            selected: selected == 'dark',
            onTap: () => theme.value = 'dark',
          ),
        ],
      ),
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3,
      children: [
        const MonAIInlineAlert(message: "We'll set up a Cash wallet for you."),
        const MonAIInlineAlert(
          message: 'Wrong email or password.',
          tone: .error,
        ),
        const MonAIInlineAlert(message: 'Budget almost used.', tone: .warning),
        const MonAIStatusStrip(
          title: "You're offline",
          detail: 'Showing saved data',
        ),
        Wrap(
          spacing: MonAISpacing.x2,
          runSpacing: MonAISpacing.x2,
          children: [
            MonAIButton(
              label: 'Snackbar',
              size: .small,
              variant: .tonal,
              onPressed: () => showMonAISnackBar(
                context,
                message: 'Transaction deleted',
                actionLabel: 'Undo',
                onAction: () {},
              ),
            ),
            MonAIButton(
              label: 'Dialog',
              size: .small,
              variant: .tonal,
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => MonAIAlertDialog(
                  title: 'Delete wallet?',
                  message: 'Its transactions will be deleted too.',
                  icon: MonAIIcons.delete,
                  tone: .error,
                  destructive: true,
                  confirmLabel: 'Delete',
                  dismissLabel: 'Cancel',
                  onConfirm: () => Navigator.pop(context),
                ),
              ),
            ),
            MonAIButton(
              label: 'Sheet',
              size: .small,
              variant: .tonal,
              onPressed: () => showMonAIBottomSheet<void>(
                context,
                title: 'Choose wallet',
                builder: (context) => MonAISheetButtons(
                  secondaryLabel: 'Cancel',
                  onSecondary: () => Navigator.pop(context),
                  primaryLabel: 'Apply',
                  onPrimary: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _States extends StatelessWidget {
  const _States();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x6,
      children: [
        MonAIStateMessage(
          icon: MonAIIcons.receiptLong,
          title: 'No transactions yet',
          message: 'Add your first expense to see it here.',
          actionLabel: 'Add transaction',
          actionIcon: MonAIIcons.add,
          onAction: () {},
        ),
        MonAIStateMessage(
          icon: MonAIIcons.cloudOff,
          title: "Couldn't load",
          message: 'Something went wrong on our side.',
          tone: .error,
          actionLabel: 'Try again',
          onAction: () {},
          footnote: 'Error code: internal_error',
        ),
        const Row(
          spacing: MonAISpacing.x3,
          children: [
            MonAISkeleton(
              height: MonAISizes.avatarMedium,
              width: MonAISizes.avatarMedium,
              borderRadius: MonAIRadius.fullAll,
            ),
            Expanded(
              child: Column(
                spacing: MonAISpacing.x2,
                children: [
                  MonAISkeleton(height: 14),
                  MonAISkeleton(height: 10, width: 120),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
