import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/app_router.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_review_args.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/bloc/quick_add_bloc.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/model/quick_add_state_extension.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/widgets/quick_add_drafts.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/widgets/quick_add_examples.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/widgets/quick_add_phrase.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/widgets/quick_add_status.dart';
import 'package:monai/route_path.dart';

class QuickAddPage extends StatelessWidget {
  const QuickAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuickAddBloc>()..add(const QuickAddEvent.started()),
      child: const QuickAddUI(),
    );
  }
}

class QuickAddUI extends StatefulWidget {
  const QuickAddUI({super.key});

  @override
  State<QuickAddUI> createState() => _QuickAddUIState();
}

class _QuickAddUIState extends State<QuickAddUI> {
  final _phrase = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _phrase.dispose();
    _focus.dispose();
    super.dispose();
  }

  QuickAddBloc get _bloc => context.read<QuickAddBloc>();

  void _changed(String text) => _bloc.add(QuickAddEvent.textChanged(text));

  void _pickExample(String text) {
    _phrase.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _changed(text);
  }

  void _continue() => _bloc.add(QuickAddEvent.continueRequested(_phrase.text));

  void _close() => context.pop();

  Future<void> _navigate(BuildContext context, QuickAddState state) async {
    switch (state.navigation) {
      case QuickAddFormNavigation(:final draft):
        final saved = await pushQuickAddForm(context, draft);
        if (saved && mounted) _close();
      case QuickAddReviewNavigation(:final args):
        final exit = await context.push<QuickAddReviewExit>(
          RoutePath.quickAddReview,
          extra: args,
        );
        if (!mounted) return;
        switch (exit) {
          case QuickAddReviewExit.home:
            _close();
          case QuickAddReviewExit.startOver:
            _phrase.clear();
            _changed('');
            _focus.requestFocus();
          case null:
        }
      case null:
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return BlocListener<QuickAddBloc, QuickAddState>(
      listenWhen: (previous, current) =>
          current.navigation != null && previous.navigation == null,
      listener: _navigate,
      child: Scaffold(
        backgroundColor: c.background,
        appBar: MonAITopBar(
          title: l10n.quickAddTitle,
          navigation: .close,
          navigationTooltip: l10n.quickAddClose,
          onNavigationPressed: _close,
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const .fromLTRB(
              MonAISpacing.screenHorizontal,
              MonAISpacing.x2,
              MonAISpacing.screenHorizontal,
              MonAISpacing.x4,
            ),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: .stretch,
                      spacing: MonAISpacing.x4,
                      children: [
                        QuickAddPhrase(
                          controller: _phrase,
                          focusNode: _focus,
                          onChanged: _changed,
                          onSubmitted: _continue,
                        ),
                        const QuickAddStatus(),
                        QuickAddExamples(
                          controller: _phrase,
                          onPick: _pickExample,
                        ),
                        const QuickAddDrafts(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: MonAISpacing.x3),
                _ContinueButton(onPressed: _continue),
                const SizedBox(height: MonAISpacing.x2),
                Text(
                  l10n.quickAddFootnote,
                  textAlign: .center,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: c.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<QuickAddBloc, QuickAddState, (int, bool, bool)>(
      selector: (state) =>
          (state.drafts.length, state.isAsking, state.canContinue),
      builder: (context, selected) {
        final (count, isAsking, canContinue) = selected;
        return MonAIButton(
          label: isAsking
              ? l10n.quickAddAsking
              : l10n.quickAddReview(count == 0 ? 1 : count),
          trailingIcon: MonAIIcons.arrowForward,
          loading: isAsking,
          expand: true,
          onPressed: canContinue ? onPressed : null,
        );
      },
    );
  }
}
