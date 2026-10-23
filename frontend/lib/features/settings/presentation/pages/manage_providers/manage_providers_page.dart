import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/presentation/model/provider_failure.dart';
import 'package:monai/features/settings/presentation/pages/manage_providers/bloc/manage_providers_bloc.dart';
import 'package:monai/features/settings/presentation/pages/manage_providers/model/manage_providers_state_extension.dart';
import 'package:monai/features/settings/presentation/pages/manage_providers/widgets/provider_list_row.dart';
import 'package:monai/route_path.dart';

class ManageProvidersPage extends StatelessWidget {
  const ManageProvidersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ManageProvidersBloc>()..add(const ManageProvidersEvent.started()),
      child: const ManageProvidersUI(),
    );
  }
}

class ManageProvidersUI extends StatelessWidget {
  const ManageProvidersUI({super.key});

  static const _readableWidth = 720.0;
  static const _fabClearance = 96.0;

  ManageProvidersBloc _bloc(BuildContext context) =>
      context.read<ManageProvidersBloc>();

  void _search(BuildContext context, String query) =>
      _bloc(context).add(ManageProvidersEvent.queryChanged(query));

  void _retry(BuildContext context) =>
      _bloc(context).add(const ManageProvidersEvent.refreshed());

  Future<void> _pullToRefresh(BuildContext context) async {
    final bloc = _bloc(context)..add(const ManageProvidersEvent.refreshed());
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  void _add(BuildContext context) => context.push(RoutePath.providerNew);

  void _edit(BuildContext context, AdminPaymentProvider provider) =>
      context.push(RoutePath.providerEdit(provider.id));

  void _showRefreshFailure(BuildContext context, ManageProvidersState state) {
    if (state.refreshFailure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<ManageProvidersBloc, ManageProvidersState>(
      listenWhen: (previous, current) =>
          current.refreshFailure != null &&
          previous.refreshFailure != current.refreshFailure,
      listener: _showRefreshFailure,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: MonAITopBar(
          title: l10n.providersTitle,
          navigationTooltip: l10n.providersBack,
          actions: [
            Padding(
              padding: const .only(right: MonAISpacing.x4),
              child: MonAITag(text: l10n.providersAdmin),
            ),
          ],
        ),
        floatingActionButton: _AddButton(onPressed: () => _add(context)),
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _readableWidth),
              child: Column(
                children: [
                  Padding(
                    padding: const .fromLTRB(
                      MonAISpacing.x4,
                      0,
                      MonAISpacing.x4,
                      MonAISpacing.x3_5,
                    ),
                    child: MonAISearchField(
                      placeholder: l10n.providersSearch,
                      clearLabel: l10n.providersSearchClear,
                      onChanged: (query) => _search(context, query),
                    ),
                  ),
                  Expanded(
                    child: _Body(
                      bottomPadding: _fabClearance,
                      onRetry: () => _retry(context),
                      onRefresh: () => _pullToRefresh(context),
                      onEdit: (provider) => _edit(context, provider),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return BlocSelector<ManageProvidersBloc, ManageProvidersState, bool>(
      selector: (state) => state.canCreate,
      builder: (context, canCreate) => canCreate
          ? FloatingActionButton.extended(
              onPressed: onPressed,
              backgroundColor: c.primary,
              foregroundColor: c.onPrimary,
              shape: const StadiumBorder(),
              icon: MonAIIcon(MonAIIcons.add, color: c.onPrimary),
              label: Text(context.l10n.providersAdd),
            )
          : const SizedBox.shrink(),
    );
  }
}

typedef _List = ({
  UiStatus status,
  List<AdminPaymentProvider> shown,
  int total,
  String query,
  bool canEdit,
  ProviderFailure? loadFailure,
});

class _Body extends StatelessWidget {
  const _Body({
    required this.bottomPadding,
    required this.onRetry,
    required this.onRefresh,
    required this.onEdit,
  });

  final double bottomPadding;
  final VoidCallback onRetry;
  final RefreshCallback onRefresh;
  final ValueChanged<AdminPaymentProvider> onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<ManageProvidersBloc, ManageProvidersState, _List>(
      selector: (state) => (
        status: state.status,
        shown: state.shown,
        total: state.providers.length,
        query: state.query,
        canEdit: state.canEdit,
        loadFailure: state.loadFailure,
      ),
      builder: (context, list) => switch (list.status) {
        .initial || .loading => const _Skeleton(),
        .failure => SingleChildScrollView(
          padding: const .symmetric(
            horizontal: MonAISpacing.x6,
            vertical: MonAISpacing.x10,
          ),
          child: MonAIStateMessage(
            icon: list.loadFailure == .network
                ? MonAIIcons.cloudOff
                : MonAIIcons.error,
            tone: .error,
            title: l10n.providersLoadErrorTitle,
            message: (list.loadFailure ?? .unexpected).message(l10n),
            actionLabel: l10n.providersRetry,
            actionIcon: MonAIIcons.refresh,
            onAction: onRetry,
          ),
        ),
        .success || .empty => RefreshIndicator(
          onRefresh: onRefresh,
          child: list.shown.isEmpty
              ? ListView(
                  padding: const .symmetric(vertical: MonAISpacing.x10),
                  children: [
                    Text(
                      list.total == 0
                          ? l10n.providersEmpty
                          : l10n.providersEmptySearch(list.query.trim()),
                      textAlign: .center,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                )
              : ListView(
                  padding: .fromLTRB(
                    MonAISpacing.x4,
                    0,
                    MonAISpacing.x4,
                    bottomPadding,
                  ),
                  children: [
                    MonAICard(
                      padding: .zero,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: .zero,
                        itemCount: list.shown.length,
                        separatorBuilder: (_, _) => const MonAIDivider(),
                        itemBuilder: (context, index) {
                          final provider = list.shown[index];
                          return ProviderListRow(
                            provider: provider,
                            onEdit: list.canEdit
                                ? () => onEdit(provider)
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      },
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  static const _rows = 8;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const .symmetric(horizontal: MonAISpacing.x4),
      child: MonAICard(
        padding: .zero,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: .zero,
          itemCount: _rows,
          separatorBuilder: (_, _) => const MonAIDivider(),
          itemBuilder: (_, _) => const Padding(
            padding: .symmetric(
              horizontal: MonAISpacing.x4,
              vertical: MonAISpacing.x3_5,
            ),
            child: Row(
              spacing: MonAISpacing.x3,
              children: [
                MonAISkeleton(
                  height: MonAISizes.avatarMedium,
                  width: MonAISizes.avatarMedium,
                  borderRadius: MonAIRadius.fullAll,
                ),
                Expanded(child: MonAISkeleton(height: MonAISpacing.x4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
