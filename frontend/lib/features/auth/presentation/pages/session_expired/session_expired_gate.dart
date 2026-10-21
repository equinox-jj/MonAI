import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/auth/presentation/pages/session_expired/cubit/session_expired_cubit.dart';

/// Covers the app with a dialog once the server rejects the token or the
/// password is changed. The session is already cleared, so only signing in
/// again closes it. It sits above the router's navigator
/// (`MaterialApp.router`'s `builder`), so it is drawn over every route
/// without being one.
class SessionExpiredGate extends StatelessWidget {
  const SessionExpiredGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SessionExpiredCubit>(),
      child: BlocBuilder<SessionExpiredCubit, SessionExpiredState>(
        builder: (context, state) => Stack(
          children: [
            ExcludeSemantics(excluding: state.notice != null, child: child),
            if (state.notice case final notice?)
              _SignOutNoticeDialog(notice: notice),
          ],
        ),
      ),
    );
  }
}

class _SignOutNoticeDialog extends StatelessWidget {
  const _SignOutNoticeDialog({required this.notice});

  final SignOutNotice notice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final expired = notice == .expired;
    return Stack(
      children: [
        // Not dismissible: the session is gone, so only signing in closes
        // it, and the gate sits above the navigator a dismiss would pop.
        ModalBarrier(color: context.colors.scrim, dismissible: false),
        Center(
          child: MonAIAlertDialog(
            title: expired
                ? l10n.sessionExpiredTitle
                : l10n.passwordChangedTitle,
            message: expired
                ? l10n.sessionExpiredBody
                : l10n.passwordChangedBody,
            confirmLabel: expired
                ? l10n.sessionExpiredSignIn
                : l10n.passwordChangedSignIn,
            onConfirm: () =>
                context.read<SessionExpiredCubit>().signInAgainPressed(),
            icon: expired ? MonAIIcons.lockClock : MonAIIcons.lock,
            tone: .info,
          ),
        ),
      ],
    );
  }
}
