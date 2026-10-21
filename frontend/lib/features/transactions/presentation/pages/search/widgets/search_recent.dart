import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/transactions/presentation/pages/search/bloc/search_bloc.dart';

/// While the search box is blank: the recent searches, or what to search
/// for when there are none.
class SearchRecent extends StatelessWidget {
  const SearchRecent({required this.onUse, super.key});

  final ValueChanged<String> onUse;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocSelector<SearchBloc, SearchState, List<String>>(
      selector: (state) => state.recentSearches,
      builder: (context, recent) {
        if (recent.isEmpty) {
          return Center(
            child: Padding(
              padding: const .symmetric(horizontal: MonAISpacing.x10),
              child: MonAIStateMessage(
                icon: MonAIIcons.search,
                title: l10n.searchPromptTitle,
                message: l10n.searchPromptBody,
              ),
            ),
          );
        }
        return ListView(
          padding: const .all(MonAISpacing.screenHorizontal),
          children: [
            Text(
              l10n.searchRecentTitle.toUpperCase(),
              style: context.textTheme.labelSmall?.copyWith(
                color: c.textTertiary,
              ),
            ),
            const SizedBox(height: MonAISpacing.x2),
            Wrap(
              spacing: MonAISpacing.x2,
              runSpacing: MonAISpacing.x2,
              children: recent
                  .map(
                    (query) =>
                        _RecentChip(query: query, onTap: () => onUse(query)),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

class _RecentChip extends StatelessWidget {
  const _RecentChip({required this.query, required this.onTap});

  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: MonAIRadius.fullAll,
        side: BorderSide(color: c.border),
      ),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const .symmetric(
            horizontal: MonAISpacing.x3,
            vertical: MonAISpacing.x2,
          ),
          child: Row(
            mainAxisSize: .min,
            spacing: MonAISpacing.x1_5,
            children: [
              MonAIIcon(
                MonAIIcons.history,
                size: MonAISizes.iconSm,
                color: c.textTertiary,
              ),
              Text(query, style: context.textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
