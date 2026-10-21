import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/features/settings/presentation/app_settings/cubit/app_settings_cubit.dart';
import 'package:monai/features/settings/presentation/pages/settings/model/settings_text.dart';

/// System, Light and Dark side by side, each drawn as a tiny screen in its
/// colors. Show it with [showMonAIBottomSheet]; a pick closes it.
class SettingsThemeSheet extends StatelessWidget {
  const SettingsThemeSheet({required this.onPick, super.key});

  /// Called with the picked theme; the sheet closes after.
  final ValueChanged<AppThemeMode> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3_5,
      children: [
        BlocSelector<AppSettingsCubit, AppSettingsState, AppThemeMode>(
          selector: (state) => state.themeMode,
          builder: (context, selected) => Row(
            crossAxisAlignment: .start,
            spacing: MonAISpacing.x3,
            children: [
              Expanded(
                child: _ThemeOption(
                  mode: .system,
                  selected: selected == .system,
                  onPick: onPick,
                ),
              ),
              Expanded(
                child: _ThemeOption(
                  mode: .light,
                  selected: selected == .light,
                  onPick: onPick,
                ),
              ),
              Expanded(
                child: _ThemeOption(
                  mode: .dark,
                  selected: selected == .dark,
                  onPick: onPick,
                ),
              ),
            ],
          ),
        ),
        Text(
          l10n.settingsThemeNote,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
        MonAIButton(
          label: l10n.settingsDone,
          onPressed: () => Navigator.pop(context),
          variant: .tonal,
          size: .medium,
          expand: true,
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.mode,
    required this.selected,
    required this.onPick,
  });

  final AppThemeMode mode;
  final bool selected;
  final ValueChanged<AppThemeMode> onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: InkWell(
        onTap: () => onPick(mode),
        borderRadius: MonAIRadius.lgAll,
        child: Column(
          spacing: MonAISpacing.x2,
          children: [
            AspectRatio(
              aspectRatio: 0.75,
              child: DecoratedBox(
                position: .foreground,
                decoration: BoxDecoration(
                  borderRadius: MonAIRadius.lgAll,
                  border: Border.all(
                    color: selected ? c.focus : c.border,
                    width: selected
                        ? MonAISizes.borderFocused + 1
                        : MonAISizes.border,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: MonAIRadius.lgAll,
                  child: Row(
                    crossAxisAlignment: .stretch,
                    children: [
                      if (mode != .dark)
                        Expanded(
                          child: _MiniScreen(palette: MonAIColors.light),
                        ),
                      if (mode != .light)
                        Expanded(child: _MiniScreen(palette: MonAIColors.dark)),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: .center,
              spacing: MonAISpacing.x1,
              children: [
                MonAIIcon(
                  selected
                      ? MonAIIcons.radioButtonChecked
                      : MonAIIcons.radioButtonUnchecked,
                  size: MonAISizes.iconMd,
                  color: selected ? c.accent : c.textDisabled,
                ),
                Flexible(
                  child: Text(
                    mode.label(context.l10n),
                    style: context.textTheme.titleSmall?.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A header bar, two cards and a button, in [palette]'s colors whatever the
/// app's theme.
class _MiniScreen extends StatelessWidget {
  const _MiniScreen({required this.palette});

  final MonAIColors palette;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: palette.background,
      child: Padding(
        padding: const .all(MonAISpacing.x2),
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x1_5,
          children: [
            FractionallySizedBox(
              alignment: .centerLeft,
              widthFactor: 0.6,
              child: _Bar(
                color: palette.textPrimary,
                height: MonAISpacing.x1_5,
              ),
            ),
            Expanded(child: _Bar(color: palette.surface)),
            Expanded(child: _Bar(color: palette.surface)),
            Align(
              alignment: .centerRight,
              child: Container(
                width: MonAISpacing.x3,
                height: MonAISpacing.x3,
                decoration: BoxDecoration(
                  color: palette.primary,
                  shape: .circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.color, this.height});

  final Color color;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: MonAIRadius.xsAll),
    );
  }
}
