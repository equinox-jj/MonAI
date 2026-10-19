import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/auth/presentation/pages/session_expired/cubit/session_expired_cubit.dart';

/// Wraps the app and, once the server rejects the token, covers it with the
/// session-expired dialog. The session is already cleared, so the only way
/// out is to sign in again: outside taps don't dismiss it.
///
/// It sits above the router's navigator (`MaterialApp.router`'s `builder`),
/// so it is drawn over every route without being one.
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
            ExcludeSemantics(excluding: state.expired, child: child),
            if (state.expired) const _SessionExpiredDialog(),
          ],
        ),
      ),
    );
  }
}

class _SessionExpiredDialog extends StatelessWidget {
  const _SessionExpiredDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Stack(
      children: [
        ModalBarrier(color: context.colors.scrim),
        Center(
          child: MonAIAlertDialog(
            title: l10n.sessionExpiredTitle,
            message: l10n.sessionExpiredBody,
            confirmLabel: l10n.sessionExpiredSignIn,
            onConfirm: () =>
                context.read<SessionExpiredCubit>().signInAgainPressed(),
            icon: MonAIIcons.lockClock,
            tone: .info,
          ),
        ),
      ],
    );
  }
}
