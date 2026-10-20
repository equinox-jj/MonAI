import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/model/wallet_type.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/core/utils/extension/wallet_type_extension.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/core/utils/rupiah_input_formatter.dart';
import 'package:monai/features/shared/domain/entity/payment_provider.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/wallets/domain/validation/wallet_input_validator.dart';
import 'package:monai/features/wallets/presentation/model/wallet_failure.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/bloc/wallet_form_bloc.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_field_error_text.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_form_mode.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/widgets/wallet_form_balance_shift.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/widgets/wallet_form_color_picker.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/widgets/wallet_form_default_row.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/widgets/wallet_form_preview_card.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/widgets/wallet_form_provider_grid.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/widgets/wallet_form_type_picker.dart';

class WalletFormPage extends StatelessWidget {
  const WalletFormPage({
    required this.mode,
    super.key,
    this.placement = ScreenPlacement.fullScreen,
  });

  final WalletFormMode mode;

  /// [ScreenPlacement.sideSheet] on tablet landscape.
  final ScreenPlacement placement;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<WalletFormBloc>(param1: mode)
            ..add(const WalletFormEvent.started()),
      child: WalletFormUI(placement: placement),
    );
  }
}

/// Adding a wallet from a provider or custom, or editing one: name, type,
/// color, balance and default. Editing also archives and deletes.
class WalletFormUI extends StatefulWidget {
  const WalletFormUI({super.key, this.placement = ScreenPlacement.fullScreen});

  final ScreenPlacement placement;

  @override
  State<WalletFormUI> createState() => _WalletFormUIState();
}

class _WalletFormUIState extends State<WalletFormUI> {
  final _name = TextEditingController();
  final _balance = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    // The edited wallet may have loaded before this screen listened.
    if (_bloc.state.original case final wallet?) _fill(wallet);
  }

  @override
  void dispose() {
    _name.dispose();
    _balance.dispose();
    super.dispose();
  }

  WalletFormBloc get _bloc => context.read<WalletFormBloc>();

  void _fill(Wallet wallet) {
    _name.text = wallet.name;
    _balance.text = formatRupiahInput(wallet.initialBalance);
  }

  void _save() => _bloc.add(
    WalletFormEvent.saveRequested(name: _name.text, balance: _balance.text),
  );

  void _retry() => _bloc.add(const WalletFormEvent.retried());

  void _pickProvider(String? slug) =>
      _bloc.add(WalletFormEvent.providerPicked(slug));

  void _pickType(WalletType type) =>
      _bloc.add(WalletFormEvent.typePicked(type));

  void _pickColor(String hex) => _bloc.add(WalletFormEvent.colorPicked(hex));

  void _toggleDefault(bool isDefault) =>
      _bloc.add(WalletFormEvent.defaultToggled(isDefault: isDefault));

  void _onNameChanged(String name) =>
      _bloc.add(WalletFormEvent.nameEdited(name));

  void _onBalanceChanged(String balance) =>
      _bloc.add(WalletFormEvent.balanceEdited(balance));

  void _archive() => _bloc.add(const WalletFormEvent.archiveRequested());

  Future<void> _confirmDelete() async {
    final name = _bloc.state.original?.name ?? '';
    final l10n = context.l10n;
    final delete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => MonAIAlertDialog(
        title: l10n.walletFormDeleteTitle(name),
        message: l10n.walletFormDeleteBody,
        icon: MonAIIcons.delete,
        tone: .error,
        confirmLabel: l10n.walletFormDelete,
        destructive: true,
        onConfirm: () => Navigator.pop(dialogContext, true),
        dismissLabel: l10n.walletFormCancel,
        onDismiss: () => Navigator.pop(dialogContext, false),
      ),
    );
    if (delete ?? false) _bloc.add(const WalletFormEvent.deleteRequested());
  }

  void _onLoaded(BuildContext context, WalletFormState state) {
    if (state.original case final wallet?) _fill(wallet);
  }

  void _fillName(BuildContext context, WalletFormState state) {
    if (state.nameFill case final name?) _name.text = name;
  }

  Future<void> _offerArchive(
    BuildContext context,
    WalletFormState state,
  ) async {
    final name = state.original?.name ?? '';
    final archive = await showDialog<bool>(
      context: context,
      builder: (_) => _ArchiveInsteadDialog(name: name),
    );
    if (archive ?? false) _archive();
  }

  void _finish(BuildContext context, WalletFormState state) {
    final l10n = context.l10n;
    final c = context.colors;
    switch (state.outcome) {
      case SavedWalletOutcome() || null:
        Navigator.pop(context, state.outcome);
      case ArchivedWalletOutcome(:final name):
        final router = GoRouter.of(context)..go(AppRoutes.wallets);
        showMonAISnackBar(
          context,
          message: l10n.walletArchivedSnack(name),
          icon: MonAIIcons.checkCircle,
          iconColor: c.success,
          actionLabel: l10n.walletsViewArchived,
          onAction: () => router.push(AppRoutes.walletsArchived),
        );
      case DeletedWalletOutcome(:final name):
        context.go(AppRoutes.wallets);
        showMonAISnackBar(
          context,
          message: l10n.walletDeletedSnack(name),
          icon: MonAIIcons.checkCircle,
          iconColor: c.success,
        );
    }
  }

  void _showActionFailure(BuildContext context, WalletFormState state) {
    if (state.actionFailure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEdit = context.select<WalletFormBloc, bool>(
      (bloc) => bloc.state.isEdit,
    );
    return MultiBlocListener(
      listeners: [
        BlocListener<WalletFormBloc, WalletFormState>(
          listenWhen: (previous, current) =>
              current.original != null && previous.original == null,
          listener: _onLoaded,
        ),
        BlocListener<WalletFormBloc, WalletFormState>(
          listenWhen: (previous, current) =>
              current.nameFill != null && previous.nameFill == null,
          listener: _fillName,
        ),
        BlocListener<WalletFormBloc, WalletFormState>(
          listenWhen: (previous, current) =>
              current.offerArchive && !previous.offerArchive,
          listener: _offerArchive,
        ),
        BlocListener<WalletFormBloc, WalletFormState>(
          listenWhen: (previous, current) =>
              current.outcome != null && previous.outcome == null,
          listener: _finish,
        ),
        BlocListener<WalletFormBloc, WalletFormState>(
          listenWhen: (previous, current) =>
              current.actionFailure != null &&
              previous.actionFailure != current.actionFailure,
          listener: _showActionFailure,
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colors.surface,
        appBar: MonAITopBar(
          title: isEdit ? l10n.walletFormEditTitle : l10n.walletFormAddTitle,
          navigation: .close,
          placement: widget.placement,
          actions: [if (isEdit) _SaveAction(onSave: _save)],
        ),
        body: BlocSelector<WalletFormBloc, WalletFormState, UiStatus>(
          selector: (state) => state.status,
          builder: (context, status) => switch (status) {
            .initial ||
            .loading => const Center(child: CircularProgressIndicator()),
            .failure => _LoadError(onRetry: _retry),
            .success || .empty =>
              isEdit
                  ? _EditBody(
                      name: _name,
                      balance: _balance,
                      onNameChanged: _onNameChanged,
                      onBalanceChanged: _onBalanceChanged,
                      onColorPicked: _pickColor,
                      onDefaultToggled: _toggleDefault,
                      onArchive: _archive,
                      onDelete: _confirmDelete,
                    )
                  : _AddBody(
                      name: _name,
                      balance: _balance,
                      onNameChanged: _onNameChanged,
                      onBalanceChanged: _onBalanceChanged,
                      onProviderPicked: _pickProvider,
                      onTypePicked: _pickType,
                      onDefaultToggled: _toggleDefault,
                      onSave: _save,
                    ),
          },
        ),
      ),
    );
  }
}

/// The edit form's "Save" pill.
class _SaveAction extends StatelessWidget {
  const _SaveAction({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(right: MonAISpacing.x2_5),
      child: BlocSelector<WalletFormBloc, WalletFormState, (bool, bool)>(
        selector: (state) => (state.status == .success, state.isSaving),
        builder: (context, selected) {
          final (loaded, isSaving) = selected;
          return MonAIButton(
            label: context.l10n.walletFormSave,
            size: .small,
            loading: isSaving,
            onPressed: loaded ? onSave : null,
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
    return Center(
      child: Padding(
        padding: const .symmetric(horizontal: MonAISpacing.x10),
        child: BlocSelector<WalletFormBloc, WalletFormState, WalletFailure?>(
          selector: (state) => state.loadFailure,
          builder: (context, failure) => MonAIStateMessage(
            icon: MonAIIcons.error,
            tone: .error,
            title: l10n.walletFormLoadErrorTitle,
            message: (failure ?? .unexpected).message(l10n),
            // A wallet that is gone won't come back on retry.
            actionLabel: failure == .notFound ? null : l10n.walletsRetry,
            actionIcon: MonAIIcons.refresh,
            onAction: onRetry,
          ),
        ),
      ),
    );
  }
}

/// The form's scrolling fields, with an optional action pinned below.
class _FormFrame extends StatelessWidget {
  const _FormFrame({required this.children, this.footer});

  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const .fromLTRB(
          MonAISpacing.screenHorizontal,
          MonAISpacing.x1,
          MonAISpacing.screenHorizontal,
          MonAISpacing.x4,
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x3,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .stretch,
                  spacing: MonAISpacing.x4,
                  children: children,
                ),
              ),
            ),
            ?footer,
          ],
        ),
      ),
    );
  }
}

class _AddBody extends StatelessWidget {
  const _AddBody({
    required this.name,
    required this.balance,
    required this.onNameChanged,
    required this.onBalanceChanged,
    required this.onProviderPicked,
    required this.onTypePicked,
    required this.onDefaultToggled,
    required this.onSave,
  });

  final TextEditingController name;
  final TextEditingController balance;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onBalanceChanged;
  final ValueChanged<String?> onProviderPicked;
  final ValueChanged<WalletType> onTypePicked;
  final ValueChanged<bool> onDefaultToggled;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _FormFrame(
      footer: BlocSelector<WalletFormBloc, WalletFormState, bool>(
        selector: (state) => state.isSaving,
        builder: (context, isSaving) => MonAIButton(
          label: l10n.walletsAdd,
          loading: isSaving,
          expand: true,
          onPressed: onSave,
        ),
      ),
      children: [
        WalletFormProviderGrid(onPicked: onProviderPicked),
        _NameField(controller: name, onChanged: onNameChanged),
        WalletFormTypePicker(onPicked: onTypePicked),
        _BalanceField(
          controller: balance,
          onChanged: onBalanceChanged,
          label: l10n.walletFormCurrentBalance,
          hint: l10n.walletFormCurrentBalanceHint,
        ),
        WalletFormDefaultRow(onToggled: onDefaultToggled),
      ],
    );
  }
}

class _EditBody extends StatelessWidget {
  const _EditBody({
    required this.name,
    required this.balance,
    required this.onNameChanged,
    required this.onBalanceChanged,
    required this.onColorPicked,
    required this.onDefaultToggled,
    required this.onArchive,
    required this.onDelete,
  });

  final TextEditingController name;
  final TextEditingController balance;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onBalanceChanged;
  final ValueChanged<String> onColorPicked;
  final ValueChanged<bool> onDefaultToggled;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _FormFrame(
      footer: _ArchiveAndDelete(onArchive: onArchive, onDelete: onDelete),
      children: [
        const WalletFormPreviewCard(),
        _NameField(controller: name, onChanged: onNameChanged),
        WalletFormColorPicker(onPicked: onColorPicked),
        Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x2,
          children: [
            _BalanceField(
              controller: balance,
              onChanged: onBalanceChanged,
              label: l10n.walletFormStartingBalance,
            ),
            const WalletFormBalanceShift(),
          ],
        ),
        WalletFormDefaultRow(onToggled: onDefaultToggled),
      ],
    );
  }
}

/// The name, with a hint that follows the picked provider, or the edited
/// wallet's fixed type.
class _NameField extends StatelessWidget {
  const _NameField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<
      WalletFormBloc,
      WalletFormState,
      (FieldError?, PaymentProvider?, Wallet?)
    >(
      selector: (state) => (
        state.errorOf(WalletInputValidator.nameField),
        state.selectedProvider,
        state.original,
      ),
      builder: (context, selected) {
        final (error, provider, original) = selected;
        final hint = switch ((original, provider)) {
          (final wallet?, _) when wallet.providerId != null =>
            l10n.walletFormTypeLineProvider(wallet.type.label(l10n)),
          (final wallet?, _) => l10n.walletFormTypeLine(
            wallet.type.label(l10n),
          ),
          (null, final provider?) => l10n.walletFormNameHintProvider(
            provider.name,
          ),
          (null, null) => l10n.walletFormNameHintCustom,
        };
        return MonAITextField(
          controller: controller,
          onChanged: onChanged,
          label: l10n.walletFormName,
          maxLength: WalletInputValidator.nameMax,
          textInputAction: TextInputAction.next,
          tone: error == null ? .neutral : .error,
          supportingText: error?.text(l10n) ?? hint,
        );
      },
    );
  }
}

class _BalanceField extends StatelessWidget {
  const _BalanceField({
    required this.controller,
    required this.onChanged,
    required this.label,
    this.hint,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<WalletFormBloc, WalletFormState, FieldError?>(
      selector: (state) =>
          state.errorOf(WalletInputValidator.initialBalanceField),
      builder: (context, error) => MonAITextField(
        controller: controller,
        onChanged: onChanged,
        label: label,
        prefix: l10n.walletFormCurrency,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        inputFormatters: const [RupiahInputFormatter()],
        tone: error == null ? .neutral : .error,
        supportingText: error?.text(l10n) ?? hint,
      ),
    );
  }
}

/// Archive and Delete; both are off for the default wallet, with a note
/// why.
class _ArchiveAndDelete extends StatelessWidget {
  const _ArchiveAndDelete({required this.onArchive, required this.onDelete});

  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<WalletFormBloc, WalletFormState, (bool, bool, bool)>(
      selector: (state) => (
        state.original?.isDefault ?? false,
        state.isArchiving,
        state.isDeleting,
      ),
      builder: (context, selected) {
        final (isDefault, isArchiving, isDeleting) = selected;
        final busy = isArchiving || isDeleting;
        return Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x2,
          children: [
            if (isDefault)
              Text(
                l10n.walletDetailDefaultNote,
                style: context.textTheme.bodySmall?.copyWith(
                  color: c.textTertiary,
                ),
              ),
            Row(
              spacing: MonAISpacing.x3,
              children: [
                Expanded(
                  child: MonAIButton(
                    label: l10n.walletFormArchive,
                    leadingIcon: MonAIIcons.inventory2,
                    variant: .outlined,
                    size: .medium,
                    loading: isArchiving,
                    onPressed: isDefault || busy ? null : onArchive,
                  ),
                ),
                Expanded(
                  child: _DeleteButton(
                    loading: isDeleting,
                    onPressed: isDefault || busy ? null : onDelete,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// The red-outlined "Delete".
class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null || loading;
    final color = enabled ? c.errorText : c.disabledContent;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: SizedBox(
        height: MonAISizes.buttonMedium,
        child: Material(
          color: Colors.transparent,
          shape: StadiumBorder(
            side: BorderSide(
              color: enabled ? c.errorContainerBorder : c.border,
            ),
          ),
          clipBehavior: .antiAlias,
          child: InkWell(
            onTap: loading ? null : onPressed,
            child: Row(
              mainAxisAlignment: .center,
              spacing: MonAISpacing.x1_5,
              children: [
                if (loading)
                  SizedBox.square(
                    dimension: MonAISizes.iconMd,
                    child: CircularProgressIndicator(
                      color: color,
                      strokeWidth: 2.5,
                    ),
                  )
                else
                  MonAIIcon(
                    MonAIIcons.delete,
                    size: MonAISizes.iconLg,
                    color: color,
                  ),
                Text(
                  context.l10n.walletFormDelete,
                  style: context.textTheme.labelLarge?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A wallet with transactions can't be deleted: "Archive {name} instead?".
class _ArchiveInsteadDialog extends StatelessWidget {
  const _ArchiveInsteadDialog({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return MonAIAlertDialog(
      title: l10n.walletArchiveInsteadTitle(name),
      message: l10n.walletArchiveInsteadBody(name),
      icon: MonAIIcons.inventory2,
      confirmLabel: l10n.walletFormArchive,
      onConfirm: () => Navigator.pop(context, true),
      dismissLabel: l10n.walletFormCancel,
      onDismiss: () => Navigator.pop(context, false),
      content: Container(
        padding: const .all(MonAISpacing.x3),
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: MonAIRadius.mdAll,
        ),
        child: Column(
          crossAxisAlignment: .start,
          spacing: MonAISpacing.x1_5,
          children: [
            _CheckLine(text: l10n.walletArchiveInsteadKeeps),
            _CheckLine(text: l10n.walletArchiveInsteadUndo),
          ],
        ),
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  const _CheckLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      spacing: MonAISpacing.x2,
      children: [
        MonAIIcon(
          MonAIIcons.checkCircle,
          size: MonAISizes.iconMd,
          color: c.success,
        ),
        Expanded(
          child: Text(
            text,
            style: context.textStyles.bodyCompact.copyWith(color: c.iconStrong),
          ),
        ),
      ],
    );
  }
}
