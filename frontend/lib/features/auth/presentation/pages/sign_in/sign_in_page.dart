import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/auth/presentation/model/auth_form_error.dart';
import 'package:monai/features/auth/presentation/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:monai/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:monai/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:monai/route_path.dart';

/// A successful sign-in needs no navigation here: the saved session sends
/// the router to Home.
class SignInPage extends StatelessWidget {
  const SignInPage({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignInBloc>(),
      child: SignInUI(initialEmail: initialEmail),
    );
  }
}

class SignInUI extends StatefulWidget {
  const SignInUI({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  State<SignInUI> createState() => _SignInUIState();
}

class _SignInUIState extends State<SignInUI> {
  late final _email = TextEditingController(text: widget.initialEmail);
  final _password = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onFailure(BuildContext context, SignInState state) {
    switch (state.focusField) {
      case .email:
        _emailFocus.requestFocus();
      case .password:
        _passwordFocus.requestFocus();
      case .name || .currentPassword || .newPassword || null:
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<SignInBloc>().add(
      SignInEvent.submitted(email: _email.text, password: _password.text),
    );
  }

  void _goToRegister() =>
      context.go(RoutePath.registerWith(email: _email.text));

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (previous, current) =>
          previous.status != current.status && current.status == .failure,
      listener: _onFailure,
      child: AutofillGroup(
        child: _SignInForm(
          email: _email,
          password: _password,
          emailFocus: _emailFocus,
          passwordFocus: _passwordFocus,
          onSubmit: _submit,
          onCreateAccount: _goToRegister,
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({
    required this.email,
    required this.password,
    required this.emailFocus,
    required this.passwordFocus,
    required this.onSubmit,
    required this.onCreateAccount,
  });

  final TextEditingController email;
  final TextEditingController password;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final VoidCallback onSubmit;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      fields: [
        const _Header(),
        _EmailField(
          controller: email,
          focusNode: emailFocus,
          nextFocus: passwordFocus,
        ),
        _PasswordField(
          controller: password,
          focusNode: passwordFocus,
          onSubmit: onSubmit,
        ),
      ],
      actions: _Actions(onSubmit: onSubmit, onCreateAccount: onCreateAccount),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final expanded = context.widthClass == .expanded;
    return BlocSelector<SignInBloc, SignInState, AuthFormError?>(
      selector: (state) => state.formError,
      builder: (context, formError) => Column(
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x5,
        children: [
          if (!expanded) const AuthLogoTile(),
          AuthHeader(
            title: l10n.signInTitle,
            subtitle: expanded
                ? l10n.signInSubtitleTablet
                : l10n.signInSubtitle,
          ),
          if (formError case final error?)
            MonAIInlineAlert(message: l10n.formError(error), tone: .error),
        ],
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
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
    return BlocSelector<SignInBloc, SignInState, (FieldError?, bool)>(
      selector: (state) => (state.emailError, state.status.isSubmitting),
      builder: (context, field) {
        final (error, submitting) = field;
        return MonAITextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) =>
              context.read<SignInBloc>().add(SignInEvent.emailEdited(value)),
          onSubmitted: (_) => nextFocus.requestFocus(),
          enabled: !submitting,
          label: l10n.authEmailLabel,
          placeholder: l10n.authEmailPlaceholder,
          leadingIcon: MonAIIcons.mail,
          supportingText: switch (error) {
            final error? => l10n.fieldError(error),
            null => null,
          },
          tone: error == null ? .neutral : .error,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
        );
      },
    );
  }
}

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
    return BlocSelector<SignInBloc, SignInState, (FieldError?, bool)>(
      selector: (state) => (state.passwordError, state.status.isSubmitting),
      builder: (context, field) {
        final (error, submitting) = field;
        return MonAIPasswordField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) =>
              context.read<SignInBloc>().add(SignInEvent.passwordEdited(value)),
          onSubmitted: (_) => onSubmit(),
          enabled: !submitting,
          label: l10n.authPasswordLabel,
          placeholder: l10n.authPasswordPlaceholder,
          supportingText: switch (error) {
            final error? => l10n.fieldError(error),
            null => null,
          },
          tone: error == null ? .neutral : .error,
          showPasswordLabel: l10n.authShowPassword,
          hidePasswordLabel: l10n.authHidePassword,
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.onSubmit, required this.onCreateAccount});

  final VoidCallback onSubmit;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<SignInBloc, SignInState, bool>(
      selector: (state) => state.status.isSubmitting,
      builder: (context, submitting) => AuthActions(
        submitLabel: l10n.signInSubmit,
        onSubmit: onSubmit,
        loading: submitting,
        prompt: l10n.signInNewHere,
        linkLabel: l10n.signInCreateAccount,
        onLinkTap: onCreateAccount,
      ),
    );
  }
}
