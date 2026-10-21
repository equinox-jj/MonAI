import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/settings/domain/logic/settings_rules.dart';

/// Indonesian and English, then how a transaction row reads in the current
/// one. Show it with [showMonAIBottomSheet]; a pick closes it.
class SettingsLanguageSheet extends StatelessWidget {
  const SettingsLanguageSheet({required this.onPick, super.key});

  /// Called with the picked language; the sheet closes after.
  final ValueChanged<AppLanguage> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Following the phone shows its language as picked.
    final selected = shownLanguage(
      Localizations.localeOf(context).languageCode,
    );
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3,
      children: [
        Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x2,
          children: [
            MonAIRadioOption(
              title: l10n.settingsLanguageIndonesian,
              subtitle: l10n.settingsLanguageIndonesianNative,
              selected: selected == .indonesian,
              onTap: () => onPick(.indonesian),
              leading: const _LanguageCode(code: 'ID'),
            ),
            MonAIRadioOption(
              title: l10n.settingsLanguageEnglish,
              subtitle: l10n.settingsLanguageEnglishNative,
              selected: selected == .english,
              onTap: () => onPick(.english),
              leading: const _LanguageCode(code: 'EN'),
            ),
          ],
        ),
        const _LanguagePreview(),
        Text(
          l10n.settingsLanguageNote,
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

class _LanguageCode extends StatelessWidget {
  const _LanguageCode({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: MonAISizes.avatarMedium,
      height: MonAISizes.avatarMedium,
      alignment: .center,
      decoration: BoxDecoration(color: c.surfaceSunken, shape: .circle),
      child: Text(
        code,
        style: context.textTheme.labelLarge?.copyWith(color: c.textSecondary),
      ),
    );
  }
}

/// A sample expense row in the app's current language; decorative, so
/// hidden from screen readers.
class _LanguagePreview extends StatelessWidget {
  const _LanguagePreview();

  static const _sampleAmount = 35000;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceSunken,
          borderRadius: MonAIRadius.mdlAll,
        ),
        child: Padding(
          padding: const .all(MonAISpacing.x3),
          child: Column(
            crossAxisAlignment: .start,
            spacing: MonAISpacing.x2,
            children: [
              Text(
                l10n.settingsLanguagePreview.toUpperCase(),
                style: context.textStyles.overline.copyWith(
                  color: c.textTertiary,
                ),
              ),
              Row(
                spacing: MonAISpacing.x3,
                children: [
                  MonAICategoryIcon(
                    icon: MonAIIcons.restaurant,
                    color: c.expense,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          l10n.settingsLanguagePreviewTitle,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        Text(
                          l10n.settingsLanguagePreviewMeta,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: c.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatRupiahSigned(_sampleAmount, negative: true),
                    style: context.textStyles.amount.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
