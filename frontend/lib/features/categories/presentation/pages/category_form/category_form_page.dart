import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/categories/presentation/pages/category_form/bloc/category_form_bloc.dart';
import 'package:monai/features/categories/presentation/pages/category_form/model/category_form_mode.dart';
import 'package:monai/features/categories/presentation/pages/category_form/widgets/category_form_color_grid.dart';
import 'package:monai/features/categories/presentation/pages/category_form/widgets/category_form_icon_grid.dart';
import 'package:monai/features/categories/presentation/pages/category_form/widgets/category_form_name_field.dart';
import 'package:monai/features/categories/presentation/pages/category_form/widgets/category_form_preview.dart';
import 'package:monai/features/shared/domain/entity/category.dart';

class CategoryFormPage extends StatelessWidget {
  const CategoryFormPage({
    required this.mode,
    super.key,
    this.placement = ScreenPlacement.fullScreen,
  });

  final CategoryFormMode mode;

  /// [ScreenPlacement.sideSheet] on tablet landscape.
  final ScreenPlacement placement;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<CategoryFormBloc>(param1: mode)
            ..add(const CategoryFormEvent.started()),
      child: CategoryFormUI(placement: placement),
    );
  }
}

/// Adding a category or editing one: name, icon and color, previewed live.
/// Editing a custom category can also delete it.
class CategoryFormUI extends StatefulWidget {
  const CategoryFormUI({
    super.key,
    this.placement = ScreenPlacement.fullScreen,
  });

  final ScreenPlacement placement;

  @override
  State<CategoryFormUI> createState() => _CategoryFormUIState();
}

class _CategoryFormUIState extends State<CategoryFormUI> {
  final _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The edited category may have loaded before this screen listened.
    if (_bloc.state.original case final category?) _fill(category);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  CategoryFormBloc get _bloc => context.read<CategoryFormBloc>();

  void _fill(Category category) => _name.text = category.name;

  void _onNameChanged(String name) =>
      _bloc.add(CategoryFormEvent.nameEdited(name));

  void _pickIcon(String icon) => _bloc.add(CategoryFormEvent.iconPicked(icon));

  void _pickColor(String color) =>
      _bloc.add(CategoryFormEvent.colorPicked(color));

  void _save() => _bloc.add(CategoryFormEvent.saveRequested(_name.text));

  void _delete() => Navigator.pop(context, CategoryFormOutcome.deleteRequested);

  void _onLoaded(BuildContext context, CategoryFormState state) {
    if (state.original case final category?) _fill(category);
  }

  void _finish(BuildContext context, CategoryFormState state) {
    if (state.actionFailure case final failure?) {
      showMonAISnackBar(context, message: failure.formMessage(context.l10n));
      Navigator.pop(context);
      return;
    }
    Navigator.pop(context, CategoryFormOutcome.saved);
  }

  void _showActionFailure(BuildContext context, CategoryFormState state) {
    if (state.actionFailure case final failure? when !state.done) {
      showMonAISnackBar(context, message: failure.formMessage(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEdit = context.select<CategoryFormBloc, bool>(
      (bloc) => bloc.state.isEdit,
    );
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoryFormBloc, CategoryFormState>(
          listenWhen: (previous, current) =>
              current.original != null && previous.original == null,
          listener: _onLoaded,
        ),
        BlocListener<CategoryFormBloc, CategoryFormState>(
          listenWhen: (previous, current) => current.done && !previous.done,
          listener: _finish,
        ),
        BlocListener<CategoryFormBloc, CategoryFormState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colors.surface,
        appBar: MonAITopBar(
          title: isEdit
              ? l10n.categoryFormEditTitle
              : l10n.categoryFormNewTitle,
          navigation: .close,
          navigationTooltip: l10n.categoryFormClose,
          placement: widget.placement,
          actions: [_SaveAction(onSave: _save)],
        ),
        body: BlocSelector<CategoryFormBloc, CategoryFormState, UiStatus>(
          selector: (state) => state.status,
          builder: (context, status) => switch (status) {
            .success || .empty => _Fields(
              name: _name,
              onNameChanged: _onNameChanged,
              onIconPicked: _pickIcon,
              onColorPicked: _pickColor,
              onDelete: _delete,
            ),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}

class _SaveAction extends StatelessWidget {
  const _SaveAction({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(right: MonAISpacing.x4),
      child: BlocSelector<CategoryFormBloc, CategoryFormState, (bool, bool)>(
        selector: (state) => (state.status == .success, state.isSaving),
        builder: (context, selected) {
          final (loaded, isSaving) = selected;
          return MonAIButton(
            label: context.l10n.categoryFormSave,
            size: .small,
            loading: isSaving,
            onPressed: loaded ? onSave : null,
          );
        },
      ),
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields({
    required this.name,
    required this.onNameChanged,
    required this.onIconPicked,
    required this.onColorPicked,
    required this.onDelete,
  });

  final TextEditingController name;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onIconPicked;
  final ValueChanged<String> onColorPicked;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ListView(
        padding: const .fromLTRB(
          MonAISpacing.x4,
          MonAISpacing.x1,
          MonAISpacing.x4,
          MonAISpacing.x6,
        ),
        children: [
          CategoryFormPreview(name: name),
          const SizedBox(height: MonAISpacing.x5),
          CategoryFormNameField(controller: name, onChanged: onNameChanged),
          const SizedBox(height: MonAISpacing.x5),
          CategoryFormIconGrid(onPick: onIconPicked),
          const SizedBox(height: MonAISpacing.x5),
          CategoryFormColorGrid(onPick: onColorPicked),
          BlocSelector<CategoryFormBloc, CategoryFormState, bool>(
            selector: (state) => state.canDelete,
            builder: (context, canDelete) => canDelete
                ? Padding(
                    padding: const .only(top: MonAISpacing.x8),
                    child: _DeleteButton(onPressed: onDelete),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// A red outlined "Delete category".
class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: MonAISizes.buttonMedium,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: MonAIIcon(
          MonAIIcons.delete,
          size: MonAISizes.iconLg,
          color: c.errorText,
        ),
        label: Text(context.l10n.categoryFormDelete),
        style: OutlinedButton.styleFrom(
          foregroundColor: c.errorText,
          side: BorderSide(color: c.errorContainerBorder),
          shape: const StadiumBorder(),
          textStyle: context.textTheme.labelLarge,
        ),
      ),
    );
  }
}
