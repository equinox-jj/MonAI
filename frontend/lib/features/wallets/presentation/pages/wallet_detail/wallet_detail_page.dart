import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/route_path.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/bloc/wallet_detail_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/model/wallet_detail_state_extension.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/widgets/wallet_detail_actions.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/widgets/wallet_detail_buttons.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/widgets/wallet_detail_chart.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/widgets/wallet_detail_hero.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/widgets/wallet_detail_transactions.dart';

class WalletDetailPage extends StatelessWidget {
  const WalletDetailPage({
    required this.id,
    super.key,
    this.placement = ScreenPlacement.fullScreen,
  });

  final String id;
  final ScreenPlacement placement;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(id),
      create: (_) =>
          sl<WalletDetailBloc>(param1: id)
            ..add(const WalletDetailEvent.started()),
      child: WalletDetailUI(placement: placement),
    );
  }
}

class WalletDetailUI extends StatelessWidget {
  const WalletDetailUI({
    super.key,
    this.placement = ScreenPlacement.fullScreen,
  });

  final ScreenPlacement placement;

  String _id(BuildContext context) => context.read<WalletDetailBloc>().state.id;

  void _edit(BuildContext context) =>
      context.push(AppRoutes.walletEdit(_id(context)));

  void _transfer(BuildContext context) => context.push(
    AppRoutes.newTransaction(type: 'transfer', walletId: _id(context)),
  );

  void _archive(BuildContext context) => context.read<WalletDetailBloc>().add(
    const WalletDetailEvent.archiveRequested(),
  );

  void _setDefault(BuildContext context) => context
      .read<WalletDetailBloc>()
      .add(const WalletDetailEvent.setDefaultRequested());

  void _openTransaction(BuildContext context, String id) =>
      context.push(AppRoutes.transactionDetail(id));

  void _retry(BuildContext context) =>
      context.read<WalletDetailBloc>().add(const WalletDetailEvent.refreshed());

  Future<void> _pullToRefresh(BuildContext context) async {
    final bloc = context.read<WalletDetailBloc>()
      ..add(const WalletDetailEvent.refreshed());
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  void _leave(BuildContext context) {
    if (placement != .pane) context.pop();
  }

  void _onArchived(BuildContext context, WalletDetailState state) {
    final l10n = context.l10n;
    // Taken now: the snackbar outlives this screen.
    final router = GoRouter.maybeOf(context);
    showMonAISnackBar(
      context,
      message: l10n.walletArchivedSnack(state.archivedName ?? ''),
      icon: MonAIIcons.checkCircle,
      iconColor: context.colors.success,
      actionLabel: l10n.walletsViewArchived,
      onAction: () => router?.push(AppRoutes.walletsArchived),
    );
    _leave(context);
  }

  void _onGone(BuildContext context, WalletDetailState state) =>
      _leave(context);

  void _showActionFailure(BuildContext context, WalletDetailState state) {
    if (state.actionFailure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = WalletDetailActions(
      onEdit: () => _edit(context),
      onTransfer: () => _transfer(context),
      onArchive: () => _archive(context),
      onOpenTransaction: (id) => _openTransaction(context, id),
      onRetry: () => _retry(context),
    );
    return MultiBlocListener(
      listeners: [
        BlocListener<WalletDetailBloc, WalletDetailState>(
          listenWhen: (previous, current) =>
              current.archivedName != null && previous.archivedName == null,
          listener: _onArchived,
        ),
        BlocListener<WalletDetailBloc, WalletDetailState>(
          listenWhen: (previous, current) => current.isGone && !previous.isGone,
          listener: _onGone,
        ),
        BlocListener<WalletDetailBloc, WalletDetailState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: MonAITopBar(
          title: l10n.walletDetailTitle,
          placement: placement,
          titleStyle: context.textTheme.titleMedium,
          actions: [_MoreMenu(onSetDefault: () => _setDefault(context))],
        ),
        body: BlocSelector<WalletDetailBloc, WalletDetailState, UiStatus>(
          selector: (state) => state.status,
          builder: (context, status) => switch (status) {
            .initial || .loading => Center(
              child: Semantics(
                label: l10n.walletDetailLoading,
                child: const CircularProgressIndicator(),
              ),
            ),
            .failure => _LoadError(onRetry: actions.onRetry),
            .success || .empty => RefreshIndicator(
              onRefresh: () => _pullToRefresh(context),
              child: _Content(actions: actions),
            ),
          },
        ),
      ),
    );
  }
}

enum _MenuItem { setDefault }

class _MoreMenu extends StatelessWidget {
  const _MoreMenu({required this.onSetDefault});

  final VoidCallback onSetDefault;

  void _onSelected(_MenuItem item) => switch (item) {
    .setDefault => onSetDefault(),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<WalletDetailBloc, WalletDetailState, bool>(
      selector: (state) =>
          state.wallet != null && !state.wallet!.isDefault && !state.isBusy,
      builder: (context, canSetDefault) => canSetDefault
          ? PopupMenuButton<_MenuItem>(
              tooltip: l10n.walletDetailMore,
              icon: MonAIIcon(
                MonAIIcons.moreVert,
                color: context.colors.iconStrong,
              ),
              onSelected: _onSelected,
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: _MenuItem.setDefault,
                  child: Text(l10n.walletDetailMakeDefault),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const .symmetric(horizontal: MonAISpacing.x10),
        child:
            BlocSelector<
              WalletDetailBloc,
              WalletDetailState,
              (WalletFailure?, bool)
            >(
              selector: (state) => (state.loadFailure, state.isRefreshing),
              builder: (context, selected) {
                final (failure, isRetrying) = selected;
                return MonAIStateMessage(
                  icon: failure == .network
                      ? MonAIIcons.cloudOff
                      : MonAIIcons.error,
                  tone: .error,
                  title: l10n.walletDetailLoadErrorTitle,
                  message: (failure ?? .unexpected).message(l10n),
                  actionLabel: l10n.walletsRetry,
                  actionIcon: MonAIIcons.refresh,
                  actionLoading: isRetrying,
                  onAction: onRetry,
                );
              },
            ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.actions});

  final WalletDetailActions actions;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .fromLTRB(
        MonAISpacing.screenHorizontal,
        MonAISpacing.x2,
        MonAISpacing.screenHorizontal,
        MonAISpacing.x6,
      ),
      children: [
        const WalletDetailHero(),
        const SizedBox(height: MonAISpacing.x4),
        WalletDetailButtons(actions: actions),
        const SizedBox(height: MonAISpacing.x4),
        const WalletDetailChart(),
        const SizedBox(height: MonAISpacing.x4),
        WalletDetailTransactions(actions: actions),
      ],
    );
  }
}
