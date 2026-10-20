import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/wallets/presentation/pages/archived_wallets/bloc/archived_wallets_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/archived_wallets/widgets/archived_wallet_row.dart';

class ArchivedWalletsPage extends StatelessWidget {
  const ArchivedWalletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ArchivedWalletsBloc>()..add(const ArchivedWalletsEvent.started()),
      child: const ArchivedWalletsUI(),
    );
  }
}

/// Wallets hidden from pickers, each with "Unarchive".
class ArchivedWalletsUI extends StatelessWidget {
  const ArchivedWalletsUI({super.key});

  void _unarchive(BuildContext context, String id) => context
      .read<ArchivedWalletsBloc>()
      .add(ArchivedWalletsEvent.unarchiveRequested(id));

  void _showRestored(BuildContext context, ArchivedWalletsState state) {
    final wallet = state.restored;
    if (wallet == null) return;
    final l10n = context.l10n;
    // Taken now: the snackbar outlives this screen.
    final router = GoRouter.maybeOf(context);
    showMonAISnackBar(
      context,
      message: l10n.archivedWalletsRestored(wallet.name),
      icon: MonAIIcons.checkCircle,
      iconColor: context.colors.success,
      actionLabel: l10n.archivedWalletsView,
      onAction: () => router?.push(AppRoutes.walletDetail(wallet.id)),
    );
  }

  void _showActionFailure(BuildContext context, ArchivedWalletsState state) {
    if (state.actionFailure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return MultiBlocListener(
      listeners: [
        BlocListener<ArchivedWalletsBloc, ArchivedWalletsState>(
          listenWhen: (previous, current) =>
              current.restored != null && previous.restored == null,
          listener: _showRestored,
        ),
        BlocListener<ArchivedWalletsBloc, ArchivedWalletsState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
        ),
      ],
      child: Scaffold(
        backgroundColor: c.background,
        appBar: MonAITopBar(
          title: l10n.archivedWalletsTitle,
          titleStyle: context.textTheme.titleMedium,
        ),
        body: ListView(
          padding: const .fromLTRB(
            MonAISpacing.screenHorizontal,
            MonAISpacing.x2,
            MonAISpacing.screenHorizontal,
            MonAISpacing.x6,
          ),
          children: [
            Text(
              l10n.archivedWalletsIntro,
              style: context.textTheme.bodyMedium?.copyWith(
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: MonAISpacing.x4),
            BlocSelector<ArchivedWalletsBloc, ArchivedWalletsState, UiStatus>(
              selector: (state) => state.status,
              builder: (context, status) => switch (status) {
                .initial || .loading => const SizedBox.shrink(),
                .empty || .failure => const _Empty(),
                .success => _List(onUnarchive: (id) => _unarchive(context, id)),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.onUnarchive});

  final ValueChanged<String> onUnarchive;

  @override
  Widget build(BuildContext context) {
    return MonAICard(
      padding: .zero,
      child:
          BlocSelector<
            ArchivedWalletsBloc,
            ArchivedWalletsState,
            (List<Wallet>, Set<String>)
          >(
            selector: (state) => (state.wallets, state.restoringIds),
            builder: (context, selected) {
              final (wallets, restoringIds) = selected;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: .zero,
                itemCount: wallets.length,
                itemBuilder: (context, index) {
                  final wallet = wallets[index];
                  return ArchivedWalletRow(
                    wallet: wallet,
                    isRestoring: restoringIds.contains(wallet.id),
                    showDivider: index < wallets.length - 1,
                    onUnarchive: () => onUnarchive(wallet.id),
                  );
                },
              );
            },
          ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MonAICard(
      padding: const .symmetric(
        horizontal: MonAISpacing.x6,
        vertical: MonAISpacing.x8,
      ),
      child: MonAIStateMessage(
        icon: MonAIIcons.inventory2,
        title: l10n.archivedWalletsEmptyTitle,
        message: l10n.archivedWalletsEmptyBody,
      ),
    );
  }
}
