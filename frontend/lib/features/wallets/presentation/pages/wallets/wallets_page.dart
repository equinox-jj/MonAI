import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/bloc/wallets_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/widgets/wallets_actions.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/widgets/wallets_detail_pane.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/widgets/wallets_header.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/widgets/wallets_list.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/widgets/wallets_states.dart';
import 'package:monai/route_path.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletsBloc>()..add(const WalletsEvent.started()),
      child: const WalletsUI(),
    );
  }
}

class WalletsUI extends StatelessWidget {
  const WalletsUI({super.key});
  static const _listPaneWidth = 420.0;

  void _addWallet(BuildContext context) => context.push(RoutePath.walletNew);

  void _openWallet(BuildContext context, String id) {
    if (context.widthClass == .expanded) {
      context.read<WalletsBloc>().add(WalletsEvent.selected(id));
    } else {
      context.push(RoutePath.walletDetail(id));
    }
  }

  void _showArchived(BuildContext context) =>
      context.push(RoutePath.walletsArchived);

  void _retry(BuildContext context) =>
      context.read<WalletsBloc>().add(const WalletsEvent.refreshed());

  Future<void> _pullToRefresh(BuildContext context) async {
    final bloc = context.read<WalletsBloc>()
      ..add(const WalletsEvent.refreshed());
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  void _showActionFailure(BuildContext context, WalletsState state) {
    final failure = state.actionFailure;
    if (failure == null) return;
    final l10n = context.l10n;
    showMonAISnackBar(
      context,
      message: failure == .network
          ? l10n.walletsRefreshFailedNetwork
          : failure.message(l10n),
      icon: failure == .network ? MonAIIcons.cloudOff : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = WalletsActions(
      onAddWallet: () => _addWallet(context),
      onOpenWallet: (id) => _openWallet(context, id),
      onShowArchived: () => _showArchived(context),
      onRetry: () => _retry(context),
    );
    final isExpanded = context.widthClass == .expanded;
    final list = RefreshIndicator(
      onRefresh: () => _pullToRefresh(context),
      child: _WalletsScrollView(actions: actions, showSelection: isExpanded),
    );
    return ColoredBox(
      color: context.colors.background,
      child: SafeArea(
        bottom: false,
        child: BlocListener<WalletsBloc, WalletsState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
          child: isExpanded
              ? Row(
                  crossAxisAlignment: .stretch,
                  children: [
                    SizedBox(width: _listPaneWidth, child: list),
                    VerticalDivider(
                      width: MonAISizes.border,
                      thickness: MonAISizes.border,
                      color: context.colors.border,
                    ),
                    const Expanded(child: WalletsDetailPane()),
                  ],
                )
              : list,
        ),
      ),
    );
  }
}

class _WalletsScrollView extends StatelessWidget {
  const _WalletsScrollView({
    required this.actions,
    required this.showSelection,
  });

  final WalletsActions actions;
  final bool showSelection;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const .fromLTRB(
            MonAISpacing.screenHorizontal,
            MonAISpacing.screenTop,
            MonAISpacing.screenHorizontal,
            MonAISpacing.x4,
          ),
          sliver: SliverToBoxAdapter(child: WalletsHeader(actions: actions)),
        ),
        BlocSelector<WalletsBloc, WalletsState, UiStatus>(
          selector: (state) => state.status,
          builder: (context, status) => switch (status) {
            .initial ||
            .loading => const SliverToBoxAdapter(child: WalletsSkeleton()),
            .failure => SliverFillRemaining(
              hasScrollBody: false,
              child: WalletsLoadError(actions: actions),
            ),
            .empty => SliverFillRemaining(
              hasScrollBody: false,
              child: WalletsEmpty(actions: actions),
            ),
            .success => WalletsListSliver(
              actions: actions,
              showSelection: showSelection,
            ),
          },
        ),
      ],
    );
  }
}
