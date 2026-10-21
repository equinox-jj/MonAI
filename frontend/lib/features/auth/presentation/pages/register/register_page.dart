import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/app_router.dart';
import 'package:monai/features/auth/domain/validation/auth_input_validator.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';
import 'package:monai/features/auth/presentation/pages/register/bloc/register_bloc.dart';
import 'package:monai/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:monai/features/auth/presentation/widgets/auth_scaffold.dart';

/// A successful register needs no navigation here: the saved session sends
/// the router to Home.
class RegisterPage extends StatelessWidget {
  /// [initialEmail] is the email typed on Sign in, if the user came from
  /// there.
  const RegisterPage({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
      child: RegisterUI(initialEmail: initialEmail),
    );
  }
}

/// Stateful only to own the text controllers and focus nodes.
class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final _name = TextEditingController();
  late final _email = TextEditingController(text: widget.initialEmail);
  final _password = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  /// Focus the first field with an error, so the keyboard and screen reader
  /// land on it.
  void _onFailure(BuildContext context, RegisterState state) {
    switch (state.focusField) {
      case .name:
        _nameFocus.requestFocus();
      case .email:
        _emailFocus.requestFocus();
      case .password:
        _passwordFocus.requestFocus();
      case .currentPassword || .newPassword || null:
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<RegisterBloc>().add(
      RegisterEvent.submitted(
        name: _name.text,
        email: _email.text,
        password: _password.text,
      ),
    );
  }

  void _goToSignIn() => context.go(AppRoutes.signInWith(email: _email.text));

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) =>
          previous.status != current.status && current.status == .failure,
      listener: _onFailure,
      child: AutofillGroup(
        child: _RegisterForm(
          name: _name,
          email: _email,
          password: _password,
          nameFocus: _nameFocus,
          emailFocus: _emailFocus,
          passwordFocus: _passwordFocus,
          onSubmit: _submit,
          onSignIn: _goToSignIn,
        ),
      ),
    );
  }
}

/// The layout. Built once; each part below subscribes to only the state it
/// shows.
class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    required this.name,
    required this.email,
    required this.password,
    required this.nameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.onSubmit,
    required this.onSignIn,
  });

  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;
  final FocusNode nameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final VoidCallback onSubmit;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      fields: [
        const _Header(),
        _NameField(
          controller: name,
          focusNode: nameFocus,
          nextFocus: emailFocus,
        ),
        _EmailField(
          controller: email,
          focusNode: emailFocus,
          nextFocus: passwordFocus,
          onSignInInstead: onSignIn,
        ),
        _PasswordField(
          controller: password,
          focusNode: passwordFocus,
          onSubmit: onSubmit,
        ),
        MonAIInlineAlert(
          message: context.l10n.registerSetupNote,
          icon: MonAIIcons.autoAwesome,
        ),
      ],
      actions: _Actions(onSubmit: onSubmit, onSignIn: onSignIn),
    );
  }
}

/// The title and, after a failed attempt, the error banner.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<RegisterBloc, RegisterState, AuthFormError?>(
      selector: (state) => state.formError,
      builder: (context, formError) => Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x5,
        children: [
          AuthHeader(
            title: l10n.registerTitle,
            subtitle: l10n.registerSubtitle,
          ),
          if (formError case final error?)
            MonAIInlineAlert(message: l10n.formError(error), tone: .error),
        ],
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.focusNode,
    required this.nextFocus,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<RegisterBloc, RegisterState, (FieldError?, bool)>(
      selector: (state) => (state.nameError, state.isSubmitting),
      builder: (context, field) {
        final (error, submitting) = field;
        return MonAITextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) =>
              context.read<RegisterBloc>().add(RegisterEvent.nameEdited(value)),
          onSubmitted: (_) => nextFocus.requestFocus(),
          enabled: !submitting,
          label: l10n.authNameLabel,
          placeholder: l10n.authNamePlaceholder,
          leadingIcon: MonAIIcons.person,
          supportingText: switch (error) {
            final error? => l10n.fieldError(error),
            null => null,
          },
          tone: error == null ? .neutral : .error,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.controller,
    required this.focusNode,
    required this.nextFocus,
    required this.onSignInInstead,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final VoidCallback onSignInInstead;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<RegisterBloc, RegisterState, (FieldError?, bool, bool)>(
      selector: (state) =>
          (state.emailError, state.emailTaken, state.isSubmitting),
      builder: (context, field) {
        final (error, taken, submitting) = field;
        return MonAITextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) => context.read<RegisterBloc>().add(
            RegisterEvent.emailEdited(value),
          ),
          onSubmitted: (_) => nextFocus.requestFocus(),
          enabled: !submitting,
          label: l10n.authEmailLabel,
          placeholder: l10n.authEmailPlaceholder,
          leadingIcon: MonAIIcons.mail,
          supportingText: switch (error) {
            final error? => l10n.fieldError(error),
            null when taken => l10n.registerEmailTaken,
            null => null,
          },
          supportingLinkLabel: taken ? l10n.registerSignInInstead : null,
          onSupportingLinkTap: onSignInInstead,
          tone: error == null && !taken ? .neutral : .error,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
        );
      },
    );
  }
}

/// An error replaces the length hint; otherwise the hint turns green once it
/// is met.
class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<RegisterBloc, RegisterState, (FieldError?, bool, bool)>(
      selector: (state) =>
          (state.passwordError, state.passwordLongEnough, state.isSubmitting),
      builder: (context, field) {
        final (error, longEnough, submitting) = field;
        return MonAIPasswordField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) => context.read<RegisterBloc>().add(
            RegisterEvent.passwordEdited(value),
          ),
          onSubmitted: (_) => onSubmit(),
          enabled: !submitting,
          label: l10n.authPasswordLabel,
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

class _Actions extends StatelessWidget {
  const _Actions({required this.onSubmit, required this.onSignIn});

  final VoidCallback onSubmit;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<RegisterBloc, RegisterState, bool>(
      selector: (state) => state.isSubmitting,
      builder: (context, submitting) => AuthActions(
        submitLabel: l10n.registerSubmit,
        onSubmit: onSubmit,
        loading: submitting,
        prompt: l10n.registerHaveAccount,
        linkLabel: l10n.registerSignIn,
        onLinkTap: onSignIn,
      ),
    );
  }
}
