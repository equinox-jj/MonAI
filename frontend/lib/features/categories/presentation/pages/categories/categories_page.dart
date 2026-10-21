import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/app_router.dart';
import 'package:monai/features/categories/domain/logic/category_rules.dart';
import 'package:monai/features/categories/presentation/model/category_failure.dart';
import 'package:monai/features/categories/presentation/pages/categories/bloc/categories_bloc.dart';
import 'package:monai/features/categories/presentation/pages/categories/widgets/category_list_row.dart';
import 'package:monai/features/categories/presentation/pages/categories/widgets/category_move_sheet.dart';
import 'package:monai/features/categories/presentation/pages/category_form/model/category_form_mode.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoriesBloc>()..add(const CategoriesEvent.started()),
      child: const CategoriesUI(),
    );
  }
}

/// The expense and income categories, with hide, delete and edit.
class CategoriesUI extends StatelessWidget {
  const CategoriesUI({super.key});

  CategoriesBloc _bloc(BuildContext context) => context.read<CategoriesBloc>();

  void _selectType(BuildContext context, CategoryType type) =>
      _bloc(context).add(CategoriesEvent.typeSelected(type));

  void _retry(BuildContext context) =>
      _bloc(context).add(const CategoriesEvent.retried());

  void _toggleHidden(BuildContext context, Category category) =>
      _bloc(context).add(CategoriesEvent.hiddenToggled(category.id));

  void _add(BuildContext context) =>
      context.push(AppRoutes.categoryNew(_bloc(context).state.type));

  Future<void> _edit(BuildContext context, Category category) async {
    final outcome = await context.push<CategoryFormOutcome>(
      AppRoutes.categoryEdit(category.id),
    );
    if (outcome == .deleteRequested && context.mounted) {
      await _confirmDelete(context, category);
    }
  }

  Future<void> _confirmDelete(BuildContext context, Category category) async {
    final l10n = context.l10n;
    final bloc = _bloc(context);
    final delete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => MonAIAlertDialog(
        title: l10n.categoriesDeleteTitle(category.name),
        message: l10n.categoriesDeleteMessage,
        icon: MonAIIcons.delete,
        tone: .error,
        confirmLabel: l10n.categoriesDeleteConfirm,
        destructive: true,
        onConfirm: () => Navigator.pop(dialogContext, true),
        dismissLabel: l10n.categoriesCancel,
        onDismiss: () => Navigator.pop(dialogContext, false),
      ),
    );
    if (delete ?? false) bloc.add(CategoriesEvent.deleteRequested(category.id));
  }

  Future<void> _askWhereToMove(
    BuildContext context,
    CategoriesState state,
  ) async {
    final category = state.moveFrom;
    if (category == null) return;
    final bloc = _bloc(context);
    final moveTo = await showMonAIBottomSheet<String>(
      context,
      builder: (_) => CategoryMoveSheet(
        category: category,
        targets: moveTargets(category, state.categories),
      ),
    );
    if (moveTo != null) {
      bloc.add(CategoriesEvent.deleteRequested(category.id, moveTo: moveTo));
    }
  }

  void _showDeleted(BuildContext context, CategoriesState state) {
    if (state.deleted case final category?) {
      final c = context.colors;
      showMonAISnackBar(
        context,
        message: context.l10n.categoriesDeleted(category.name),
        icon: MonAIIcons.checkCircle,
        iconColor: c.success,
      );
    }
  }

  void _showActionFailure(BuildContext context, CategoriesState state) {
    if (state.actionFailure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoriesBloc, CategoriesState>(
          listenWhen: (previous, current) =>
              current.moveFrom != null && previous.moveFrom != current.moveFrom,
          listener: _askWhereToMove,
        ),
        BlocListener<CategoriesBloc, CategoriesState>(
          listenWhen: (previous, current) =>
              current.deleted != null && previous.deleted != current.deleted,
          listener: _showDeleted,
        ),
        BlocListener<CategoriesBloc, CategoriesState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: MonAITopBar(
          title: l10n.categoriesTitle,
          navigationTooltip: l10n.categoriesBack,
          actions: [
            Padding(
              padding: const .only(right: MonAISpacing.x4),
              child: MonAIButton(
                label: l10n.categoriesNew,
                variant: .tonal,
                size: .small,
                leadingIcon: MonAIIcons.add,
                onPressed: () => _add(context),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const .fromLTRB(
              MonAISpacing.x4,
              0,
              MonAISpacing.x4,
              MonAISpacing.x6,
            ),
            children: [
              BlocSelector<CategoriesBloc, CategoriesState, CategoryType>(
                selector: (state) => state.type,
                builder: (context, type) => MonAISegmentedControl(
                  segments: [
                    MonAISegment(
                      value: CategoryType.expense,
                      label: l10n.categoriesExpense,
                    ),
                    MonAISegment(
                      value: CategoryType.income,
                      label: l10n.categoriesIncome,
                    ),
                  ],
                  selected: type,
                  onChanged: (type) => _selectType(context, type),
                ),
              ),
              const SizedBox(height: MonAISpacing.x4),
              _Body(
                onRetry: () => _retry(context),
                onEdit: (category) => _edit(context, category),
                onToggleHidden: (category) => _toggleHidden(context, category),
                onDelete: (category) => _confirmDelete(context, category),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _List = ({
  UiStatus status,
  List<Category> shown,
  Set<String> busyIds,
  CategoryFailure? loadFailure,
});

/// The tab's categories in one card with the note under it, or the
/// loading, error and empty states.
class _Body extends StatelessWidget {
  const _Body({
    required this.onRetry,
    required this.onEdit,
    required this.onToggleHidden,
    required this.onDelete,
  });

  final VoidCallback onRetry;
  final ValueChanged<Category> onEdit;
  final ValueChanged<Category> onToggleHidden;
  final ValueChanged<Category> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<CategoriesBloc, CategoriesState, _List>(
      selector: (state) => (
        status: state.status,
        shown: state.shown,
        busyIds: state.busyIds,
        loadFailure: state.loadFailure,
      ),
      builder: (context, list) => switch (list.status) {
        .initial || .loading => const _Skeleton(),
        .failure => Padding(
          padding: const .symmetric(
            horizontal: MonAISpacing.x6,
            vertical: MonAISpacing.x10,
          ),
          child: MonAIStateMessage(
            icon: list.loadFailure == .network
                ? MonAIIcons.cloudOff
                : MonAIIcons.error,
            tone: .error,
            title: l10n.categoriesLoadErrorTitle,
            message: (list.loadFailure ?? .unexpected).message(l10n),
            actionLabel: l10n.categoriesRetry,
            actionIcon: MonAIIcons.refresh,
            onAction: onRetry,
          ),
        ),
        .success || .empty when list.shown.isEmpty => Padding(
          padding: const .symmetric(vertical: MonAISpacing.x10),
          child: Text(
            l10n.categoriesEmpty,
            textAlign: .center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: c.textSecondary,
            ),
          ),
        ),
        .success || .empty => Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x4,
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
                  final category = list.shown[index];
                  return CategoryListRow(
                    category: category,
                    busy: list.busyIds.contains(category.id),
                    onTap: () => onEdit(category),
                    onToggleHidden: () => onToggleHidden(category),
                    onDelete: () => onDelete(category),
                  );
                },
              ),
            ),
            Text(
              l10n.categoriesFootnote,
              style: context.textTheme.bodySmall?.copyWith(
                color: c.textTertiary,
              ),
            ),
          ],
        ),
      },
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  static const _rows = 6;

  @override
  Widget build(BuildContext context) {
    return MonAICard(
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
            vertical: MonAISpacing.x3,
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
    );
  }
}
