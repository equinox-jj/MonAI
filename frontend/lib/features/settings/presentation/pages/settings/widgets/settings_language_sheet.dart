import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/utils/money_format.dart';

/// Holds the pick until Done; [onDone] fires only when it changed.
class SettingsLanguageSheet extends StatefulWidget {
  const SettingsLanguageSheet({
    required this.initial,
    required this.onDone,
    super.key,
  });

  final AppLanguage initial;
  final ValueChanged<AppLanguage> onDone;

  @override
  State<SettingsLanguageSheet> createState() => _SettingsLanguageSheetState();
}

class _SettingsLanguageSheetState extends State<SettingsLanguageSheet> {
  late final _selected = ValueNotifier(widget.initial);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  void _pickIndonesian() => _selected.value = .indonesian;

  void _pickEnglish() => _selected.value = .english;

  void _done() {
    final language = _selected.value;
    if (language == widget.initial) {
      Navigator.pop(context);
    } else {
      widget.onDone(language);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3,
      children: [
        ValueListenableBuilder(
          valueListenable: _selected,
          builder: (context, selected, _) => Column(
            crossAxisAlignment: .stretch,
            spacing: MonAISpacing.x2,
            children: [
              MonAIRadioOption(
                title: l10n.settingsLanguageIndonesian,
                subtitle: l10n.settingsLanguageIndonesianNative,
                selected: selected == .indonesian,
                onTap: _pickIndonesian,
                leading: const _LanguageCode(code: 'ID'),
              ),
              MonAIRadioOption(
                title: l10n.settingsLanguageEnglish,
                subtitle: l10n.settingsLanguageEnglishNative,
                selected: selected == .english,
                onTap: _pickEnglish,
                leading: const _LanguageCode(code: 'EN'),
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _selected,
          builder: (context, selected, _) => Localizations.override(
            context: context,
            locale: Locale(selected.tag!),
            child: const _LanguagePreview(),
          ),
        ),
        Text(
          l10n.settingsLanguageNote,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
        MonAIButton(
          label: l10n.settingsDone,
          onPressed: _done,
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
