import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/home/domain/usecase/refresh_home_usecase.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';

/// Replaces the dashboard when the first load failed with nothing cached.
class HomeLoadError extends StatelessWidget {
  const HomeLoadError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const .symmetric(horizontal: MonAISpacing.x10),
        child: BlocSelector<HomeBloc, HomeState, (HomeLoadFailure?, bool)>(
          selector: (state) => (state.loadFailure, state.isRefreshing),
          builder: (context, selected) {
            final (failure, isRetrying) = selected;
            return MonAIStateMessage(
              icon: MonAIIcons.error,
              tone: .error,
              title: l10n.homeErrorTitle,
              message: switch (failure) {
                .network => l10n.homeLoadFailedNetwork,
                .unexpected || null => l10n.homeLoadFailedUnexpected,
              },
              actionLabel: l10n.homeTryAgain,
              actionIcon: MonAIIcons.refresh,
              actionLoading: isRetrying,
              onAction: onRetry,
            );
          },
        ),
      ),
    );
  }
}
