import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/auth/domain/validation/auth_input_validator.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';
import 'package:monai/features/auth/presentation/pages/change_password/bloc/change_password_bloc.dart';
import 'package:monai/features/auth/presentation/widgets/auth_error_text.dart';

/// A successful change needs no navigation here: the session ends and the
/// password-changed dialog covers the app.
class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChangePasswordBloc>(),
      child: const ChangePasswordUI(),
    );
  }
}

class ChangePasswordUI extends StatefulWidget {
  const ChangePasswordUI({super.key});

  @override
  State<ChangePasswordUI> createState() => _ChangePasswordUIState();
}

class _ChangePasswordUIState extends State<ChangePasswordUI> {
  static const _readableWidth = 640.0;

  final _current = TextEditingController();
  final _new = TextEditingController();
  final _currentFocus = FocusNode();
  final _newFocus = FocusNode();

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    super.dispose();
  }

  void _onFailure(BuildContext context, ChangePasswordState state) {
    switch (state.focusField) {
      case .currentPassword:
        _currentFocus.requestFocus();
      case .newPassword:
        _newFocus.requestFocus();
      case .name || .email || .password || null:
    }
  }

  void _currentEdited(String value) => context.read<ChangePasswordBloc>().add(
    ChangePasswordEvent.currentPasswordEdited(value),
  );

  void _newEdited(String value) => context.read<ChangePasswordBloc>().add(
    ChangePasswordEvent.newPasswordEdited(
      newPassword: value,
      currentPassword: _current.text,
    ),
  );

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<ChangePasswordBloc>().add(
      ChangePasswordEvent.submitted(
        currentPassword: _current.text,
        newPassword: _new.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listenWhen: (previous, current) =>
          previous.status != current.status && current.status == .failure,
      listener: _onFailure,
      child: Scaffold(
        backgroundColor: context.colors.surface,
        appBar: MonAITopBar(
          title: context.l10n.changePasswordTitle,
          actions: [_SaveAction(onSave: _submit)],
        ),
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _readableWidth),
              child: SingleChildScrollView(
                padding: const .fromLTRB(
                  MonAISpacing.screenHorizontal,
                  MonAISpacing.x2,
                  MonAISpacing.screenHorizontal,
                  MonAISpacing.x6,
                ),
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: .stretch,
                    spacing: MonAISpacing.x5,
                    children: [
                      const _FormError(),
                      _CurrentPasswordField(
                        controller: _current,
                        focusNode: _currentFocus,
                        nextFocus: _newFocus,
                        onChanged: _currentEdited,
                      ),
                      _NewPasswordField(
                        controller: _new,
                        focusNode: _newFocus,
                        onChanged: _newEdited,
                        onSubmit: _submit,
                      ),
                      MonAIInlineAlert(
                        message: context.l10n.changePasswordSignOutNote,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
      padding: const .only(right: MonAISpacing.x2),
      child: BlocSelector<ChangePasswordBloc, ChangePasswordState, bool>(
        selector: (state) => state.status.isSubmitting,
        builder: (context, submitting) => MonAIButton(
          label: context.l10n.changePasswordSave,
          size: .small,
          loading: submitting,
          onPressed: submitting ? null : onSave,
        ),
      ),
    );
  }
}

class _FormError extends StatelessWidget {
  const _FormError();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ChangePasswordBloc,
      ChangePasswordState,
      AuthFormError?
    >(
      selector: (state) => state.formError,
      builder: (context, formError) => switch (formError) {
        final error? => MonAIInlineAlert(
          message: context.l10n.formError(error),
          tone: .error,
        ),
        null => const SizedBox.shrink(),
      },
    );
  }
}

class _CurrentPasswordField extends StatelessWidget {
  const _CurrentPasswordField({
    required this.controller,
    required this.focusNode,
    required this.nextFocus,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<
      ChangePasswordBloc,
      ChangePasswordState,
      (FieldError?, bool)
    >(
      selector: (state) =>
          (state.currentPasswordError, state.status.isSubmitting),
      builder: (context, field) {
        final (error, submitting) = field;
        return MonAIPasswordField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: (_) => nextFocus.requestFocus(),
          enabled: !submitting,
          label: l10n.changePasswordCurrentLabel,
          placeholder: l10n.changePasswordCurrentPlaceholder,
          supportingText: switch (error) {
            final error? => l10n.fieldError(error),
            null => null,
          },
          tone: error == null ? .neutral : .error,
          showPasswordLabel: l10n.authShowPassword,
          hidePasswordLabel: l10n.authHidePassword,
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class _NewPasswordField extends StatelessWidget {
  const _NewPasswordField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<
      ChangePasswordBloc,
      ChangePasswordState,
      (FieldError?, bool, bool)
    >(
      selector: (state) => (
        state.newPasswordError,
        state.newPasswordLongEnough,
        state.status.isSubmitting,
      ),
      builder: (context, field) {
        final (error, longEnough, submitting) = field;
        return MonAIPasswordField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: (_) => onSubmit(),
          enabled: !submitting,
          label: l10n.changePasswordNewLabel,
          placeholder: l10n.registerPasswordPlaceholder,
          supportingText: switch (error) {
            final error? => l10n.fieldError(error),
            null => l10n.registerPasswordHint(AuthInputValidator.passwordMin),
          },
          tone: switch ((error, longEnough)) {
            (_?, _) => .error,
            (null, true) => .success,
            (null, false) => .neutral,
          },
          showPasswordLabel: l10n.authShowPassword,
          hidePasswordLabel: l10n.authHidePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
        );
      },
    );
  }
}
