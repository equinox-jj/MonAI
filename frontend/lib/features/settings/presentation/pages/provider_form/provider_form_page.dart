import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/settings/domain/logic/provider_rules.dart';
import 'package:monai/features/settings/domain/validation/provider_input_validator.dart';
import 'package:monai/features/settings/presentation/model/provider_failure.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/bloc/provider_form_bloc.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/widgets/provider_form_active_row.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/widgets/provider_form_aliases.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/widgets/provider_form_dialogs.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/widgets/provider_form_logo.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/widgets/provider_form_type.dart';

class ProviderFormPage extends StatelessWidget {
  const ProviderFormPage({
    super.key,
    this.providerId,
    this.placement = ScreenPlacement.fullScreen,
  });

  final String? providerId;
  final ScreenPlacement placement;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProviderFormBloc>(param1: providerId)
            ..add(const ProviderFormEvent.started()),
      child: ProviderFormUI(placement: placement),
    );
  }
}

class ProviderFormUI extends StatefulWidget {
  const ProviderFormUI({
    super.key,
    this.placement = ScreenPlacement.fullScreen,
  });

  final ScreenPlacement placement;

  @override
  State<ProviderFormUI> createState() => _ProviderFormUIState();
}

class _ProviderFormUIState extends State<ProviderFormUI> {
  static const _defaultSortOrder = '100';

  final _name = TextEditingController();
  final _alias = TextEditingController();
  final _sortOrder = TextEditingController(text: _defaultSortOrder);

  @override
  void initState() {
    super.initState();
    // The edited provider may have loaded before this screen listened.
    _fill(context, _bloc.state);
  }

  @override
  void dispose() {
    _name.dispose();
    _alias.dispose();
    _sortOrder.dispose();
    super.dispose();
  }

  ProviderFormBloc get _bloc => context.read<ProviderFormBloc>();

  void _fill(BuildContext context, ProviderFormState state) {
    if (state.original case final provider?) {
      _name.text = provider.name;
      _sortOrder.text = '${provider.sortOrder}';
    }
  }

  void _clearAlias(BuildContext context, ProviderFormState state) =>
      _alias.clear();

  void _nameEdited(String name) =>
      _bloc.add(ProviderFormEvent.nameEdited(name));

  void _sortOrderEdited(String text) =>
      _bloc.add(ProviderFormEvent.sortOrderEdited(text));

  void _typePicked(WalletType type) =>
      _bloc.add(ProviderFormEvent.typePicked(type));

  void _aliasTyped(String text) =>
      _bloc.add(ProviderFormEvent.aliasTyped(text));

  void _aliasSubmitted(String text) =>
      _bloc.add(ProviderFormEvent.aliasSubmitted(text));

  void _aliasRemoved(String alias) =>
      _bloc.add(ProviderFormEvent.aliasRemoved(alias));

  void _activeToggled(bool active) =>
      _bloc.add(ProviderFormEvent.activeToggled(active: active));

  void _pickLogo() => _bloc.add(const ProviderFormEvent.logoPickRequested());

  void _delete() => _bloc.add(const ProviderFormEvent.deleteRequested());

  void _retry() => _bloc.add(const ProviderFormEvent.retried());

  void _save() {
    FocusScope.of(context).unfocus();
    _bloc.add(
      ProviderFormEvent.saveRequested(
        name: _name.text,
        aliasInput: _alias.text,
        sortOrder: _sortOrder.text,
      ),
    );
  }

  Future<void> _confirm(BuildContext context, ProviderFormState state) async {
    final bloc = _bloc;
    final name = state.original?.name ?? _name.text;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => switch (state.dialog) {
        .deactivate => ProviderDeactivateDialog(name: name),
        _ => ProviderDeleteDialog(name: name),
      },
    );
    bloc.add(
      confirmed ?? false
          ? const ProviderFormEvent.dialogConfirmed()
          : const ProviderFormEvent.dialogDismissed(),
    );
  }

  void _finish(BuildContext context, ProviderFormState state) =>
      Navigator.pop(context);

  void _showFailure(BuildContext context, ProviderFormState state) {
    if (state.actionFailure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  void _showLogoFailed(BuildContext context, ProviderFormState state) =>
      showMonAISnackBar(
        context,
        message: context.l10n.providerFormSavedLogoFailed,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isNew = context.select<ProviderFormBloc, bool>(
      (bloc) => bloc.state.isNew && bloc.state.original == null,
    );
    return MultiBlocListener(
      listeners: [
        BlocListener<ProviderFormBloc, ProviderFormState>(
          listenWhen: (previous, current) =>
              previous.original == null && current.original != null,
          listener: _fill,
        ),
        BlocListener<ProviderFormBloc, ProviderFormState>(
          listenWhen: (previous, current) =>
              previous.aliasInputResets != current.aliasInputResets,
          listener: _clearAlias,
        ),
        BlocListener<ProviderFormBloc, ProviderFormState>(
          listenWhen: (previous, current) =>
              current.dialog != null && previous.dialog != current.dialog,
          listener: _confirm,
        ),
        BlocListener<ProviderFormBloc, ProviderFormState>(
          listenWhen: (previous, current) => current.done && !previous.done,
          listener: _finish,
        ),
        BlocListener<ProviderFormBloc, ProviderFormState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showFailure,
        ),
        BlocListener<ProviderFormBloc, ProviderFormState>(
          listenWhen: (previous, current) =>
              current.logoFailed && !previous.logoFailed,
          listener: _showLogoFailed,
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colors.surface,
        appBar: MonAITopBar(
          title: isNew ? l10n.providerFormNewTitle : l10n.providerFormEditTitle,
          navigation: .close,
          navigationTooltip: l10n.providerFormClose,
          placement: widget.placement,
          actions: [
            if (isNew)
              Padding(
                padding: const .only(right: MonAISpacing.x4),
                child: MonAITag(text: l10n.providersAdmin),
              )
            else
              _SaveAction(onSave: _save),
          ],
        ),
        body: BlocSelector<ProviderFormBloc, ProviderFormState, UiStatus>(
          selector: (state) => state.status,
          builder: (context, status) => switch (status) {
            .success || .empty => _Fields(
              name: _name,
              alias: _alias,
              sortOrder: _sortOrder,
              onNameChanged: _nameEdited,
              onSortOrderChanged: _sortOrderEdited,
              onTypePicked: _typePicked,
              onAliasTyped: _aliasTyped,
              onAliasSubmitted: _aliasSubmitted,
              onAliasRemoved: _aliasRemoved,
              onActiveToggled: _activeToggled,
              onPickLogo: _pickLogo,
              onCreate: _save,
              onDelete: _delete,
            ),
            .failure => _LoadError(onRetry: _retry),
            .initial ||
            .loading => const Center(child: CircularProgressIndicator()),
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
      child: BlocSelector<ProviderFormBloc, ProviderFormState, (bool, bool)>(
        selector: (state) => (state.isReady, state.isSaving),
        builder: (context, selected) {
          final (ready, saving) = selected;
          return MonAIButton(
            label: context.l10n.providerFormSave,
            size: .small,
            loading: saving,
            onPressed: ready ? onSave : null,
          );
        },
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<ProviderFormBloc, ProviderFormState, ProviderFailure?>(
      selector: (state) => state.loadFailure,
      builder: (context, failure) => Center(
        child: SingleChildScrollView(
          padding: const .all(MonAISpacing.x6),
          child: MonAIStateMessage(
            icon: failure == .network ? MonAIIcons.cloudOff : MonAIIcons.error,
            tone: .error,
            title: l10n.providersLoadErrorTitle,
            message: (failure ?? .unexpected).message(l10n),
            actionLabel: l10n.providersRetry,
            actionIcon: MonAIIcons.refresh,
            onAction: onRetry,
          ),
        ),
      ),
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields({
    required this.name,
    required this.alias,
    required this.sortOrder,
    required this.onNameChanged,
    required this.onSortOrderChanged,
    required this.onTypePicked,
    required this.onAliasTyped,
    required this.onAliasSubmitted,
    required this.onAliasRemoved,
    required this.onActiveToggled,
    required this.onPickLogo,
    required this.onCreate,
    required this.onDelete,
  });

  static const _readableWidth = 640.0;

  final TextEditingController name;
  final TextEditingController alias;
  final TextEditingController sortOrder;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onSortOrderChanged;
  final ValueChanged<WalletType> onTypePicked;
  final ValueChanged<String> onAliasTyped;
  final ValueChanged<String> onAliasSubmitted;
  final ValueChanged<String> onAliasRemoved;
  final ValueChanged<bool> onActiveToggled;
  final VoidCallback onPickLogo;
  final VoidCallback onCreate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _readableWidth),
          child: ListView(
            padding: const .fromLTRB(
              MonAISpacing.x4,
              MonAISpacing.x1,
              MonAISpacing.x4,
              MonAISpacing.x6,
            ),
            children: [
              ProviderFormLogo(name: name, onPick: onPickLogo),
              const SizedBox(height: MonAISpacing.x4),
              _NameField(controller: name, onChanged: onNameChanged),
              const SizedBox(height: MonAISpacing.x4),
              ProviderFormType(onPick: onTypePicked),
              const SizedBox(height: MonAISpacing.x4),
              ProviderFormAliases(
                controller: alias,
                onChanged: onAliasTyped,
                onSubmitted: onAliasSubmitted,
                onRemove: onAliasRemoved,
              ),
              const SizedBox(height: MonAISpacing.x4),
              _SortOrderField(
                controller: sortOrder,
                onChanged: onSortOrderChanged,
              ),
              const SizedBox(height: MonAISpacing.x4),
              ProviderFormActiveRow(onToggled: onActiveToggled),
              const SizedBox(height: MonAISpacing.x6),
              _Footer(onCreate: onCreate, onDelete: onDelete),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<
      ProviderFormBloc,
      ProviderFormState,
      (FieldError?, String, bool)
    >(
      selector: (state) =>
          (state.nameError, state.slug, state.isWorking || !state.canSave),
      builder: (context, field) {
        final (error, slug, locked) = field;
        return MonAITextField(
          controller: controller,
          onChanged: onChanged,
          enabled: !locked,
          label: l10n.providerFormName,
          placeholder: l10n.providerFormNamePlaceholder,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
              ProviderInputValidator.nameMaxLength,
            ),
          ],
          textInputAction: TextInputAction.next,
          supportingText: switch ((error, slug)) {
            (final error?, _) => error.text(l10n),
            (null, '') => l10n.providerFormIdPending,
            (null, final slug) => l10n.providerFormId(slug),
          },
          tone: error == null ? .neutral : .error,
        );
      },
    );
  }
}

class _SortOrderField extends StatelessWidget {
  const _SortOrderField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<ProviderFormBloc, ProviderFormState, bool>(
      selector: (state) => state.isWorking || !state.canSave,
      builder: (context, locked) => MonAITextField(
        controller: controller,
        onChanged: onChanged,
        enabled: !locked,
        label: l10n.providerFormSortOrder,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [
          TextInputFormatter.withFunction(
            (previous, next) =>
                kSortOrderInput.hasMatch(next.text) ? next : previous,
          ),
        ],
        textInputAction: TextInputAction.done,
        supportingText: l10n.providerFormSortOrderNote,
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onCreate, required this.onDelete});

  final VoidCallback onCreate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final hintStyle = context.textTheme.bodySmall?.copyWith(
      color: c.textTertiary,
    );
    return BlocBuilder<ProviderFormBloc, ProviderFormState>(
      buildWhen: (previous, current) =>
          previous.original != current.original ||
          previous.isReady != current.isReady ||
          previous.isSaving != current.isSaving ||
          previous.isDeleting != current.isDeleting ||
          previous.canDelete != current.canDelete ||
          previous.lastEdited != current.lastEdited,
      builder: (context, state) {
        final original = state.original;
        if (original == null) {
          return Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x2,
            children: [
              MonAIButton(
                label: l10n.providerFormCreate,
                loading: state.isSaving,
                onPressed: state.isReady ? onCreate : null,
              ),
              Text(
                state.isReady
                    ? l10n.providerFormHintReady
                    : l10n.providerFormHint,
                textAlign: .center,
                style: hintStyle,
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x2,
          children: [
            if (state.canDelete)
              _DeleteButton(
                label: l10n.providerFormDelete(original.name),
                onPressed: state.isWorking ? null : onDelete,
              ),
            if (state.lastEdited case final edited?)
              Text(
                l10n.providerFormLastEdited(
                  MonthFormat.dayMonthYear(edited, context.localeName),
                ),
                textAlign: .center,
                style: hintStyle,
              ),
          ],
        );
      },
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

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
        label: Text(label),
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
